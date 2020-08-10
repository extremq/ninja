--[[
    name: initialization.lua
    description: Inits player variables, color, hud, language
]]--

function setColor(playerName)
    id = playerId(playerName)
    local color = 0x40a594
    -- IF BEST TIME
    if playerName == fastestplayer then
        color = 0xEB1D51
    -- ELSEIF FINISHED
    elseif playerVars[playerName].playerFinished == true then
        color = 0xBABD2F
    end

    if modRoom[playerName] == true then
        color = 0x2E72CB
    end

    setNameColor(playerName, color)
end

function calculateLevel(playerName)
    local level, progress, exp
    exp = playerStats[playerName].timesEnteredInHole * 10 + playerStats[playerName].mapsFinished * 30 + 
    playerStats[playerName].hardcoreMaps * 60 + playerStats[playerName].mapsFinishedFirst * 100
    level = math.floor((-1 + math.sqrt(1 + 4 * (2 + exp / 10))) / 2)

    progress = exp - 10 * (level - 1) * (level + 2) .. "/".. 40 + (level - 1) * 20
    return {level, progress}
end

function saveProgress(name)
    playerStats[name].playtime = playerStats[name].playtime + os.time() - playerVars[name].joinTime
    playerVars[name].joinTime = os.time()
    local newData = playerVars[name].cachedData:gsub("¤(.+)¤", "¤"..json.encode(playerStats[name]).."¤")
    system.savePlayerData(name, newData)
    playerVars[name].cachedData = newData
end

function resetSave(playerName)
    playerStats[playerName] = {
        firstJoinTime = os.time(),
        playtime = 0,
        mapsFinished = 0,
        mapsFinishedFirst = 0,
        timesEnteredInHole = 0,
        graffitiSprays = 0,
        timesDashed = 0,
        doubleJumps = 0,
        timesRewinded = 0,
        hardcoreMaps = 0,
        equipment = {1, 1, 1, 1},
        playerPreferences = {true, true, false, true}
    }
end

--[[
for p,_ in pairs(tfm.get.room.playerList) do
    system.savePlayerData(p, " ")
end
]]--

function eventPlayerDataLoaded(playerName, data)
    local ninjaSaveData 
    if data then
        ninjaSaveData = data:match("¤(.+)¤")
    end

    if not ninjaSaveData then
        playerStats[playerName] = {
            firstJoinTime = os.time(),
            playtime = 0,
            mapsFinished = 0,
            mapsFinishedFirst = 0,
            timesEnteredInHole = 0,
            graffitiSprays = 0,
            timesDashed = 0,
            doubleJumps = 0,
            timesRewinded = 0,
            hardcoreMaps = 0,
            equipment = {1, 1, 1, 1},
            playerPreferences = {true, true, false, true}
        }
        
        ninjaSaveData = json.encode(playerStats[playerName])
        data = data .. "¤"..ninjaSaveData.."¤"
        system.savePlayerData(playerName, data)
    end
    playerStats[playerName] = json.decode(ninjaSaveData)
    playerVars[playerName].cachedData = data

    -- only unlock default if we have no savedata
    if unlocks[playerName] == nil then
        unlocks[playerName] = {
            dashAcc = {},
            graffitiCol = {},
            graffitiFonts = {}
        }
        unlocks[playerName].dashAcc[1] = true -- default
        for i = 2, #shop.dashAcc do
            unlocks[playerName].dashAcc[i] = shop.dashAcc[i].fnc(playerName)
        end
        unlocks[playerName].graffitiCol[1] = true -- default
        for i = 2, #shop.graffitiCol do
            unlocks[playerName].graffitiCol[i] =  shop.graffitiCol[i].fnc(playerName)
        end
        unlocks[playerName].graffitiFonts[1] = true -- default
        for i = 2, #shop.graffitiFonts do
            unlocks[playerName].graffitiFonts[i] =  shop.graffitiFonts[i].fnc(playerName)
        end
    end

    if playerStats[playerName].playtime < 40 * 1000 then
        chatMessage("<V>[Sensei]</V> <N>"..translate(playerName, "senseiGreeting1"), playerName)
    end

    loaded[playerName] = true
end

-- CALL THIS WHEN A PLAYER FIRST JOINS A ROOM
function initPlayer(playerName)
    -- ID USED FOR PLAYER OBJECTS
    local id = room.playerList[playerName].id

    playerIds[playerName] = id

    -- NUMBER OF THE PLAYER SINCE MAP WAS CREATED
    globalPlayerCount = globalPlayerCount + 1

    -- IF FIRST PLAYER, (NEW MAP) MAKE ADMIN
    if globalPlayerCount == 1 then
        admin = playerName
    end

    modRoom[playerName] = false
    opList[playerName] = false

    -- BIND MOUSE
    system.bindMouse(playerName, true)

    -- CURRENT PLAYERCOUNT
    -- We don't count souris
    if string.find(playerName, '*') == nil then
        playerCount = playerCount + 1
    end

    -- RESET SCORE
    setPlayerScore(playerName, 0)

    -- INIT PLAYER OBJECTS
    cooldowns[playerName] = {
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

    playerVars[playerName] = {
        joinTime = os.time(),
        playerBestTime = 999999,
        playerLastTime = 999999,
        playerPreferences = {true, true, false, true},
        playerLanguage = "en",
        playerFinished = false,
        rewindPos = {0, 0},
        menuPage = 0,
        helpOpen = false,
        hasDiedThisRound = false,
        hasUsedRewind = false,
        spectate = false,
        shownHelp = false,
        cachedData = nil
    }

    -- If the player finished
    for key, value in pairs(playerSortedBestTime) do
        if value[1] == playerName then
            playerVars[playerName].playerFinished = true
        end
    end

    system.loadPlayerData(playerName)
 
    states[playerName] = {
        jumpState = true,
        dashState = true,
        rewindState = 1
    }

    local jmpid = addImage(JUMP_BTN_ON, "&1", JUMP_BTN_X, JUMP_BTN_Y, playerName)
    local dshid = addImage(DASH_BTN_ON, "&1", DASH_BTN_X, DASH_BTN_Y, playerName)
    local rwdid = addImage(REWIND_BTN_ON, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)
    local hlpid = addImage(HELP_IMG, ":100", 114, 23, playerName)
    addTextArea(10, "<a href='event:CloseWelcome'><font color='transparent'>\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n <font></a>", playerName, 129, 29, 541, 342, 0x324650, 0x000000, 0, true)

    imgs[playerName] = {
        jumpButtonId = jmpid,
        dashButtonId = dshid,
        rewindButtonId = rwdid,
        helpImgId = hlpid,
        mouseImgId = nil,
        menuImgId = nil
    }

    -- items that must be cleared every ui interaction.
    queue[playerName] = {
        img = {},
        area = {}
    }

    -- SET DEFAULT COLOR
    setColor(playerName)
    -- BIND KEYS
    for index, key in pairs(keys) do
        bindKeyboard(playerName, key, true, true)
    end
    -- AUTOMATICALLY CHOOSE LANGUAGE
    chooselang(playerName)
    generateHud(playerName)

    local newPlayerCount = room.uniquePlayers

    if customRoom == false then
        if newPlayerCount > 3 then
            chatMessage(translate(playerName, "enoughPlayers", newPlayerCount), playerName)
        elseif newPlayerCount <= 2 then
            chatMessage(translate(playerName, "notEnoughPlayers", newPlayerCount), playerName)
        elseif newPlayerCount == 3 then
            for key, value in pairs(room.playerList) do
                if loaded[key] == true then
                    chatMessage(translate(key, "statsCount"), key)
                end
            end
            chatMessage(translate(playerName, "statsCount"), playerName)
        end
    else
        chatMessage(translate(playerName, "statsDontCount"), playerName)
    end
end

-- RESET ALL PLAYERS
function resetAll()
    local ostime = os.time()
    playerSortedBestTime = {}
    hasShownStats = false
    fastestplayer = -1
    bestTime = 99999
    playerWon = 0
    --[[
        Manually checking the players that remained in cache, because someone
        might leave when the map is changing and we don't want to use the older time.
        Also reset the death thingy.
    ]]--
    for index, value in pairs(playerVars) do
        playerVars[index].playerBestTime = 999999
        playerVars[index].playerBestTime = 999999
        playerVars[index].hasDiedThisRound = false
        playerVars[index].hasUsedRewind = false
    end

    -- Close stats if they have it opened
    for name, value in pairs(room.playerList) do
        if playerVars[name].menuPage == "roomStats" then
            closePage(name)
        end
        saveProgress(name)
    end

    for playerName in pairs(room.playerList) do
        local id = playerId(playerName)
        --print("Resetting stats for"..playerName)
        setPlayerScore(playerName, 0)
        cooldowns[playerName].lastLeftPressTime = 0
        cooldowns[playerName].lastRightPressTime = 0
        cooldowns[playerName].lastJumpPressTime = 0
        playerVars[playerName].playerFinished = false
        playerVars[playerName].rewindPos = {0, 0, false}
        setColor(playerName)
        -- REMOVE GRAFFITIS
        if id ~= 0 then
            removeTextArea(id)
            cooldowns[playerName].lastGraffitiTime = 0
        end 
        -- UPDATE THE TEXT
        if playerVars[playerName].playerPreferences[3] == true then
            ui.updateTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translate(playerName, "lastBestTime", "N/A"), playerName)
            ui.updateTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translate(playerName, "lastTime", "N/A"), playerName)
        end
    end
    tfm.exec.setGameTime(MAPTIME, true)
end

function chooselang(playerName)
    local id = playerId(playerName)
    local community = room.playerList[playerName].community
    
    if translations[community] ~= nil then
        playerVars[playerName].playerLanguage = translations[community]
    else
        playerVars[playerName].playerLanguage = translations["en"]
    end
end

function generateHud(playerName)
    local id = playerId(playerName)

    removeTextArea(6, playerName)
    -- GENERATE UI
    addTextArea(6, translate(playerName, "helpToolTip"), playerName, 267, 382, 265, 18, 0x324650, 0x000000, 0, true)

    -- SEND HELP message
    chatMessage(translate(playerName, "welcomeInfo").."\n"..translate(playerName, "devInfo").."\n"..translate(playerName, "discordInfo"), playerName)   
end
