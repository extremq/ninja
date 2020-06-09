--[[
    name: events.lua
    description: Contains playerRespawn, playerDied, playerWon, playerLeft and playerJoined
]]--


-- PLAYER COLOR SETTER
function eventPlayerRespawn(playerName)
    local ostime = os.time()
    id = playerId(playerName)
    setColor(playerName)

    -- UPDATE COOLDOWNS
    cooldowns[playerName].lastJumpTime = ostime - JUMPCOOLDOWN
    cooldowns[playerName].lastDashTime = ostime - DASHCOOLDOWN
    cooldowns[playerName].lastRewindTime = ostime - 6000
    cooldowns[playerName].checkpointTime = 0
    cooldowns[playerName].canRewind = false
    -- WHEN RESPAWNED, MAKE THE ABILITIES GREEN
    removeImage(imgs[playerName].jumpButtonId)
    imgs[playerName].jumpButtonId = addImage(JUMP_BTN_ON, "&1", JUMP_BTN_X, JUMP_BTN_Y, playerName)

    removeImage(imgs[playerName].dashButtonId)
    imgs[playerName].dashButtonId = addImage(DASH_BTN_ON, "&1", DASH_BTN_X, DASH_BTN_Y, playerName)
end

function eventPlayerDied(playerName)
    local id = playerId(playerName)
    playerVars[playerName].rewindPos = {0, 0, false}
    -- Remove rewind Mouse
    if imgs[playerName].mouseImgId ~= nil then
        removeImage(imgs[playerName].mouseImgId)
    end
end

-- PLAYER WIN
function eventPlayerWon(playerName, timeElapsed, timeElapsedSinceRespawn)
    local id = playerId(playerName)

    if imgs[playerName].mouseImgId ~= nil then
        removeImage(imgs[playerName].mouseImgId)
    end

    -- If we're a mod, then we don't count the win
    if modRoom[playerName] == true or opList[playerName] == true then
        return
    end

    playerStats[playerName].timesEnteredInHole = playerStats[playerName].timesEnteredInHole + 1

    -- SEND CHAT MESSAGE FOR PLAYER
    chatMessage(translations[playerVars[playerName].playerLanguage].finishedInfo.."(<V>"..(timeElapsedSinceRespawn/100).."s</V>)", playerName)

    if playerVars[playerName].playerFinished == false then
        playerStats[playerName].mapsFinished = playerStats[playerName].mapsFinished + 1
        if mapDiff == 6 then
            playerStats[playerName].hardcoreMaps = playerStats[playerName].hardcoreMaps + 1
        end
        playerWon = playerWon + 1
    end

    setPlayerScore(playerName, 1, true)
    -- RESET TIMERS
    playerVars[playerName].playerLastTime = timeElapsedSinceRespawn
    playerVars[playerName].playerFinished = true
    playerVars[playerName].playerBestTime = math.min(playerVars[playerName].playerBestTime, timeElapsedSinceRespawn)

    --[[
        If the player decides to leave and come back, we need to have his best time saved in a separate array.
        This array will be used for stats at the end of the round, so it must work even if the player left,
        came back, and had worse best time.
    ]]--
    local foundvalue = false
    for i = 1, #playerSortedBestTime do
        if playerSortedBestTime[i][1] == playerName then
            playerSortedBestTime[i][2] = math.min(playerVars[playerName].playerBestTime, playerSortedBestTime[i][2])
            foundvalue = true
        end
    end
    -- If this is the first time the player finishes the map, we take it as a best time.
    if foundvalue == false then
        table.insert(playerSortedBestTime, {playerName, playerVars[playerName].playerBestTime})
    end

    -- UPDATE "YOUR TIME"
    ui.updateTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[playerName].playerLanguage].lastTime..": "..(timeElapsedSinceRespawn/100).."s", playerName)
    ui.updateTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[playerName].playerLanguage].lastBestTime..": "..(playerVars[playerName].playerBestTime/100).."s", playerName)

    -- bestTime is a global variable for record
    if timeElapsedSinceRespawn <= bestTime then
        bestTime = timeElapsedSinceRespawn

        if fastestplayer ~= -1 then
            local oldFastestPlayer = fastestplayer

            fastestplayer = playerName

            setColor(oldFastestPlayer)
        else
            fastestplayer = playerName
        end

        -- send message to everyone in their language
        for index, value in pairs(room.playerList) do
            local _id = room.playerList[index].id
            local message = "<font color='#CB546B'>"..fastestplayer..translations[playerVars[index].playerLanguage].newRecord.." ("..(bestTime/100).."s)</font>"
            chatMessage(message, index)
            --print(message)
        end
    end
end

function eventPlayerLeft(playerName)
    -- Throws an error if i retrieve playerId from room
    local id = playerIds[playerName]
    for player, data in pairs(room.playerList) do
        removeTextArea(id, player)
    end

    -- We don't count souris
    if string.find(playerName, '*') then
        return
    end
    playerCount = playerCount - 1
end

-- WHEN SOMEBODY JOINS, INIT THE PLAYER
function eventNewPlayer(playerName)
    initPlayer(playerName)
end