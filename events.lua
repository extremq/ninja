--[[
    name: events.lua
    description: Contains playerRespawn, playerDied, playerWon, playerLeft and playerJoined
]]--


-- PLAYER COLOR SETTER
eventPlayerRespawn = secureWrapper(function(playerName)
    local ostime = os.time()
    id = playerId(playerName)
    setColor(playerName)

    playerVars[playerName].hasDiedThisRound = true
    playerVars[playerName].hasUsedRewind = false
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

    if playerStats[playerName].timesEnteredInHole < 1 and math.random() < 1/5 then
        chatMessage("<CEP>&gt; [int] [<O>Sensei</O>] "..translate(playerName, "senseiTip"..math.random(1, 3), playerName), playerName)
    end
end, true)

eventPlayerDied = secureWrapper(function(playerName)
    local id = playerId(playerName)
    playerVars[playerName].rewindPos = {0, 0, false}
    playerVars[playerName].hasDiedThisRound = true
    -- Remove rewind Mouse
    if imgs[playerName].mouseImgId ~= nil then
        removeImage(imgs[playerName].mouseImgId)
    end
end, true)

-- PLAYER WIN
eventPlayerWon = secureWrapper(function(playerName, timeElapsed, timeElapsedSinceRespawn)
    local id = playerId(playerName)

    if imgs[playerName].mouseImgId ~= nil then
        removeImage(imgs[playerName].mouseImgId)
    end

    -- SEND CHAT MESSAGE FOR PLAYER
    local finishTime = timeElapsedSinceRespawn
    if playerVars[playerName].hasDiedThisRound == false then
        -- We don't count the starting 3 seconds
        finishTime = finishTime - 3 * 100
    end

    chatMessage(translate(playerName, "finishedInfo", finishTime/100), playerName)

    if playerName:sub(1,1) == "*" then return end

    -- If we're a mod, then we don't count the win or if you rewind
    if modRoom[playerName] == true or opList[playerName] == true then
        return
    elseif playerVars[playerName].hasUsedRewind == true then
        tfm.exec.chatMessage(translate(playerName, "dontRewind"), playerName)
        return
    end

    local beforeLevel = calculateLevel(playerName)[1]

    if tfm.get.room.uniquePlayers > 2 and customRoom == false then 
        playerStats[playerName].timesEnteredInHole = playerStats[playerName].timesEnteredInHole + 1

        if playerVars[playerName].playerFinished == false then
                playerStats[playerName].mapsFinished = playerStats[playerName].mapsFinished + 1
                if mapDiff == 6 then
                    playerStats[playerName].hardcoreMaps = playerStats[playerName].hardcoreMaps + 1
                    -- Check achievement
                    checkUnlock(playerName, "dashAcc", 5, "particleUnlock")
                end
            
                checkUnlock(playerName, "dashAcc", 2, "particleUnlock")
                checkUnlock(playerName, "dashAcc", 4, "particleUnlock")
                checkUnlock(playerName, "graffitiCol", 2, "graffitiColorUnlock")
            
            playerWon = playerWon + 1
        end
    end
    setPlayerScore(playerName, 1, true)
    -- RESET TIMERS
    playerVars[playerName].playerLastTime = finishTime
    playerVars[playerName].playerFinished = true
    playerVars[playerName].playerBestTime = math.min(playerVars[playerName].playerBestTime, finishTime)

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
        playerSortedBestTime[#playerSortedBestTime + 1] = {playerName, playerVars[playerName].playerBestTime}
    end

    -- UPDATE "YOUR TIME"
    ui.updateTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translate(playerName, "lastTime", finishTime/100), playerName)
    ui.updateTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translate(playerName, "lastBestTime", playerVars[playerName].playerBestTime/100), playerName)

    -- bestTime is a global variable for record
    if finishTime <= bestTime then
        bestTime = finishTime
        
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
            local message = translate(index, "newRecord", removeTag(fastestplayer).."<font size='-3'><g>"..fastestplayer:match("#%d+").."</g></font>", bestTime/100)
            chatMessage(message, index)
            --print(message)
        end
        
        if math.random() < 1/2 then
            chatMessage("<CEP>&gt; [int] [<O>Sensei</O>] "..translate(playerName, "senseiRecord"..math.random(1, 8), playerName), playerName)
        end
    end
    
    local afterLevel = calculateLevel(playerName)[1]
    if afterLevel > beforeLevel then 
        for index, value in pairs(room.playerList) do
            local message = translate(index, "levelUp", removeTag(playerName).."<font size='-3'><g>"..playerName:match("#%d+").."</g></font>", afterLevel)
            chatMessage(message, index)
        end
    end
end, true)

function eventPlayerLeft(playerName)
    for key, value in pairs(modList) do
        chatMessage("<D><b>Ξ</b> "..playerName.." Left.</d>", key)
    end
    saveProgress(playerName)
    inRoom[playerName] = nil
    loaded[playerName] = nil
    -- Throws an error if i retrieve playerId from room
    local id = playerIds[playerName]
    for player, data in pairs(room.playerList) do
        removeTextArea(id, player)
    end

    if room.uniquePlayers == 2 then
        for key, value in pairs(room.playerList) do
            chatMessage(translate(key, "statsDontCount"), key)
        end
    end

    -- We don't count souris
    if string.find(playerName, '*') then
        return
    end
    playerCount = playerCount - 1
end

-- WHEN SOMEBODY JOINS, INIT THE PLAYER
function eventNewPlayer(playerName)
    inRoom[playerName] = true
    loaded[playerName] = nil
    initPlayer(playerName)
    for key, value in pairs(modList) do
        chatMessage("<D><b>Ξ</b> "..playerName.." Joined.</D>", key)
    end
end