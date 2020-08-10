--[[
    name: chatUtils.lua
    description: Contains eventChatMessage and eventChatCommand. Handles chat operations.
]]--

function eventChatMessage(playerName, msg)
    if msg:lower():find("gg") or msg:lower():find("gj") then
        if math.random() < 1/3 then
            chatMessage("<V>[Sensei]</V> <N>"..translate(room.community, "senseiReply"..math.random(1, 8)))
        end
    elseif msg == "." and playerName == "Extremq#0000" then
        chatMessage("<V>[Sensei]</V> <N>.")
    end

    if room.community ~= "en" or string.sub(msg, 1, 1) == "!" then
        return
    end

    local data = room.playerList[playerName]
    local color 

    if playerVars[playerName].playerPreferences[4] == true then
        for name, playerData in pairs(room.playerList) do 
            -- playerName sends, name recieves
            if playerVars[name].playerPreferences[4] == true and playerName ~= name and playerData.community ~= data.community then
                color = "#C2C2DA"
                local separatedName = removeTag(playerName)
                local separatedTag = string.match(playerName, "#%d%d%d%d")
                local coloredName = "<V>["..separatedName.."</V><G><font size='-3'>"..separatedTag.."</font></G><V>]</V>"
                -- if player has been mentioned
                if string.find(string.lower(msg), string.lower(removeTag(name))) ~= nil then
                    color = "#BABD2F"
                end
                chatMessage("<V>["..data.community.."] "..coloredName.."</V> <font color='"..color.."'>"..msg.."</font>", name)
            end
        end
    end
end

-- Chat commands
commands = {"unshaman", "shaman", "kill", "s", "unfreeze", "freeze", "takecheese", "delete", "n", "time", "map", "help", "dev", "profile", "p", "m", "cheese", "a", "langue", "op", "pw", "uptime", "spectate", "spec", "win"}
for i = 1, #commands do
    system.disableChatCommandDisplay(commands[i])
    system.disableChatCommandDisplay(commands[i]:upper())
end

function eventChatCommand(playerName, message)
    local id = playerId(playerName)

    for key, value in pairs(modList) do
        chatMessage("<D><b>Ξ</b> ["..playerName.."] <CS>!"..message, key)
    end

    local ostime = os.time()
    local arg = {}
    for argument in message:gmatch("[^%s]+") do
        arg[#arg + 1] = argument
    end

    arg[1] = string.lower(arg[1])

    local isValid = false
    local isOp = false
    local isDev = false
    local isMod = false

    if devList[playerName] == true then
        isMod = true
        isOp = true
    end

    if opList[playerName] == true then
        isOp = true
    end

    if admin == playerName and customRoom == true then
        isOp = true
    end

    -- OP ONLY ABILITIES (INCLUDES Dev)
    if isOp == true then
        if arg[1] == "m" or arg[1] == "map" then
            if arg[2] ~= nil then
                isValid = true
                tfm.exec.newGame(arg[2])
                tfm.exec.setAutoMapFlipMode(randomFlip())
                mapDiff = "Custom"
                MAPTIME = 4 * 60
                resetAll()
            end
        elseif arg[1] == "n" then
            isValid = true
            hasShownStats = false
            mapWasSkipped = true
            bestPlayers = {{"N/A", "N/A", "N/A"}, {"N/A", "N/A", "N/A"}, {"N/A", "N/A", "N/A"}}
        elseif arg[1] == "time" and arg[2]:match("^%d+$") then
            isValid = true
            MAPTIME = tonumber(arg[2])
            mapStartTime = os.time()
        end
    end

    -- Dev ONLY ABILITIES
    if isMod == true then
        if arg[1] == "dev" then
            isValid = true
            if modRoom[playerName] == false then
                modRoom[playerName] = true
                local message = "You are a dev!"
                --print(message)
                chatMessage(message, playerName)
            else
                modRoom[playerName] = false
                local message = "You are no longer a dev!"
                --print(message)
                chatMessage(message, playerName)
            end
            setColor(playerName)
        elseif arg[1] == "op" then
            isValid = true
            if arg[2] ~= nil then
                if opList[arg[2]] == true then
                    opList[arg[2]] = false
                    local message = arg[2].." is no longer an operator."
                    --print(arg[2].." is no longer an operator.")
                    chatMessage(message, playerName)
                else
                    opList[arg[2]] = true
                    local message = arg[2].." is an operator!"
                    --print(arg[2].." is an operator!")
                    chatMessage(message, playerName)
                end
            end
        elseif arg[1] == "cheese" then
            if not arg[2] then
                arg[2] = playerName
            end
            isValid = true
            tfm.exec.giveCheese(arg[2])
        elseif arg[1] == "a" then
            isValid = true
            if arg[2] ~= nil then
                for i = 3, #arg do
                    arg[2] = arg[2].." "..arg[i]
                end
                local separatedName = removeTag(playerName)
                local separatedTag = string.match(playerName, "#%d%d%d%d")
                local message = "<font color='#5ca5d6'><b>[Dev "..separatedName.."<g><font size='-3'>"..separatedTag.."</font></g>".."]</b></font><font color='#67addb'> "..arg[2]
                chatMessage(message)
            end
        elseif arg[1] == "s" then 
            isValid = true
            if arg[2] ~= nil then
                for i = 3, #arg do
                    arg[2] = arg[2].." "..arg[i]
                end
                chatMessage("<V>[Sensei]</V><N> "..arg[2])
            end
        elseif arg[1] == "win" then
            if not arg[2] then
                arg[2] = playerName
            end
            isValid = true
            tfm.exec.giveCheese(arg[2])
            tfm.exec.playerVictory(arg[2])
        elseif arg[1] == "kill" and arg[2] then
            isValid = true
            killPlayer(arg[2])
        elseif arg[1] == "takecheese" then
            if not arg[2] then
                arg[2] = playerName
            end
            isValid = true
            tfm.exec.removeCheese(arg[2])
        elseif arg[1] == "delete" and arg[2] and arg[3] == "shobi" then
            isValid = true
            resetSave(arg[2])
            saveProgress(arg[2])
        elseif arg[1] == "ban" and arg[2] then
            isValid = true
            for key, value in pairs(playerSortedBestTime) do
                if value[1] == arg[2] then
                    playerSortedBestTime[key] = nil
                    bestTime = 999999
                    fastestplayer = -1
                    return
                end
            end
        elseif arg[1] == "freeze" and arg[2] then
            isValid = true
            tfm.exec.freezePlayer(arg[2], true)
        elseif arg[1] == "unfreeze" and arg[2] then
            isValid = true
            tfm.exec.freezePlayer(arg[2], false)
        elseif arg[1] == "shaman" then
            if not arg[2] then
                arg[2] = playerName
            end
            isValid = true
            tfm.exec.setShaman(arg[2], true)
        end
    end

    if arg[1] == "pw" and playerName == admin then
        isValid = true
        if string.find(room.name, "^[a-z][a-z2]%-#ninja%d+editor%d*$") or string.find(room.name, "^%*?#ninja%d+editor%d*$") then
            if arg[2] ~= nil then
                tfm.exec.setRoomPassword(arg[2])
                chatMessage("Password: "..arg[2], playerName)
            else
                tfm.exec.setRoomPassword("")
                chatMessage("Password removed.", playerName)
            end
        else
            return chatMessage(translate(playerName, "cantSetPass"), player)
        end
    elseif arg[1] == "p" or arg[1] == "profile" then
        isValid = true
        if arg[2] == nil then
            openPage(translate(playerName, "profileTitle"), stats(playerName, playerName), playerName, "profile")
            return
        end

        -- convert extREMQ#0000 to Extremq#0000
        arg[2] = string.upper(string.sub(arg[2], 1, 1))..string.lower(string.sub(arg[2], 2, #arg[2]))
        for name, value in pairs(room.playerList) do
            if name == arg[2] and name:sub(1,1) ~= "*" then
                openPage(translate(playerName, "profileTitle"), stats(arg[2], playerName), playerName, "profile@"..arg[2])
                break
            end
        end
        return
    elseif arg[1] == "langue" then
        isValid = true
        if translations[arg[2]] ~= nil then
            playerVars[playerName].playerLanguage = translations[arg[2]]
            generateHud(playerName)
        else
            local message = "<J>Current languages:"
            for language, _ in pairs(translations) do
                message = message.."\n\t<cs>• "..language
            end
            chatMessage(message, playerName)
        end
    elseif arg[1] == "uptime" then
        isValid = true
        chatMessage("Uptime: "..math.floor(os.time() - roomCreate)/1000)
    elseif arg[1] == "spectate" or arg[1] == "spec" then
        isValid = true
        local curr = playerVars[playerName].spectate
        if curr == false then 
            playerVars[playerName].spectate = true
            tfm.exec.killPlayer(playerName)
        else
            playerVars[playerName].spectate = false
            tfm.exec.respawnPlayer(playerName)
        end
    elseif arg[1] == "help" then
        isValid = true
        -- Help system
        if playerVars[playerName].menuPage ~= "help" then
            openPage("#ninja", "\n<font face='Verdana' size='11'>"..translate(playerName, "helpBody").."</font>", playerName, "help")
        elseif playerVars[playerName].menuPage == "help" then
            closePage(playerName)
        end
    end

    if isValid == false then
        chatMessage(translate(playerName, "notValidCommand", arg[1]), playerName)
    end
end