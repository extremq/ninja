-- LOCALS FOR SPEED
local room = tfm.get.room
local displayParticle = tfm.exec.displayParticle 
local movePlayer = tfm.exec.movePlayer 
local setNameColor = tfm.exec.setNameColor
local addImage = tfm.exec.addImage
local bindKeyboard = system.bindKeyboard
local chatMessage = tfm.exec.chatMessage
local removeImage = tfm.exec.removeImage
local killPlayer = tfm.exec.killPlayer
local setPlayerScore = tfm.exec.setPlayerScore
local setMapName = ui.setMapName
local random = math.random
local addTextArea = ui.addTextArea
local removeTextArea = ui.removeTextArea

-- addImage = function() end
-- removeImage = function() end

local translations = {}
{% require-dir "translations" %}

-- mapcode, difficulty
mapCodes = {{"@7725753", 2}, {"@7726015", 0}, {"@7726744", 1}, {"@7728063", 3}, {"@7731641", 1}, {"@7730637", 2}, {"@7732486", 1}}
mapsLeft = {{"@7725753", 2}, {"@7726015", 0}, {"@7726744", 1}, {"@7728063", 3}, {"@7731641", 1}, {"@7730637", 2}, {"@7732486", 1}}
-- mapCodes = {"@7732115"}
-- mapsLeft = {"@7732115"}

modList = {"Extremq#0000", "Railysse#0000"}
modRoom = {}
opList = {}
lastMap = ""
mapWasSkipped = false
mapStartTime = 0
mapDiff = 0

--CONSTANTS
MAPTIME = 4 * 60
BASETIME = MAPTIME -- after difficulty
STATSTIME = 10 * 1000
DASHCOOLDOWN = 1 * 1000
JUMPCOOLDOWN = 3 * 1000
REWINDCOOLDONW = 10 * 1000
GRAFFITICOOLDOWN = 60 * 1000
DASH_BTN_X = 675
DASH_BTN_Y = 340
JUMP_BTN_X = 740
JUMP_BTN_Y = 340
REWIND_BTN_X = 740
REWIND_BTN_Y = 275
MENU_BTN_X = 15
MENU_BTN_Y = 82

DASH_BTN_OFF = "172514f110f.png"
DASH_BTN_ON = "172514f2882.png"
JUMP_BTN_OFF = "172514f3ff1.png"
JUMP_BTN_ON = "172514f9089.png"
REWIND_BTN_OFF = "1725150689b.png"
REWIND_BTN_ON = "1725150800e.png"
REWIND_BTN_ACTIVE = "17257e94902.png"
HELP_IMG = "172533e3f7b.png"
CHECKPOINT_MOUSE = "17257fd86f3.png"
MENU_BUTTONS = "1725ce45065.png"

-- CHOOSE MAP
function randomMap()  
    -- DELETE THE CHOSEN MAP
    if #mapsLeft == 0 then
        for key, value in pairs(mapCodes) do
            table.insert(mapsLeft, value)
        end
    end
    local pos = random(1, #mapsLeft)
    local newMap = mapsLeft[pos]
    -- IF THE MAPS ARE THE SAME, PICK AGAIN
    if newMap[1] == lastMap then
        table.remove(mapsLeft, pos)
        pos = random(1, #mapsLeft)
        newMap = mapsLeft[pos]
        table.insert(mapsLeft, lastMap)
    end
    table.remove(mapsLeft, pos)
    lastMap = newMap[1]
    mapDiff = newMap[2]
    MAPTIME = BASETIME + mapDiff * 30
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

tfm.exec.disableAutoTimeLeft(true)
tfm.exec.disableAutoScore(true)
tfm.exec.disableAutoShaman(true)
tfm.exec.disableAfkDeath(true)
tfm.exec.disableAutoNewGame(true)
tfm.exec.setAutoMapFlipMode(randomFlip())
tfm.exec.newGame(randomMap())
tfm.exec.disablePhysicalConsumables(true)
system.disableChatCommandDisplay()
tfm.exec.setGameTime(MAPTIME, true)

keys = {0, 1, 2, 3, 32, 67, 71, 72, 77, 84, 88}
bestTime = 99999

playerStats = {
    -- {
    --     mapsFinished = 0,
    --     mapsFinishedFirst = 0,
    --     timesEnteredInHole = 0,
    --     graffitiSprays = 0,
    --     timesDashed = 0,
    --     timesRewinded = 0
    -- }
}

cooldowns = {
    -- id = {
    --     lastDashTime = 0,
    --     lastJumpTime = 0,
    --     lastRewindTime = 0,
    --     lastGraffitiTime = 0,
    --     lastLeftPressTime = 0,
    --     lastRightPressTime = 0,
    --     lastJumpPressTime = 0,
    --     checkpointTime = 0,
    --     canRewind = false
    -- }
}

imgs = {
    -- id = {
    --     jumpButtonId = 0,
    --     dashButtonId = 0,
    --     rewindButtonId = 0,
    --     helpImgId = 0,
    --     mouseImgId = 0,
    --     menuImgId = 0
    -- }
}

-- For efficiency
states = {
    -- id = {
    --     jumpState = false,
    --     dashState = false,
    --     rewindState = false
    -- }
}

playerVars = {
    -- id = {
    --     playerBestTime = 0,
    --     playerLastTime = 0,
    --     playerPreferences = {false, true, false},
    --     playerLanguage = "en",
    --     playerFinished = false,
    --     rewindPos = {x, y},
    --     menuPage = 0,
    --     helpOpen = false
    -- }
}
globalPlayerCount = 0
-- SCORE OF PLAYER
fastestplayer = -1
playerSortedBestTime = {}
-- TRUE/FALSE
playerCount = 0
playerWon = 0
mapfinished = false
admin = ""
customRoom = false
hasShownStats = false

-- RETURN PLAYER ID
function playerId(playerName)
    return room.playerList[playerName].id
end

function checkMod(playerName)
    for index, name in pairs(modList) do
        if name == playerName then
            return true
        end
    end
    return false
end

function checkRoomMod(playerName)
    for index, name in pairs(modRoom) do
        if name == playerName then
            return true
        end
    end
    return false
end

-- MOUSE POWERS
function eventKeyboard(playerName, keyCode, down, xPlayerPosition, yPlayerPosition)
    local id = playerId(playerName)

    if id == 0 then
        return
    end

    local ostime = os.time()
    -- DOUBLE PRESS --
    if ostime - cooldowns[id].lastDashTime > DASHCOOLDOWN then
        dashUsed = false
        if ostime - cooldowns[id].lastRightPressTime < 200 and room.playerList[playerName].isDead == false then
            -- DASHES textarea = 2--
            if keyCode == 2 then
                cooldowns[id].lastRightPressTime = ostime
                for name, data in pairs(room.playerList) do
                    if room.playerList[name].id ~= 0 and playerVars[room.playerList[name].id].playerPreferences[2] == true then
                        displayParticle(3, xPlayerPosition, yPlayerPosition, random(), random(), 0, 0, name)
                        displayParticle(3, xPlayerPosition, yPlayerPosition, random(), -random(), 0, 0, name)
                        displayParticle(3, xPlayerPosition, yPlayerPosition, random(), -random(), 0, 0, name)
                        displayParticle(3, xPlayerPosition, yPlayerPosition, random(), -random(), 0, 0, name)
                    end
                end
                movePlayer(playerName, 0, 0, true, 150, 0, false)
                dashUsed = true;
            end
        end
        if ostime - cooldowns[id].lastLeftPressTime < 200 and room.playerList[playerName].isDead == false then
            if keyCode == 0 then
                cooldowns[id].lastLeftPressTime = ostime
                for name, data in pairs(room.playerList) do
                    if room.playerList[name].id ~= 0 and playerVars[room.playerList[name].id].playerPreferences[2] == true then
                        displayParticle(3, xPlayerPosition, yPlayerPosition, -random(), random(), 0, 0, name)
                        displayParticle(3, xPlayerPosition, yPlayerPosition, -random(), -random(), 0, 0, name)
                        displayParticle(3, xPlayerPosition, yPlayerPosition, -random(), -random(), 0, 0, name)
                        displayParticle(3, xPlayerPosition, yPlayerPosition, -random(), -random(), 0, 0, name)
                    end
                end
                movePlayer(playerName, 0, 0, true, -150, 0, false)
                dashUsed = true;
            end
        end

        if dashUsed == true then
            cooldowns[id].lastDashTime = ostime
            states[id].dashState = false
            removeImage(imgs[id].dashButtonId)
            imgs[id].dashButtonId = addImage(DASH_BTN_OFF, "&1", DASH_BTN_X, DASH_BTN_Y, playerName)
            playerStats[id].timesDashed = playerStats[id].timesDashed + 1
        end
    end
    if ostime - cooldowns[id].lastJumpPressTime < 200 and room.playerList[playerName].isDead == false then
        -- JUMP textarea = 1--
        if (keyCode == 1) and ostime - cooldowns[id].lastJumpTime > JUMPCOOLDOWN then
            cooldowns[id].lastJumpPressTime = ostime

            movePlayer(playerName, 0, 0, true, 0, -60, false)
            for name, data in pairs(room.playerList) do
                if room.playerList[name].id ~= 0 and playerVars[room.playerList[name].id].playerPreferences[2] == true then
                    displayParticle(3, xPlayerPosition, yPlayerPosition, random(), -random()*4, 0, 0, name)
                    displayParticle(3, xPlayerPosition, yPlayerPosition, -random(), -random()*3, 0, 0, name)
                    displayParticle(3, xPlayerPosition, yPlayerPosition, -random(), -random()*2, 0, 0, name)
                    displayParticle(3, xPlayerPosition, yPlayerPosition, random(), -random()*2, 0, 0, name)
                end
            end
            states[id].jumpState = false
            cooldowns[id].lastJumpTime = ostime

            removeImage(imgs[id].jumpButtonId)
            imgs[id].jumpButtonId = addImage(JUMP_BTN_OFF, "&1", JUMP_BTN_X, JUMP_BTN_Y, playerName)
        end
    end

    if keyCode == 32 then
        if cooldowns[id].canRewind == true then
            movePlayer(playerName, playerVars[id].rewindPos[1], playerVars[id].rewindPos[2], false, 0, 0, false)
            cooldowns[id].lastRewindTime = ostime
            cooldowns[id].canRewind = false

            removeImage(imgs[id].rewindButtonId)
            imgs[id].rewindButtonId = addImage(REWIND_BTN_ACTIVE, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)

            removeImage(imgs[id].mouseImgId)

            displayParticle(36, xPlayerPosition, yPlayerPosition, 0, 0, 0, 0, nil)
            displayParticle(2, xPlayerPosition, xPlayerPosition, -random(), random(), 0, 0, playerName)
            displayParticle(2, xPlayerPosition, xPlayerPosition, -random(), -random(), 0, 0, playerName)
            displayParticle(2, xPlayerPosition, xPlayerPosition, -random(), -random(), 0, 0, playerName)
            displayParticle(2, xPlayerPosition, xPlayerPosition, random(), -random(), 0, 0, playerName)
            if playerVars[id].rewindPos[3] == false then
                tfm.exec.removeCheese(playerName)
            end

            playerStats[id].timesRewinded = playerStats[id].timesRewinded + 1

        elseif ostime - cooldowns[id].lastRewindTime > REWINDCOOLDONW and room.playerList[playerName].isDead == false then
            cooldowns[id].canRewind = true
            cooldowns[id].checkpointTime = ostime
            playerVars[id].rewindPos = {xPlayerPosition, yPlayerPosition, room.playerList[playerName].hasCheese}

            imgs[id].mouseImgId = addImage(CHECKPOINT_MOUSE, "_100", xPlayerPosition - 59/2, yPlayerPosition - 73/2, playerName)       
            removeImage(imgs[id].rewindButtonId)
            imgs[id].rewindButtonId = addImage(REWIND_BTN_OFF, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)

            
            displayParticle(2, playerVars[id].rewindPos[1], playerVars[id].rewindPos[2], -random(), random(), 0, 0, playerName)
            displayParticle(2, playerVars[id].rewindPos[1], playerVars[id].rewindPos[2], -random(), -random(), 0, 0, playerName)
            displayParticle(2, playerVars[id].rewindPos[1], playerVars[id].rewindPos[2], -random(), -random(), 0, 0, playerName)
            displayParticle(2, playerVars[id].rewindPos[1], playerVars[id].rewindPos[2], random(), -random(), 0, 0, playerName)
        end
    end 
    -- OPEN GUIDE / HELP
    if keyCode == 72 then
        if playerVars[id].helpOpen == false then
            if playerVars[id].menuPage ~= 0 then
                playerVars[id].menuPage = "help"
                updatePage("#ninja", translations[playerVars[id].playerLanguage].helpBody, playerName)
            else
                createPage("#ninja", translations[playerVars[id].playerLanguage].helpBody, playerName)
            end
            playerVars[id].helpOpen = true 
        elseif playerVars[id].helpOpen == true then
            closePage(playerName)
            playerVars[id].helpOpen = false 
            playerVars[id].menuPage = 0
        end
    end

    -- MORT ON X
    if keyCode == 88 then
        killPlayer(playerName)
    end

    -- MENU
    if keyCode == 77 then
        if imgs[id].menuImgId == -1 then
            addTextArea(12, "<font color='#E9E9E9' size='10'><a href='event:ShopOpen'>             "..translations[playerVars[id].playerLanguage].shopTitle.."</a>\n\n\n\n<a href='event:StatsOpen'>             "..translations[playerVars[id].playerLanguage].profileTitle.."</a>\n\n\n\n<a href='event:LeaderOpen'>             "..translations[playerVars[id].playerLanguage].leaderboardsTitle.."</a>\n\n\n\n<a href='event:SettingsOpen'>             "..translations[playerVars[id].playerLanguage].settingsTitle.."</a>\n\n\n\n<a href='event:AboutOpen'>             "..translations[playerVars[id].playerLanguage].aboutTitle.."</a>", playerName, 13, 103, 184, 220, 0x324650, 0x000000, 0, true)
            imgs[id].menuImgId = addImage(MENU_BUTTONS, ":10", MENU_BTN_X, MENU_BTN_Y, playerName)
        else
            closePage(playerName)
        end
    end

    -- GRAFFITI
    if keyCode == 67 and ostime - cooldowns[id].lastGraffitiTime > GRAFFITICOOLDOWN  then
        cooldowns[id].lastGraffitiTime = ostime
        removeTextArea(id, nil)
        playerStats[id].graffitiSprays = playerStats[id].graffitiSprays + 1
        addTextArea(id, "<p align='center'><font face='Comic Sans MS' size='16' color='#ffffff'>"..playerName, nil, xPlayerPosition - 300/2, yPlayerPosition - 25/2, 300, 25, 0x324650, 0x000000, 0, false)   
    end

    if keyCode == 2 then
        cooldowns[id].lastRightPressTime = ostime
    end

    if keyCode == 0 then
        cooldowns[id].lastLeftPressTime = ostime
    end

    if keyCode == 1 then
        cooldowns[id].lastJumpPressTime = ostime
    end
end

-- UPDATE REWIND ARRAY
function eventPlayerDied(playerName)
    local id = playerId(playerName)
    playerVars[id].rewindPos = {0, 0, false}
    -- Remove rewind Mouse
    if imgs[id].mouseImgId ~= nil then
        removeImage(imgs[id].mouseImgId)
    end
end

-- UPDATE MAP NAME
function updateMapName(timeRemaining)
    -- in case it hasn't loaded for some reason
    if MAPTIME * 1000 - timeRemaining < 3000 then
        setMapName("Loading...<")
        return
    end

    -- This part is in case anything bad happens to the values (sometimes tfm is crazy :D)
    local floor = math.floor
    local currentmapauthor = ""
    local currentmapcode = ""
    local difficulty = mapDiff

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

    if minutes == nil then
        minutes = "?"
    end

    if seconds == nil then
        minutes = "?"
    end

    if difficulty == nil then
        difficulty = "?"
    end

    if playerCount == nil then
        playerCount = 0
        for name, index in pairs(room.playerList) do
            if name[1] ~= '*' then
                playerCount = playerCount + 1
            end
        end
    end

    --print(currentmapcode.." "..currentmapauthor.." "..playerCount.." "..minutes.." "..seconds)

    local name = currentmapauthor.." <G>-</G><N> "..currentmapcode.."</N> <G>-</G> Level: <J>"..difficulty.."</J>  <G>|<G> <N>Mice:</N> <J>"..playerCount.."</J> <G>|<G> <N>"..minutes..":"..seconds.."</N>"
    -- APPEND FASTEST
    if fastestplayer ~= -1 then
        local record = (bestTime / 100)
        name = name.." <G>|<G> <N2>Record: </N2><R>"..fastestplayer.." - "..record.."s</R>"
    end

    if timeRemaining < 0 then
        name = "STATISTICS TIME!" 
    end 

    name = name.."<"
    setMapName(name)
end

function compare(a,b)
    return a[2] < b[2]
end

function showStats()
    bestPlayers = {{"N/A", "N/A"}, {"N/A", "N/A"}, {"N/A", "N/A"}}
    table.sort(playerSortedBestTime, compare)
    for i = 1, #playerSortedBestTime do
        if i == 4 then
            break
        end
        bestPlayers[i][1] = playerSortedBestTime[i][1]
        bestPlayers[i][2] = playerSortedBestTime[i][2]/100
    end

    local message = "\n\n\n\n\n\n\n<p align='center'>"
    message = message.."<font color='#ffd700' size='24'>1. "..bestPlayers[1][1].." - "..bestPlayers[1][2].."s</font>\n"
    message = message.."<font color='#c0c0c0' size='20'>2. "..bestPlayers[2][1].." - "..bestPlayers[2][2].."s</font>\n"
    message = message.."<font color='#cd7f32' size='18'>3. "..bestPlayers[3][1].." - "..bestPlayers[3][2].."s</font></p>"
    for name, value in pairs(room.playerList) do
        local _id = value.id
        if playerVars[_id].menuPage == 0 then
            createPage(translations[playerVars[_id].playerLanguage].leaderboardsTitle, message, name)
        else
            updatePage(translations[playerVars[_id].playerLanguage].leaderboardsTitle, message, name)
        end
    end
    if bestPlayers[1][1] ~= "N/A" then
        playerStats[room.playerList[bestPlayers[1][1]].id].mapsFinishedFirst = playerStats[room.playerList[bestPlayers[1][1]].id].mapsFinishedFirst + 1
    end
end

-- UI UPDATER & PLAYER RESPAWNER & REWINDER
function eventLoop(elapsedTime, timeRemaining)
    local ostime = os.time()

    updateMapName(MAPTIME * 1000 - (ostime - mapStartTime))
    --print(elapsedTime / 1000)
    
    -- WHEN TIME REACHES 0 CHOOSE ANOTHER MAP
    if (elapsedTime >= MAPTIME * 1000 and elapsedTime < MAPTIME * 1000 + STATSTIME) then
        for index, value in pairs(room.playerList) do
            killPlayer(index)
        end
        if hasShownStats == false then
            hasShownStats = true
            showStats()
        end

    elseif elapsedTime >= MAPTIME * 1000 + 5000 or mapWasSkipped == true then
        mapWasSkipped = false
        --print("Attempting to reset.")
        tfm.exec.setAutoMapFlipMode(randomFlip())
        tfm.exec.newGame(randomMap())
        resetAll()
    else    
        for playerName in pairs(room.playerList) do
            local id = playerId(playerName)
            if id ~= 0 then
                if room.playerList[playerName].isDead == true then
                    -- RESPAWN PLAYER
                    tfm.exec.respawnPlayer(playerName)
                    -- UPDATE COOLDOWNS
                    cooldowns[id].lastJumpTime = ostime - JUMPCOOLDOWN
                    cooldowns[id].lastDashTime = ostime - DASHCOOLDOWN
                    cooldowns[id].lastRewindTime = ostime - 6000
                    cooldowns[id].checkpointTime = 0
                    cooldowns[id].canRewind = false
                    -- WHEN RESPAWNED, MAKE THE ABILITIES GREEN
                    removeImage(imgs[id].jumpButtonId)
                    imgs[id].jumpButtonId = addImage(JUMP_BTN_ON, "&1", JUMP_BTN_X, JUMP_BTN_Y, playerName)

                    removeImage(imgs[id].dashButtonId)
                    imgs[id].dashButtonId = addImage(DASH_BTN_ON, "&1", DASH_BTN_X, DASH_BTN_Y, playerName)
                end
                -- UPDATE UI
                if states[id].jumpState == false and ostime - cooldowns[id].lastJumpTime > JUMPCOOLDOWN then
                    states[id].jumpState = true
                    removeImage(imgs[id].jumpButtonId)
                    imgs[id].jumpButtonId = addImage(JUMP_BTN_ON, "&1", JUMP_BTN_X, JUMP_BTN_Y, playerName)
                    end
                if states[id].dashState == false and ostime - cooldowns[id].lastDashTime > DASHCOOLDOWN then
                    states[id].dashState = true
                    removeImage(imgs[id].dashButtonId)
                    imgs[id].dashButtonId = addImage(DASH_BTN_ON, "&1", DASH_BTN_X, DASH_BTN_Y, playerName)
                end

                if cooldowns[id].canRewind == true and ostime - cooldowns[id].checkpointTime > 3000 then
                    cooldowns[id].canRewind = false
                    cooldowns[id].lastRewindTime = ostime
                    removeImage(imgs[id].mouseImgId)
                    displayParticle(2, playerVars[id].rewindPos[1], playerVars[id].rewindPos[2], -random(), random(), 0, 0, playerName)
                    displayParticle(2, playerVars[id].rewindPos[1], playerVars[id].rewindPos[2], -random(), -random(), 0, 0, playerName)
                    displayParticle(2, playerVars[id].rewindPos[1], playerVars[id].rewindPos[2], -random(), -random(), 0, 0, playerName)
                    displayParticle(2, playerVars[id].rewindPos[1], playerVars[id].rewindPos[2], random(), -random(), 0, 0, playerName)
                end

                if cooldowns[id].canRewind == true and states[id].rewindState ~= 2 then
                    states[id].rewindState = 2
                    removeImage(imgs[id].rewindButtonId)
                    imgs[id].rewindButtonId = addImage(REWIND_BTN_ACTIVE, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)
                elseif cooldowns[id].canRewind == false and states[id].rewindState ~= 1 and ostime - cooldowns[id].lastRewindTime > REWINDCOOLDONW then
                    states[id].rewindState = 1
                    removeImage(imgs[id].rewindButtonId)
                    imgs[id].rewindButtonId = addImage(REWIND_BTN_ON, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)
                elseif states[id].rewindState ~= 3 and ostime - cooldowns[id].lastRewindTime <= REWINDCOOLDONW then
                    states[id].rewindState = 3
                    removeImage(imgs[id].rewindButtonId)
                    imgs[id].rewindButtonId = addImage(REWIND_BTN_OFF, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)
                end
            end
        end
    end
end

-- PLAYER COLOR SETTER
function eventPlayerRespawn(playerName)
    id = playerId(playerName)
    if id == 0 then
        tfm.exec.freezePlayer(playerName)
        return
    end
    setColor(playerName)
end

function setColor(playerName)
    id = playerId(playerName)
    local color = 0x40a594
    -- IF BEST TIME
    if playerName == fastestplayer then
        color = 0xEB1D51
    -- ELSEIF FINISHED
    elseif playerVars[id].playerFinished == true then
        color = 0xBABD2F
    end

    if checkRoomMod(playerName) == true then
        color = 0x2E72CB
    end

    setNameColor(playerName, color)
end

-- PLAYER WIN
function eventPlayerWon(playerName, timeElapsed, timeElapsedSinceRespawn)
    local id = playerId(playerName)

    if imgs[id].mouseImgId ~= nil then
        removeImage(imgs[id].mouseImgId)
    end

    
    cooldowns[id].lastJumpTime = 0
    cooldowns[id].lastDashTime = 0
    
    if checkRoomMod(playerName) == true then
        return
    end

    playerStats[id].timesEnteredInHole = playerStats[id].timesEnteredInHole + 1
    
    -- SEND CHAT MESSAGE FOR PLAYER
    chatMessage(translations[playerVars[id].playerLanguage].finishedInfo..(timeElapsedSinceRespawn/100).."s", playerName)

    if playerVars[id].playerFinished == false then
        playerStats[id].mapsFinished = playerStats[id].mapsFinished + 1
        playerWon = playerWon + 1
    end
    setPlayerScore(playerName, 1, true)
    -- RESET TIMERS
    playerVars[id].playerLastTime = timeElapsedSinceRespawn
    playerVars[id].playerFinished = true
    playerVars[id].playerBestTime = math.min(playerVars[id].playerBestTime, timeElapsedSinceRespawn)
    local foundvalue = false
    for i = 1, #playerSortedBestTime do
        if playerSortedBestTime[i][1] == playerName then
            playerSortedBestTime[i][2] = playerVars[id].playerBestTime
            foundvalue = true
        end
    end
    if foundvalue == false then
        table.insert(playerSortedBestTime, {playerName, playerVars[id].playerBestTime})
    end

    -- UPDATE "YOUR TIME"
    ui.updateTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[id].playerLanguage].lastTime..": "..(timeElapsedSinceRespawn/100).."s", playerName)
    ui.updateTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[id].playerLanguage].lastBestTime..": "..(playerVars[id].playerBestTime/100).."s", playerName)
    
    if timeElapsedSinceRespawn <= bestTime then
        -- CHECK IF FASTEST PLAYER IS IN ROOM
        for playerName in pairs(room.playerList) do
            if playerName == fastestplayer then
                setNameColor(fastestplayer, 0xBABD2F)
            end
        end
        bestTime = timeElapsedSinceRespawn
        fastestplayer = playerName
        
        -- send message
        for index, value in pairs(room.playerList) do
            local _id = room.playerList[index].id
            local message = "<font color='#CB546B'>"..fastestplayer..translations[playerVars[_id].playerLanguage].newRecord.." ("..(bestTime/100).."s)</font>"
            chatMessage(message, index)
            --print(message)
        end
    end
end

function eventPlayerLeft(playerName)
    if playerName[1] == '*' then
        return
    end
    playerCount = playerCount - 1
end

-- CALL THIS WHEN A PLAYER FIRST JOINS A ROOM
function initPlayer(playerName)
    -- ID USED FOR PLAYER ARRAYS
    local id = playerId(playerName)

    if id == 0 then
        killPlayer(playerName)
        return
    end

    -- NUMBER OF THE PLAYER SINCE MAP WAS CREATED
    globalPlayerCount = globalPlayerCount + 1
    -- IF FIRST PLAYER, (NEW MAP) MAKE ADMIN
    if globalPlayerCount == 1 then
        admin = playerName
    end

    -- BIND MOUSE
    system.bindMouse(playerName, true)

    -- CURRENT PLAYERCOUNT
    playerCount = playerCount + 1

    -- RESET SCORE
    setPlayerScore(playerName, 0)

    -- INIT ALL PLAYER TABLES
    cooldowns[id] = {
            lastDashTime = 0,
            lastJumpTime = 0,
            lastRewindTime = 0,
            lastGraffitiTime = 0,
            lastLeftPressTime = 0,
            lastRightPressTime = 0,
            lastJumpPressTime = 0,
            checkpointTime = 0,
            canRewind = false
    }
    
    playerVars[id] = {
        playerBestTime = 999999,
        playerLastTime = 999999,
        playerPreferences = {false, true, false},
        playerLanguage = "en",
        playerFinished = false,
        rewindPos = {0, 0},
        menuPage = 0,
        helpOpen = false
    }

    playerStats[id] = {
        mapsFinished = 0,
        mapsFinishedFirst = 0,
        timesEnteredInHole = 0,
        graffitiSprays = 0,
        timesDashed = 0,
        timesRewinded = 0
    }
    
    states[id] = {
        jumpState = true,
        dashState = true,
        rewindState = 1
    }
   
    local jmpid = addImage(JUMP_BTN_ON, "&1", JUMP_BTN_X, JUMP_BTN_Y, playerName)
    local dshid = addImage(DASH_BTN_ON, "&1", DASH_BTN_X, DASH_BTN_Y, playerName)
    local rwdid = addImage(REWIND_BTN_ON, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)
    local hlpid = addImage(HELP_IMG, ":100", 114, 23, playerName)
    addTextArea(10, "<a href='event:CloseWelcome'><font color='transparent'>\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n <font></a>", playerName, 129, 29, 541, 342, 0x324650, 0x000000, 0, true)
    
    imgs[id] = {
        jumpButtonId = jmpid,
        dashButtonId = dshid,
        rewindButtonId = rwdid,
        helpImgId = hlpid,
        helpImgId = hlpid,
        mouseImgId = nil,
        menuImgId = -1
    }

    -- SET DEFAULT COLOR
    setColor(playerName)
    -- BIND KEYS
    for index, key in pairs(keys) do
        bindKeyboard(playerName, key, true, true)
    end
    -- AUTOMATICALLY CHOOSE LANGUAGE
    chooselang(playerName)
end

function chooselang(playerName)
    local id = playerId(playerName)
    local community = room.playerList[playerName].community
    -- FOR NOW, ONLY RO HAS TRANSLATIONS
    if community == "ro" then
        playerVars[id].playerLanguage = "ro"
    elseif community == "fr" then
        playerVars[id].playerLanguage = "fr"
    else
        playerVars[id].playerLanguage = "en"
    end

    -- GENERATE UI
    addTextArea(6, translations[playerVars[id].playerLanguage].helpToolTip, playerName, 267, 382, 265, 18, 0x324650, 0x000000, 0, true)
    
    -- SEND HELP message
    chatMessage(translations[playerVars[id].playerLanguage].welcomeInfo.."\n"..translations[playerVars[id].playerLanguage].devInfo, playerName)
    --print(translations[playerVars[id].playerLanguage].welcomeInfo)
    --print(translations[playerVars[id].playerLanguage].devInfo)
end

-- WHEN SOMEBODY JOINS, INIT THE PLAYER
function eventNewPlayer(playerName)
    initPlayer(playerName)
end

-- INIT ALL EXISTING PLAYERS (NOT SURE IF WORKS)
for playerName in pairs(room.playerList) do
    initPlayer(playerName)
end

function extractMapDimensions()
    xml = tfm.get.room.xmlMapInfo.xml
    local p = string.match(xml, '<P(.*)/>')
    local x = string.match(p, 'L="(%d+)"')
    if x == nil then
        return 800
    end
    return tonumber(x)
end

function eventMouse(playerName, xMousePosition, yMousePosition)
    local id = playerId(playerName)
    local playerX = room.playerList[playerName].x 
    -- print("click at "..xMousePosition)
    if checkRoomMod(playerName) then
        movePlayer(playerName, xMousePosition, yMousePosition, false, 0, 0, false)
    else
        local uiMouseX = xMousePosition
        local mapX = extractMapDimensions()
        -- print("mapX ".. mapX)
        if playerX > 400 and playerX < mapX - 400 then
            uiMouseX = xMousePosition - (playerX - 400)
        elseif playerX > mapX - 400 then
            uiMouseX = xMousePosition - (mapX - 800)
        end
        -- print("uimouse "..uiMouseX)
        if -100 <= uiMouseX and uiMouseX <= 250 then
            if imgs[id].menuImgId == -1 then
                addTextArea(12, "<font color='#E9E9E9' size='10'><a href='event:ShopOpen'>             "..translations[playerVars[id].playerLanguage].shopTitle.."</a>\n\n\n\n<a href='event:StatsOpen'>             "..translations[playerVars[id].playerLanguage].profileTitle.."</a>\n\n\n\n<a href='event:LeaderOpen'>             "..translations[playerVars[id].playerLanguage].leaderboardsTitle.."</a>\n\n\n\n<a href='event:SettingsOpen'>             "..translations[playerVars[id].playerLanguage].settingsTitle.."</a>\n\n\n\n<a href='event:AboutOpen'>             "..translations[playerVars[id].playerLanguage].aboutTitle.."</a>", playerName, 13, 103, 184, 220, 0x324650, 0x000000, 0, true)
                imgs[id].menuImgId = addImage(MENU_BUTTONS, ":10", MENU_BTN_X, MENU_BTN_Y, playerName)
            else
                closePage(playerName)
            end
        end
    end
end

function createPage(title, body, playerName)
    local id = playerId(playerName)
    if playerVars[id].menuPage ~= "help" then
        playerVars[id].helpOpen = false
    end
    local closebtn = "<p align='center'><font color='#CB546B'><a href='event:CloseMenu'>"..translations[playerVars[id].playerLanguage].Xbtn.."</a></font></p>"
    
    local spaceLength = 40 - #translations[playerVars[id].playerLanguage].Xbtn - #title
    local padding = ""
    for i = 1, spaceLength do 
        padding = padding.." "
    end
    local pagetitle = "<font size='16' face='Lucida Console'>"..title.."<textformat>"..padding.."</textformat>"..closebtn.."</font>\n"
    local pagebody = body
    ui.addTextArea(13, pagetitle..pagebody, playerName, 200, 50, 405, 300, 0x241f13, 0xbfa26d, 0.9, true)
end

function updatePage(title, body, playerName)
    local id = playerId(playerName)
    if playerVars[id].menuPage ~= "help" then
        playerVars[id].helpOpen = false
    end
    local closebtn = "<p align='center'><font color='#CB546B'><a href='event:CloseMenu'>"..translations[playerVars[id].playerLanguage].Xbtn.."</a></font></p>"
    local spaceLength = 40 - #translations[playerVars[id].playerLanguage].Xbtn - #title
    local padding = ""
    for i = 1, spaceLength do 
        padding = padding.." "
    end
    local pagetitle = "<font size='16' face='Lucida Console'>"..title.."<textformat>"..padding.."</textformat>"..closebtn.."</font>\n"
    local pagebody = body
    ui.updateTextArea(13, pagetitle..pagebody, playerName)
end

function closePage(playerName)
    local id = playerId(playerName)
    removeTextArea(13, playerName)
    removeTextArea(12, playerName)
    removeImage(imgs[id].menuImgId)
    playerVars[id].menuPage = 0
    playerVars[id].helpOpen = false
    imgs[id].menuImgId = -1
end

function stats(playerName, playerId, creatorId)
    --     mapsFinished = 0,
    --     mapsFinishedFirst = 0,
    --     timesEnteredInHole = 0,
    --     graffitiSprays = 0,
    --     timesDashed = 0,
    --     timesRewinded = 0
    local body = "\n"
    
    body = body.." » "..translations[playerVars[creatorId].playerLanguage].firsts..": <modRoom>"..playerStats[playerId].mapsFinishedFirst.."</modRoom>\n"
    body = body.." » "..translations[playerVars[creatorId].playerLanguage].finishedMaps..": <modRoom>"..playerStats[playerId].mapsFinished.."</modRoom>\n"
    local firstrate = "0%"
    if playerStats[playerId].mapsFinishedFirst > 0 then
        firstrate = (math.floor(playerStats[playerId].mapsFinishedFirst/playerStats[playerId].mapsFinished * 10000) / 100).."%"
    end
    body = body.." » "..translations[playerVars[creatorId].playerLanguage].firstRate..": <modRoom>"..firstrate.."</modRoom>\n"
    body = body.." » "..translations[playerVars[creatorId].playerLanguage].holeEnters..": <modRoom>"..playerStats[playerId].timesEnteredInHole.."</modRoom>\n"
    body = body.." » "..translations[playerVars[creatorId].playerLanguage].graffitiUses..": <modRoom>"..playerStats[playerId].graffitiSprays.."</modRoom>\n"
    body = body.." » "..translations[playerVars[creatorId].playerLanguage].dashUses..": <modRoom>"..playerStats[playerId].timesDashed.."</modRoom>\n"
    body = body.." » "..translations[playerVars[creatorId].playerLanguage].rewindUses..": <modRoom>"..playerStats[playerId].timesRewinded.."</modRoom>\n"

    return body
end

function eventTextAreaCallback(textAreaId, playerName, eventName)
    local id = playerId(playerName)
    if id == 0 then
        return
    end
    if textAreaId == 12 then
        if eventName == "ShopOpen" then
            if playerVars[id].menuPage == 0 then
                createPage(translations[playerVars[id].playerLanguage].shopTitle, translations[playerVars[id].playerLanguage].shopNotice, playerName)
            else
                updatePage(translations[playerVars[id].playerLanguage].shopTitle, translations[playerVars[id].playerLanguage].shopNotice, playerName)
            end
        end
        if eventName == "StatsOpen" then
            if playerVars[id].menuPage == 0 then
                createPage(translations[playerVars[id].playerLanguage].profileTitle.." - "..playerName, stats(playerName, id, id), playerName)
            else
                updatePage(translations[playerVars[id].playerLanguage].profileTitle.." - "..playerName, stats(playerName, id, id), playerName)
            end
        end
        if eventName == "LeaderOpen" then
            if playerVars[id].menuPage == 0 then
                createPage(translations[playerVars[id].playerLanguage].leaderboardsTitle, translations[playerVars[id].playerLanguage].leaderboardsNotice, playerName)
            else
                updatePage(translations[playerVars[id].playerLanguage].leaderboardsTitle, translations[playerVars[id].playerLanguage].leaderboardsNotice, playerName)
            end
        end
        if eventName == "SettingsOpen" then
            if playerVars[id].menuPage == 0 then
                playerVars[id].menuPage = "settings"
                createPage(translations[playerVars[id].playerLanguage].settingsTitle, remakeOptions(playerName), playerName)
            else
                playerVars[id].menuPage = "settings"
                updatePage(translations[playerVars[id].playerLanguage].settingsTitle, remakeOptions(playerName), playerName)
            end
        end
        if eventName == "AboutOpen" then
            if playerVars[id].menuPage == 0 then
                createPage(translations[playerVars[id].playerLanguage].aboutTitle, translations[playerVars[id].playerLanguage].aboutBody, playerName)
            else
                updatePage(translations[playerVars[id].playerLanguage].aboutTitle, translations[playerVars[id].playerLanguage].aboutBody, playerName)
            end
        end
    end
    
    -- SETTINGS
    if playerVars[id].menuPage == "settings" and textAreaId == 13 then
        if eventName == "ToggleDummy" then
            if playerVars[id].playerPreferences[1] == true then
                playerVars[id].playerPreferences[1] = false
            else
                playerVars[id].playerPreferences[1] = true
            end
        end
        if eventName == "ToggleDashPart" then
            if playerVars[id].playerPreferences[2] == true then
                playerVars[id].playerPreferences[2] = false
            else
                playerVars[id].playerPreferences[2] = true
            end
        end
    
        if eventName == "ToggleTimePanels" then
            if playerVars[id].playerPreferences[3] == true then
                playerVars[id].playerPreferences[3] = false
                removeTextArea(5, playerName)
                removeTextArea(4, playerName)
            else
                -- REGENERATE PANELS
                playerVars[id].playerPreferences[3] = true
                addTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[id].playerLanguage].lastTime..": N/A", playerName, 10, 45, 200, 21, 0xffffff, 0x000000, 0, true)
                addTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[id].playerLanguage].lastBestTime..": N/A", playerName, 10, 30, 200, 21, 0xffffff, 0x000000, 0, true)
                if playerVars[id].playerFinished == true then
                    ui.updateTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[id].playerLanguage].lastTime..": "..(playerVars[id].playerLastTime/100).."s", playerName)
                    ui.updateTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[id].playerLanguage].lastBestTime..": "..(playerVars[id].playerBestTime/100).."s", playerName)
                end
            end
        end
        updatePage(translations[playerVars[id].playerLanguage].settingsTitle, remakeOptions(playerName), playerName)
    end

    if eventName == "CloseMenu" then
        closePage(playerName)
    end

    if eventName == "CloseWelcome" then
        if imgs[id].helpImgId ~= 0 then 
            removeImage(imgs[id].helpImgId)
        end
        removeTextArea(10, playerName)
    end

    if eventName == "CloseHelp" then
        if playerVars[id].helpOpen == true then
            removeTextArea(11, playerName)
            playerVars[id].helpOpen = false
        end
    end
end

function remakeOptions(playerName)
    -- REMAKE OPTIONS TEXT (UPDATE YES - NO)
    local id = playerId(playerName)
    toggles = {translations[playerVars[id].playerLanguage].optionsYes, translations[playerVars[id].playerLanguage].optionsYes, translations[playerVars[id].playerLanguage].optionsYes}
    if playerVars[id].playerPreferences[1] == false then
        toggles[1] = translations[playerVars[id].playerLanguage].optionsNo
    end
    if playerVars[id].playerPreferences[2] == false then
        toggles[2] = translations[playerVars[id].playerLanguage].optionsNo
    end
    if playerVars[id].playerPreferences[3] == false then
        toggles[3] = translations[playerVars[id].playerLanguage].optionsNo
    end
    return " » <a href=\"event:ToggleDummy\">"..translations[playerVars[id].playerLanguage].testSetting.."?</a> "..toggles[1].."\n » <a href=\"event:ToggleDashPart\">"..translations[playerVars[id].playerLanguage].particlesSetting.."?</a> "..toggles[2].."\n » <a href=\"event:ToggleTimePanels\">"..translations[playerVars[id].playerLanguage].timePanelsSetting.."?</a> "..toggles[3]
end

-- RESET ALL PLAYERS
function resetAll()
    local ostime = os.time()
    rewindpos = {}
    playerSortedBestTime = {}
    bestPlayers = {{"N/A", "N/A", "N/A"}, {"N/A", "N/A", "N/A"}, {"N/A", "N/A", "N/A"}}
    hasShownStats = false

    for index, value in pairs(playerVars) do
        playerVars[index].playerBestTime = 999999
        playerVars[index].playerBestTime = 999999
    end

    for playerName in pairs(room.playerList) do
        local id = playerId(playerName)
        if id ~= 0 then
            --print("Resetting stats for"..playerName)
            setPlayerScore(playerName, 0)
            cooldowns[id].lastRewindTime = 0
            cooldowns[id].canRewind = false
            
            cooldowns[id].lastLeftPressTime = 0
            cooldowns[id].lastRightPressTime = 0
            cooldowns[id].lastJumpPressTime = 0
            cooldowns[id].lastDashTime = 0
            cooldowns[id].lastJumpTime = ostime - JUMPCOOLDOWN
            playerVars[id].playerFinished = false
            cooldowns[id].checkpointTime = 0
            states[id].jumpState = true
            states[id].dashState = true


            playerVars[id].rewindPos = {0, 0, false}
            fastestplayer = -1
            bestTime = 99999
            playerWon = 0
            setColor(playerName)
            -- REMOVE GRAFFITIS
            removeTextArea(id)
            cooldowns[id].lastGraffitiTime = 0
            -- UPDATE THE TEXT
            if playerVars[id].playerPreferences[3] == true then
                ui.updateTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[id].playerLanguage].lastBestTime..": N/A", playerName)
                ui.updateTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[id].playerLanguage].lastTime..": N/A", playerName)
            end
            
        else
            killPlayer(playerName)
        end
    end
    tfm.exec.setGameTime(MAPTIME, true)
end

-- DEBUGGING
function eventChatCommand(playerName, message)
    local id = playerId(playerName)
    local ostime = os.time()
    local arg = {}
    for argument in message:gmatch("[^%s]+") do
        table.insert(arg, argument)
    end

    arg[1] = string.lower(arg[1])

    local isValid = false
    local isOp = false
    local isMod = false

    if checkMod(playerName) == true then
        isMod = true
        isOp = true
    end

    for index, name in pairs(opList) do
        if name == playerName then
            isOp = true
        end
    end

    if admin == playerName and customRoom == true then
        isOp = true
    end

    -- OP ONLY ABILITIES (INCLUDES MOD)
    if isOp == true then
        if arg[1] == "m" then
            if arg[2] ~= nil then
                isValid = true
                tfm.exec.newGame(arg[2])
                tfm.exec.setAutoMapFlipMode(randomFlip())
                mapDiff = "Custom"
                MAPTIME = 10 * 60
                resetAll()
            end
        end

        if arg[1] == "n" then
            isValid = true
            hasShownStats = false
            mapWasSkipped = true
            bestPlayers = {{"N/A", "N/A", "N/A"}, {"N/A", "N/A", "N/A"}, {"N/A", "N/A", "N/A"}}
        end
    end

    -- MOD ONLY ABILITIES
    if isMod == true then
        if arg[1] == "mod" then
            isValid = true
            if checkRoomMod(playerName) == false then
                table.insert(modRoom, playerName)
                local message = "You are a mod!"
                --print(message)
                chatMessage(message, playerName)
            else
                for index, name in pairs(modRoom) do
                    if name == playerName then
                        table.remove(modRoom, index)
                        local message = "You are no longer a mod!"
                        --print(message)
                        chatMessage(message, playerName)
                        break
                    end
                end
            end
            setColor(playerName)
        end

        if arg[1] == "op" then
            isValid = true
            if arg[2] ~= nil then
                local wasOp = false

                for index, name in pairs(opList) do
                    if name == arg[2] then
                        table.remove(opList, index)
                        local message = arg[2].." is no longer an operator."
                        --print(arg[2].." is no longer an operator.")
                        chatMessage(message, playerName)
                        wasOp = true
                        break
                    end
                end

                if wasOp == false then
                    table.insert(opList, arg[2])
                    local message = arg[2].." is an operator!"
                    --print(arg[2].." is an operator!")
                    chatMessage(message, playerName)
                end
            end
        end

        if arg[1] == "a" then
            isValid = true
            if arg[2] ~= nil then
                for i = 3, #arg do
                    arg[2] = arg[2].." "..arg[i]
                end
                local message = "<font color='#72b6ff'>#ninja Owner "..playerName..": "..arg[2].."</font>"
                --print(message)
                chatMessage(message)
            end
        end
    end

    if arg[1] == "pw" and playerName == admin then
        isValid = true
        if room.passwordProtected == false and arg[2] ~= nil then
            customRoom = true
            tfm.exec.setRoomPassword(arg[2])
            chatMessage("Password: "..arg[2], playerName)
        else
            customRoom = false
            tfm.exec.setRoomPassword("")
            chatMessage("Password: "..arg[2], playerName)
        end
    end

    if arg[1] == "p" or arg[1] == "profile" and arg[2] ~= nil then
        isValid = true
        for name, value in pairs(room.playerList) do
            if name == arg[2] then
                if playerVars[id].menuPage == 0 then
                    playerVars[id].menuPage = "stats"
                    createPage(translations[playerVars[id].playerLanguage].profileTitle.." - "..arg[2], stats(arg[2], room.playerList[arg[2]].id, id), playerName, id)
                else
                    playerVars[id].menuPage = "stats"
                    updatePage(translations[playerVars[id].playerLanguage].profileTitle.." - "..arg[2], stats(arg[2], room.playerList[arg[2]].id, id), playerName, id)
                end
                break
            end
        end
    end

    if isValid == false then
        chatMessage(arg[1].." "..translations[playerVars[id].playerLanguage].notValidCommand, playerName)
    end
end