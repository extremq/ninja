tfm.exec.disableAutoShaman(true)
tfm.exec.newGame('@4732029')
tfm.exec.disableAutoNewGame(true)
tfm.exec.disableAutoScore(true)
tfm.exec.setGameTime(0)
tfm.exec.disablePhysicalConsumables(true)
tfm.exec.disableMortCommand(true)

ui.setMapName("#trade<")

local trades = {
    [[A1 = {
        cc = {
            ['Extremq#0000'] = 20
        },
        relic = {
            ['Extrem#0000'] = "D3"
        }
    }]]
}

-- Init trades
for _, letter in next, {"A", "B", "C", "D", "E", "F"} do
  for number = 1, 10 do
    trades[letter .. number] = {
      ['b'] = {},
      ['s'] = {}
    }
  end
end

-- Init playerState
local playerState = {
    [[playerName = {
        _currentRelic = nil,
        _popupState = nil,
        _offers = {}
    }]]
}

local reloadTime = 1800
local startTime = os.time()
local currentTime = 0
function eventLoop(ct, rt)
    currentTime = os.time()  
    local minutes = math.floor((reloadTime * 1000 - (currentTime - startTime))/60000)
    local seconds = math.floor((reloadTime * 1000 - (currentTime - startTime))%60000/1000)
    if seconds < 10 then seconds = "0"..tostring(seconds) end
    ui.setMapName("#trade <G>|</G> <N>Reloading in</N> "..minutes..":"..seconds.."<")
    if currentTime - startTime >= reloadTime * 1000 then
        emptyTrades()
        for name, data in pairs(tfm.get.room.playerList) do
            playerState[name] = {
                _currentRelic = nil,
                _popupState = nil,
                _offers = {}
            }
            updateRelic(name, nil)
        end
        startTime = currentTime
    end
end

function eventNewPlayer(playerName)
    tfm.exec.respawnPlayer(playerName)
    if playerName:sub(1,1) == "*" then tfm.exec.killPlayer(playerName) end

    ui.addTextArea(30, "", playerName, 210, 15, 380, 225, 0x1C3A3E, 0x203F43, 0.5, false)
    local buttons = "<p='align'><font face='Lucida Console' size='15'>\n\n   "
    for _, letter in next, {"A", "B", "C", "D", "E", "F"} do
        for j = 1, 10 do 
            buttons = buttons.."<a href='event:"..letter..j.."'>"..letter..j.."</a>  "
        end
        buttons = buttons.."\n\n   "
        if letter == "C" then 
            ui.addTextArea(31, buttons:sub(0, 2000), playerName, 200, 25, 400, 120, 0x1C3A3E, 0xEFCE8F, 0, false) 
            buttons = "<p='align'><font face='Lucida Console' size='15'>   "
        end
    end

    ui.addTextArea(32, buttons:sub(0, 2000), playerName, 200, 145, 400, 120, 0x1C3A3E, 0xEFCE8F, 0, false)
    ui.addTextArea(33, "<p align='center'>Selected: <R>none</R></p>", playerName, 200, 25, 400, 16, 0x1C3A3E, 0x1C3A3E, 0, false)
    
	ui.addTextArea(9, "", playerName, -1, 49, 202, 302, 0xEFCE8F, 0xEFCE8F, 0, false)
    ui.addTextArea(10, "<p align='center'><font size='20' face='Soopafresh,Verdana'>Buying <a href='event:B'><VP>+</VP></a></font></p><textformat tabstops='0, 50'><V>Price\tName</textformat></V>", playerName,   0, 15, 200, 290, 0x1C3A3E, 0x1C3A3E, 0.5, false)
    ui.addTextArea(11, "", playerName,   5, 65, 190, 235, 0x203F43, 0x203F43, 0.7, false)
    
	ui.addTextArea(19, "", playerName, 599, 49, 202, 302, 0xEFCE8F, 0xEFCE8F, 0, false)
    ui.addTextArea(20, "<p align='center'><font size='20' face='Soopafresh,Verdana'>Selling <a href='event:S'><VP>+</VP></a></font></p><textformat tabstops='0, 50'><V>Price\tName</textformat></V>", playerName, 600, 15, 200, 290, 0x1C3A3E, 0x1C3A3E, 0.5, false)
    ui.addTextArea(21, "", playerName, 605, 65, 190, 235, 0x203F43, 0x203F43, 0.7, false)

    playerState[playerName] = {
        _currentRelic = nil,
        _popupState = nil,
        _offers = {}
    }
end

for a, b in pairs(tfm.get.room.playerList) do
    --tfm.exec.killPlayer(a)
    eventNewPlayer(a)
end

function eventPopupAnswer(id, playerName, answer)
    local relicType = playerState[playerName]._currentRelic
    if not relicType then return end

    if id == 50 then
        createTrade(playerName, relicType, answer)
    end
end

function createTrade(playerName, type, value)
    -- We overwrite the current offer the player put anyway
    local state = playerState[playerName]._popupState
    local invState = 'b'
    if state == 'b' then invState = 's' end

    -- Offer has a match already
    for player, offer in pairs(trades[type][invState]) do
        if tostring(offer):upper() == value and player ~= playerName then
            tfm.exec.chatMessage("<J>There already is someone that is offering what you want.\n/trade "..player, playerName)
            tfm.exec.chatMessage("<J>"..playerName.." wants your offer for "..type..".\n/trade "..playerName, player)
        end
    end

    if value:match("^%d+$") and #value < 4 then 
        trades[type][state][playerName] = tonumber(value)
    elseif value:match("^[A-Fa-f][1-9]0?$") then
        trades[type][state][playerName] = value:upper()
    else
        return
    end
    
    playerState[playerName]._offers[type] = true 

    sendUpdate(type, state)
    updateRelic(playerName, type)
    playerState[playerName]._popupState = nil
end

function eraseTrade(playerName, type, where)
    if trades[type][where][playerName] then
        trades[type][where][playerName] = nil
    end

    if where == 's' then
        where = 'b' 
    else 
        where = 's' 
    end

    if not trades[type][where][playerName] then
        playerState[playerName]._offers[type] = nil 
    end

    sendUpdate(type, playerState[playerName]._popupState)
    updateRelic(playerName, type)
    playerState[playerName]._popupState = nil
end

function eventTextAreaCallback(id, playerName, event)
    if playerName:sub(1,1) == "*" then return end
    local relicType = playerState[playerName]._currentRelic

    if (id == 31 or id == 32) and event ~= relicType and event:match("^[A-F][1-9]0?$") then
        playerState[playerName]._currentRelic = event
        updateRelic(playerName, event)
    end
    
    if not relicType then return end

    if (id == 11 or id == 21) and event ~= playerName then
        tfm.exec.chatMessage("<J>/trade "..event, playerName)
        tfm.exec.chatMessage("<J>"..playerName.." clicked on one of your offers.", event)
    elseif id == 10 then
        playerState[playerName]._popupState = "b"
        if trades[relicType]['b'][playerName] then
            eraseTrade(playerName, relicType, 'b')
        else
            ui.addPopup(50, 2, "<p align='center'>Set value (number for cheese or relic name).\nExample: 120 or A6</p>", playerName, 300, 150, 200, 100)
        end
    elseif id == 20 then
        playerState[playerName]._popupState = "s"
        if trades[relicType]['s'][playerName] then
            eraseTrade(playerName, relicType, 's')
        else 
            ui.addPopup(50, 2, "<p align='center'>Set value (number for cheese or relic name).\nExample: 120 or A6</p>", playerName, 300, 150, 200, 100)
        end
    end
end

function updateRelic(playerName, type)
    local buttons = "<p='align'><font face='Lucida Console' size='15'>\n\n   "
    for _, letter in next, {"A", "B", "C", "D", "E", "F"} do
        for j = 1, 10 do 
            local current = letter..j
            local visual = current
            if current == type then visual = "<u>"..visual.."</u>" end
            if playerState[playerName]._offers[current] then visual = "<BV>"..visual.."</BV>" end
            buttons = buttons.."<a href='event:"..current.."'>"..visual.."</a>  "
        end
        buttons = buttons.."\n\n   "
        if letter == "C" then 
            buttons = buttons.."</font></p>"
            ui.updateTextArea(31, buttons:sub(0, 2000), playerName) 
            buttons = "<p='align'><font face='Lucida Console' size='15'>   "
        end
    end

    buttons = buttons.."</font></p>"
    ui.updateTextArea(32, buttons:sub(0, 2000), playerName)
    if not type then type = "<R>none</R>" end
    ui.updateTextArea(33, "<p align='center'>Selected: <VP>"..type.."</VP></p>", playerName)
    
    if type ~= "<R>none</R>" and trades[type]['b'][playerName] then
        ui.updateTextArea(10, "<p align='center'><font size='20' face='Soopafresh,Verdana'>Buying "..type.." <a href='event:B'><R>-</R></a></font></p><textformat tabstops='0, 50'><V>Price\tName</textformat></V>", playerName)
    else 
        ui.updateTextArea(10, "<p align='center'><font size='20' face='Soopafresh,Verdana'>Buying "..type.." <a href='event:B'><VP>+</VP></a></font></p><textformat tabstops='0, 50'><V>Price\tName</textformat></V>", playerName)
    end

    if type ~= "<R>none</R>" and trades[type]['s'][playerName] then
        ui.updateTextArea(20, "<p align='center'><font size='20' face='Soopafresh,Verdana'>Selling "..type.." <a href='event:B'><R>-</R></a></font></p><textformat tabstops='0, 50'><V>Price\tName</textformat></V>", playerName)
    else 
        ui.updateTextArea(20, "<p align='center'><font size='20' face='Soopafresh,Verdana'>Selling "..type.." <a href='event:B'><VP>+</VP></a></font></p><textformat tabstops='0, 50'><V>Price\tName</textformat></V>", playerName)
    end

    if type == "<R>none</R>" then return end
    updateOffers(playerName, type, 's')
    updateOffers(playerName, type, 'b')
end

function sendUpdate(relicType, which)
    local text = "<textformat tabstops='0, 50'>"
    local relicOff = {}
    local ccOff = {}

    for playerName, offer in pairs(trades[relicType][which]) do
        if type(offer) == "string" then
            relicOff[#relicOff + 1] = {offer, playerName}
        else
            ccOff[#ccOff + 1] = {offer, playerName}
        end
    end

    table.sort(relicOff, function(a, b)
        return a[1] < b[1]
    end)

    table.sort(ccOff, function(a, b)
        return a[1] < b[1]
    end)

    if which == "s" then
        table.sort(ccOff, function(a, b)
            return a[1] < b[1]
        end)
    else 
        table.sort(ccOff, function(a, b)
            return a[1] > b[1]
        end)
    end

    for i = 1, #ccOff do
        text = text..ccOff[i][1].."CC\t<a href='event:"..ccOff[i][2].."'>"..ccOff[i][2]..'</a>\n'
    end
    
    for i = 1, #relicOff do
        text = text..relicOff[i][1].."\t<a href='event:"..relicOff[i][2].."'>"..relicOff[i][2]..'</a>\n'
    end


    local id = 11
    if which == "s" then id = 21 end

    text = text:sub(0, 2000)

    print(text)

    for playerName, data in pairs(playerState) do
        if data._currentRelic == relicType then
            ui.updateTextArea(id, text, playerName)
        end
    end
end

function updateOffers(playerName, relicType, which)
    local text = "<textformat tabstops='0, 50'>"
    local relicOff = {}
    local ccOff = {}

    for playerName, offer in pairs(trades[relicType][which]) do
        if type(offer) == "string" then
            relicOff[#relicOff + 1] = {offer, playerName}
        else
            ccOff[#ccOff + 1] = {offer, playerName}
        end
    end

    table.sort(relicOff, function(a, b)
        return a[1] < b[1]
    end)

    if which == "s" then
        table.sort(ccOff, function(a, b)
            return a[1] < b[1]
        end)
    else 
        table.sort(ccOff, function(a, b)
            return a[1] > b[1]
        end)
    end

    for i = 1, #ccOff do
        text = text..ccOff[i][1].."CC\t<a href='event:"..ccOff[i][2].."'>"..ccOff[i][2]..'</a>\n'
    end
    
    for i = 1, #relicOff do
        text = text..relicOff[i][1].."\t<a href='event:"..relicOff[i][2].."'>"..relicOff[i][2]..'</a>\n'
    end

    local id = 11
    if which == "s" then id = 21 end

    text = text:sub(0, 2000)

    ui.updateTextArea(id, text, playerName)
end

system.disableChatCommandDisplay(nil, true)

function eventChatCommand(playerName, cmd)
    local arg = {}
    for argument in cmd:gmatch("[^%s]+") do
        arg[#arg + 1] = argument
    end

    if arg[1]:lower() == "buy" and arg[2]:match("^[A-Fa-f][1-9]0?$") and arg[3] then
        print("a")
        playerState[playerName]._popupState = 'b'
        createTrade(playerName, arg[2], arg[3])
    elseif arg[1]:lower() == "sell" and arg[2]:match("^[A-Fa-f][1-9]0?$") and arg[3] then
        playerState[playerName]._popupState = 's'
        createTrade(playerName, arg[2], arg[3])
    end
        -- elseif arg[1]:lower() == "delete" and arg[2] then
    --     if arg[2]:match("^[A-Fa-f][1-9]0?$") then
    --         if playerState[playerName]._offers[arg[2]] then
    --             eraseTrade(playerName, arg[2], 's')
    --             eraseTrade(playerName, arg[2], 'b')
    --         end
    --     elseif arg[2] == "all" then
    --         for _, relic in pairs(playerState[playerName]._offers) do
    --             eraseTrade(playerName, relic, 's')
    --             eraseTrade(playerName, relic, 'b')
    --         end
    --     end
    -- end
end

function emptyTrades()
    for _, letter in next, {"A", "B", "C", "D", "E", "F"} do
        for number = 1, 10 do
        trades[letter .. number] = {
            ['b'] = {},
            ['s'] = {}
        }
        end
    end
end