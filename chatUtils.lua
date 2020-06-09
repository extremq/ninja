--[[
    name: chatUtils.lua
    description: Contains eventChatMessage and eventChatCommand. Handles chat operations.
]]--

function eventChatMessage(playerName, msg)
    if room.community ~= "en" or string.sub(msg, 1, 1) == "!" then
        return
    end

    local id = playerId(playerName)
    local data = room.playerList[playerName]

    if playerVars[playerName].playerPreferences[4] == true then
        for name, playerData in pairs(room.playerList) do 
            if playerVars[name].playerPreferences[4] == true and playerName ~= name and playerData.community ~= data.community then
                print("<V>["..data.community.."] ["..playerName.."]</V> <font color='#C2C2DA'>"..msg.."</font>")
                chatMessage("<V>["..data.community.."] ["..playerName.."]</V> <font color='#C2C2DA'>"..msg.."</font>", name)
            end
        end
    end
end

-- Chat commands
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

    if modList[playerName] == true then
        isMod = true
        isOp = true
    end

    if opList[playerName] == true then
        isOp = true
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
            if modRoom[playerName] == false then
                modRoom[playerName] = true
                local message = "You are a mod!"
                --print(message)
                chatMessage(message, playerName)
            else
                modRoom[playerName] = false
                local message = "You are no longer a mod!"
                --print(message)
                chatMessage(message, playerName)
            end
            setColor(playerName)
        end

        if arg[1] == "op" then
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

        if string.find(room.name, "^[a-z][a-z2]%-#ninja%d*$") then
            return chatMessage(translations[playerVars[playerName].playerLanguage].cantSetPass, player)
        end

        if arg[2] ~= nil then
            customRoom = true
            tfm.exec.setRoomPassword(arg[2])
            chatMessage("Password: "..arg[2], playerName)
        else
            customRoom = false
            tfm.exec.setRoomPassword("")
            chatMessage("Password removed.", playerName)
        end
    end

    if arg[1] == "p" or arg[1] == "profile" then
        isValid = true
        if arg[2] == nil then
            openPage(translations[playerVars[playerName].playerLanguage].profileTitle.." - "..playerName, stats(playerName, playerName), playerName, id, "profile")
            return
        end

        for name, value in pairs(room.playerList) do
            if name == arg[2] then
                openPage(translations[playerVars[playerName].playerLanguage].profileTitle.." - "..arg[2], stats(arg[2], playerName), playerName, id, "profile")
                break
            end
        end
    end

    if arg[1] == "langue" and arg[2] ~= nil then
        for i = 1, #languages do
            if arg[2] == languages[i] then
                playerVars[playerName].playerLanguage = arg[2]
                generateHud(playerName)
                return
            end
        end
        chatMessage(arg[2].." doesn't exist yet.", playerName)
    end

    if isValid == false then
        chatMessage(arg[1].." "..translations[playerVars[playerName].playerLanguage].notValidCommand, playerName)
    end
end