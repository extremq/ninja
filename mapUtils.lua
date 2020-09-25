--[[
    name: mapUtils.lua
    description: Contains functions that help with the map picker algorithm and title setter.
]]--

MAPTIME = 2 * 60 + 3
BASETIME = MAPTIME -- after difficulty

-- CHOOSE MAP
function randomMap(mapsLeft, mapCodes)
    -- DELETE THE CHOSEN MAP
    if #mapsLeft == 0 then
        for key, value in pairs(mapCodes) do
            mapsLeft[#mapsLeft + 1] = value
        end
    end
    local pos = random(1, #mapsLeft)
    local newMap = mapsLeft[pos]
    -- IF THE MAPS ARE THE SAME, PICK AGAIN
    if newMap[1] == lastMap then
        table.remove(mapsLeft, pos)
        pos = random(1, #mapsLeft)
        newMap = mapsLeft[pos]
        mapsLeft[#mapsLeft + 1] = lastMap
    end
    table.remove(mapsLeft, pos)
    lastMap = newMap[1]
    mapDiff = newMap[2]
    MAPTIME = BASETIME --+ (mapDiff - 1) * 30
    if mapDiff == 6 then
        MAPTIME = BASETIME --+ 60
    elseif mapDiff == 0 then
        MAPTIME = 60
    end
    return newMap[1]
end

-- CHOOSE FLIP
function randomFlip()
    local number = random()
    mapStartTime = os.time()
    if number < 0.5 then
        return true
    else
        return false
    end
end

-- UPDATE MAP NAME (custom timer)
function updateMapName(timeRemaining)
    -- in case it hasn't loaded for some reason, we wait for 3 seconds
    local roomCommunity = room.community
    if MAPTIME * 1000 - timeRemaining < 3000 then
        setMapName(translate(room.community, "infobarLoading").."<")
        return
    end

    local floor = math.floor
    local currentmapauthor = ""
    local currentmapcode = ""
    local difficulty = mapDiff

    -- This part is in case anything bad happens to the values (sometimes tfm is crazy :D)
    if room.xmlMapInfo == nil then
        currentmapauthor = "?"
        currentmapcode = "?"
    else
        currentmapauthor = room.xmlMapInfo.author
        currentmapcode = "@"..room.xmlMapInfo.mapCode
    end

    if timeRemaining == nil then
        timeRemaining = 0
    end

    local minutes = floor((timeRemaining/1000)/60)
    local seconds = (floor(timeRemaining/1000)%60)
    if seconds < 10 then
        seconds = "0"..tostring(seconds)
    end
    if minutes < 10 then
        minutes = "0"..tostring(minutes)
    end

    --print(currentmapcode.." "..currentmapauthor.." "..playerCount.." "..minutes.." "..seconds)

    local difficultyMessage = ""
    if type(difficulty) == "number" then
        difficultyMessage = difficultyMessage.. "<font size='-2'><cs>"
        if difficulty == 6 then
            difficultyMessage = translate(roomCommunity, "infobarHardcore")
        elseif difficulty == 0 then
            difficultyMessage = translate(roomCommunity, "infobarBlitz")
        elseif difficulty > 0 and difficulty < 6 then
            for i = 1, difficulty do 
                difficultyMessage = difficultyMessage.."●"
            end
            difficultyMessage = difficultyMessage.. "<ce>"
            for i = 1, 5 - difficulty do 
                difficultyMessage = difficultyMessage.."○"
            end
            difficultyMessage = difficultyMessage.."</ce></cs></font>"
        end 
    else 
        difficultyMessage = difficultyMessage.."CUSTOM"
    end

    local name = currentmapauthor.." <G>-<N> "..currentmapcode.." <G>-<N> "..difficultyMessage.." <G>| <N>"..translate(roomCommunity, "infobarMice").." <J>"..room.uniquePlayers.." <G>| <N>"..minutes..":"..seconds
    -- Append record
    if fastestplayer ~= -1 then
        local record = (bestTime / 100)
        name = name.." <G>| <N2>"..translate(roomCommunity, "infobarRecord").." <R>"..removeTag(string.gsub(fastestplayer, "([Hh]t)tp", "%1.tp")).."<font size='-3'><g>"..fastestplayer:match("#%d+").."</g></font>".." - "..record.."s"
    end

    -- If the map is over, we show stats
    if timeRemaining < 0 then
        name = translate(roomCommunity, "infobarTimeOver")
    end

    name = name.."<"
    setMapName(name)
end
