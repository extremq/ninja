local roomCreate = os.time()
tfm.exec.setRoomPassword("")

if string.find(tfm.get.room.name, "^[a-z][a-z2]%-#ninja%d+trade%d*$") or string.find(tfm.get.room.name, "^%*?#ninja%d+trade%d*$") then
--[[ File trade.lua ]]--
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
--[[ End of file trade.lua ]]--
else
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
local respawnPlayer = tfm.exec.respawnPlayer
local setPlayerScore = tfm.exec.setPlayerScore
local setMapName = ui.setMapName
local random = math.random
local addTextArea = ui.addTextArea
local updateTextArea = ui.updateTextArea
local removeTextArea = ui.removeTextArea

-- RETURN PLAYER ID
function playerId(playerName)
    return playerIds[playerName]
end

function removeTag(playerName)
    return playerName:gsub("#%d%d%d%d", "")
end

VERSION = "1.5.5, 13.06.2020"

local translations = {}

--[[ File json.lua ]]--
--
-- json.lua
--
-- Copyright (c) 2019 rxi
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do
-- so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--

local json = { _version = "0.1.2" }

-- NOTE: This is a slightly modified version of the script you will find here:
-- https://github.com/rxi/json.lua
-- It has been modified so it uses less runtime, by making the next functions
-- accessible via a single variable and by disabling some encoding/decoding
-- checks. It is not recommended to use this version if you're not 100% sure your
-- data is totally valid.

local string_format = string.format
local string_byte = string.byte
local table_concat = table.concat
local string_gsub = string.gsub
local string_sub = string.sub
local string_find = string.find
local string_char = string.char
local math_floor = math.floor

-------------------------------------------------------------------------------
-- Encode
-------------------------------------------------------------------------------


local encode

local escape_char_map = {
  [ "\\" ] = "\\\\",
  [ "\"" ] = "\\\"",
  [ "\b" ] = "\\b",
  [ "\f" ] = "\\f",
  [ "\n" ] = "\\n",
  [ "\r" ] = "\\r",
  [ "\t" ] = "\\t",
}

local escape_char_map_inv = { [ "\\/" ] = "/" }
for k, v in next, escape_char_map do
  escape_char_map_inv[v] = k
end


local function escape_char(c)
  return escape_char_map[c] or string_format("\\u%04x", string_byte(c))
end


local function encode_nil(val)
  return "null"
end


local function encode_table(val)--, stack)
  local res = {}
  -- stack = stack or {}

  -- Circular reference?
  -- if stack[val] then error("circular reference") end

  -- stack[val] = true

  if rawget(val, 1) ~= nil then-- or next(val) == nil then
    -- Treat as array -- check keys are valid and it is not sparse
    -- local n = 0
    -- for k in next, val do
    --   if type(k) ~= "number" then
    --     error("invalid table: mixed or invalid key types")
    --   end
    --   n = n + 1
    -- end
    -- if n ~= #val then
    --   error("invalid table: sparse array")
    -- end
    -- Encode
    for i = 1, #val do
      res[i] = encode(val[i])--, stack)
    end
    --stack[val] = nil
    return "[" .. table_concat(res, ",") .. "]"

  else
    -- Treat as an object
    local n = 0
    for k, v in next, val do
      -- if type(k) ~= "string" then
      --   error("invalid table: mixed or invalid key types")
      -- end
      n = n + 1
      res[n] = encode(k) .. ":" .. encode(v)--, stack) .. ":" .. encode(v, stack)
    end
    --stack[val] = nil
    return "{" .. table_concat(res, ",") .. "}"
  end
end


local function encode_string(val)
  return '"' .. string_gsub(val, '[%z\1-\31\\"]', escape_char) .. '"'
end


local function encode_number(val)
  -- Check for NaN, -inf and inf
  -- if val ~= val or val <= -math.huge or val >= math.huge then
  --   error("unexpected number value '" .. tostring(val) .. "'")
  -- end
  if val % 1 == 0 then
    return tostring(val)
  else
    return string_format("%.14g", val)
  end
end


local type_func_map = {
  [ "nil"     ] = encode_nil,
  [ "table"   ] = encode_table,
  [ "string"  ] = encode_string,
  [ "number"  ] = encode_number,
  [ "boolean" ] = tostring,
}


encode = function(val)--, stack)
  return type_func_map[type(val)](val)--, stack)
end


json.encode = encode


-------------------------------------------------------------------------------
-- Decode
-------------------------------------------------------------------------------

local parse

local function create_set(...)
  local res = {}
  for i = 1, select("#", ...) do
    res[ select(i, ...) ] = true
  end
  return res
end

local space_chars   = create_set(" ", "\t", "\r", "\n")
local delim_chars   = create_set(" ", "\t", "\r", "\n", "]", "}", ",")
local escape_chars  = create_set("\\", "/", '"', "b", "f", "n", "r", "t", "u")
local literals      = create_set("true", "false", "null")

local literal_map = {
  [ "true"  ] = true,
  [ "false" ] = false,
  [ "null"  ] = nil,
}


local function next_char(str, idx, set, negate)
  for i = idx, #str do
    if set[string_sub(str, i, i)] ~= negate then
      return i
    end
  end
  return #str + 1
end


local function decode_error(str, idx, msg)
  local line_count = 1
  local col_count = 1
  for i = 1, idx - 1 do
    col_count = col_count + 1
    if string_sub(str, i, i) == "\n" then
      line_count = line_count + 1
      col_count = 1
    end
  end
  error( string_format("%s at line %d col %d", msg, line_count, col_count) )
end


local function codepoint_to_utf8(n)
  -- http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=iws-appendixa
  if n <= 0x7f then
    return string_char(n)
  elseif n <= 0x7ff then
    return string_char(math_floor(n / 64) + 192, n % 64 + 128)
  elseif n <= 0xffff then
    return string_char(math_floor(n / 4096) + 224, math_floor(n % 4096 / 64) + 128, n % 64 + 128)
  elseif n <= 0x10ffff then
    return string_char(math_floor(n / 262144) + 240, math_floor(n % 262144 / 4096) + 128,
                       math_floor(n % 4096 / 64) + 128, n % 64 + 128)
  end
  error( string_format("invalid unicode codepoint '%x'", n) )
end


local function parse_unicode_escape(s)
  local n1 = tonumber( string_sub(s, 3, 6),  16 )
  local n2 = tonumber( string_sub(s, 9, 12), 16 )
  -- Surrogate pair?
  if n2 then
    return codepoint_to_utf8((n1 - 0xd800) * 0x400 + (n2 - 0xdc00) + 0x10000)
  else
    return codepoint_to_utf8(n1)
  end
end


local function parse_string(str, i)
  local has_unicode_escape = false
  local has_surrogate_escape = false
  local has_escape = false
  local last
  for j = i + 1, #str do
    local x = string_byte(str, j)

    if x < 32 then
      decode_error(str, j, "control character in string")
    end

    if last == 92 then -- "\\" (escape char)
      if x == 117 then -- "u" (unicode escape sequence)
        local hex = string_sub(str, j + 1, j + 5)
        if not string_find(hex, "%x%x%x%x") then
          decode_error(str, j, "invalid unicode escape in string")
        end
        if string_find(hex, "^[dD][89aAbB]") then
          has_surrogate_escape = true
        else
          has_unicode_escape = true
        end
      else
        local c = string_char(x)
        if not escape_chars[c] then
          decode_error(str, j, "invalid escape char '" .. c .. "' in string")
        end
        has_escape = true
      end
      last = nil

    elseif x == 34 then -- '"' (end of string)
      local s = string_sub(str, i + 1, j - 1)
      if has_surrogate_escape then
        s = string_gsub(s, "\\u[dD][89aAbB]..\\u....", parse_unicode_escape)
      end
      if has_unicode_escape then
        s = string_gsub(s, "\\u....", parse_unicode_escape)
      end
      if has_escape then
        s = string_gsub(s, "\\.", escape_char_map_inv)
      end
      return s, j + 1

    else
      last = x
    end
  end
  decode_error(str, i, "expected closing quote for string")
end


local function parse_number(str, i)
  local x = next_char(str, i, delim_chars)
  local s = string_sub(str, i, x - 1)
  local n = tonumber(s)
  if not n then
    decode_error(str, i, "invalid number '" .. s .. "'")
  end
  return n, x
end


local function parse_literal(str, i)
  local x = next_char(str, i, delim_chars)
  local word = string_sub(str, i, x - 1)
  if not literals[word] then
    decode_error(str, i, "invalid literal '" .. word .. "'")
  end
  return literal_map[word], x
end


local function parse_array(str, i)
  local res = {}
  local n = 1
  i = i + 1
  while 1 do
    local x
    i = next_char(str, i, space_chars, true)
    -- Empty / end of array?
    if string_sub(str, i, i) == "]" then
      i = i + 1
      break
    end
    -- Read token
    x, i = parse(str, i)
    res[n] = x
    n = n + 1
    -- Next token
    i = next_char(str, i, space_chars, true)
    local chr = string_sub(str, i, i)
    i = i + 1
    if chr == "]" then break end
    if chr ~= "," then decode_error(str, i, "expected ']' or ','") end
  end
  return res, i
end


local function parse_object(str, i)
  local res = {}
  i = i + 1
  while 1 do
    local key, val
    i = next_char(str, i, space_chars, true)
    -- Empty / end of object?
    if string_sub(str, i, i) == "}" then
      i = i + 1
      break
    end
    -- Read key
    if string_sub(str, i, i) ~= '"' then
      decode_error(str, i, "expected string for key")
    end
    key, i = parse(str, i)
    -- Read ':' delimiter
    i = next_char(str, i, space_chars, true)
    if string_sub(str, i, i) ~= ":" then
      decode_error(str, i, "expected ':' after key")
    end
    i = next_char(str, i + 1, space_chars, true)
    -- Read value
    val, i = parse(str, i)
    -- Set
    res[key] = val
    -- Next token
    i = next_char(str, i, space_chars, true)
    local chr = string_sub(str, i, i)
    i = i + 1
    if chr == "}" then break end
    if chr ~= "," then decode_error(str, i, "expected '}' or ','") end
  end
  return res, i
end


local char_func_map = {
  [ '"' ] = parse_string,
  [ "0" ] = parse_number,
  [ "1" ] = parse_number,
  [ "2" ] = parse_number,
  [ "3" ] = parse_number,
  [ "4" ] = parse_number,
  [ "5" ] = parse_number,
  [ "6" ] = parse_number,
  [ "7" ] = parse_number,
  [ "8" ] = parse_number,
  [ "9" ] = parse_number,
  [ "-" ] = parse_number,
  [ "t" ] = parse_literal,
  [ "f" ] = parse_literal,
  [ "n" ] = parse_literal,
  [ "[" ] = parse_array,
  [ "{" ] = parse_object,
}


parse = function(str, idx)
  local chr = string_sub(str, idx, idx)
  local f = char_func_map[chr]
  if f then
    return f(str, idx)
  end
  decode_error(str, idx, "unexpected character '" .. chr .. "'")
end


function json.decode(str)
  if type(str) ~= "string" then
    error("expected argument of type string, got " .. type(str))
  end
  local res, idx = parse(str, next_char(str, 1, space_chars, true))
  idx = next_char(str, idx, space_chars, true)
  if idx <= #str then
    decode_error(str, idx, "trailing garbage")
  end
  return res
end
--[[ End of file json.lua ]]--

--[[ File string.utf8.lua ]]--
--[[
    name: string.utf8.lua
    description: Utf8 string handler - credits to Bolodefchoco#0000
]]--

do
	-- Based on Luvit's ustring
	local charLength = function(byte)
		if bit32.rshift(byte, 7) == 0x00 then
			return 1
		elseif bit32.rshift(byte, 5) == 0x06 then
			return 2
		elseif bit32.rshift(byte, 4) == 0x0E then
			return 3
		elseif bit32.rshift(byte, 3) == 0x1E then
			return 4
		end
		return 0
	end

	local sub, byte = string.sub, string.byte
	string.utf8 = function(str)
		local utf8str = { }
		local index, append = 1, 0

		local charLen

		for i = 1, #str do
			repeat
				local char = sub(str, i, i)
				local byte = byte(char)
				if append ~= 0 then
					utf8str[index] = utf8str[index] .. char
					append = append - 1

					if append == 0 then
						index = index + 1
					end
					break
				end

				charLen = charLength(byte)
				utf8str[index] = char
				if charLen == 1 then
					index = index + 1
				end
				append = append + charLen - 1
			until true
		end

		return utf8str
	end
end
--[[ End of file string.utf8.lua ]]--

--[[ Directory translations ]]--
--[[ File translations/en.lua ]]--
translations.en = {
    name = "en",
    lastTime = "Your last time: %ss",
    lastBestTime = "Your best time: %ss",
    helpToolTip = "<p align='center'>Press <b>H</b> for help.</p>",
    optionsYes = "<font color='#53ba58'>Yes</font>",
    optionsNo = "<font color='#f73625'>No</font>",
    graffitiSetting = "Enable graffitis",
    particlesSetting = "Enable dash/jump particles",
    timePanelsSetting = "Enable time panels",
    globalChatSetting = "Enable global chat",
    voteStart = "%s started a vote to skip the current map. Type !yes to vote positively.",
    newRecord = "<R>%s finished the map in the fastest time! %ss</R>",
    devInfo = "<V>Want to submit a map? Check this link: https://atelier801.com/topic?f=6&t=888399</V>\n<font color='#CB546B'>This module is in development. Please report any bugs to Extremq#0000 or Railysse#0000.</font>",
    discordInfo = "<BV>Join our discord! https://discord.gg/WawZVaq</BV>",
    welcomeInfo = "Welcome to <font color='#E68D43'>#ninja</font>! Press <font color='#E68D43'>H</font> for help.",
    finishedInfo = "You finished the map! (<V>%ss</V>)",
    helpBody = "You have to bring the cheese back to the hole as fast as you can.\n\n<b>Abilities</b>:\n» Dash - Press <b><font color='#CB546B'>Left</font></b> or <b><font color='#CB546B'>Right Arrows</font></b> twice. (1s cooldown)\n» Jump - Press <b><font color='#CB546B'>Up Arrow</font></b> twice. (2s cooldown)\n» Rewind - Press <b><font color='#CB546B'>Space</font></b> to leave a checkpoint. Press <b><font color='#CB546B'>Space</font></b> again within 3 seconds to teleport back to the checkpoint. (10s cooldown)\n\n<b>Other shortcuts</b>:\n» Kill the mouse - Press <b><font color='#CB546B'>X</font></b> or write /mort to kill the mouse.\n» Open menu - Press <b><font color='#CB546B'>M</font></b> or click in the left side of your screen to open/close the menu.\n» Place a graffiti - Press <b><font color='#CB546B'>C</font></b> to leave a graffiti. (60s cooldown)\n» Open help - Press <b><font color='#CB546B'>H</font></b> to open/close this screen.\n\n<b>Commands</b>:\n» !p %s - Check the stats of another player.\n» !pw Password - Place a password on the room. (the room must be made by you)\n» !m @code - Load any map you want. (the room must have a password)\n» !langue country - Change the language of the module. (only for you)\n\n<p align='center'><a href='event:CloseMenu'><b><font color='#CB546B'>Close</font></b></a></p>", --23
    Xbtn = "X",
    shopTitle = "Collection",
    profileTitle = "Profile",
    leaderboardsTitle = "Leaderboards",
    settingsTitle = "Settings",
    aboutTitle = "About",
    aboutBody = "Module coded by <font color='#FFD991'>Extremq#0000</font>.\nGameplay ideas, bug-testing and maps provided by <font color='#FFD991'>Railysse#0000</font>.\n\nThis module is fully supported by the mice fundation „Red Cheese” with the „Save Module” project. All funds that we will earn will be donated to mice which play #parkour so we can bribe them to play our module.\n\nWe're just kidding, thank you for trying our module! :D\n\n<p align='center'><font color='#f73625'>&lt;3</font></p>", -- 30
    playtime = "Playtime",
    firsts = "Firsts",
    finishedMaps = "Completed maps",
    firstRate = "First rate",
    holeEnters = "Times entered the hole",
    graffitiUses = "Graffiti uses",
    dashUses = "Times dashed",
    timesDoubleJumped = "Double jumps",
    rewindUses = "Times rewinded",
    hardcoreMaps = "Hardcore maps done",
    shopNotice = "The shop is in development.",
    leaderboardsNotice = "A leaderboard will be implemented when the module becomes official.",
    notValidCommand = "%s is not a valid command or you mistyped an argument.",
    cantSetPass = "Cannot set a password in this room.",
    translator = "Translated by Extremq#0000.",
    version = "Version: %s",
    yourLoadout = "Your loadout:",
    yourGraffiti = "Your graffiti:",
    change = "Change",
    select = "Select",
    selected = "Selected",
    locked = "Locked",
    back = "Back",
    comingSoon = "Coming soon!",
    requirements = "Requirements",
    particleUnlock = "<ROSE>You unlocked a new particle! Press M and navigate to Collection to try it.</ROSE>",
    graffitiColorUnlock = "<ROSE>You unlocked a new graffiti color! Press M and navigate to Collection to try it.</ROSE>",
    graffitiFontUnlock = "<ROSE>You unlocked a new grafitti font! Press M and navigate to Collection to try it.</ROSE>",
    free = "Free.",
    finishMaps = "Finish %s map(s).",
    finishMapsFirst = "Finish %s map(s) first.",
    dashTimes = "Dash %s times.",
    doubleJumps = "Double jump %s times.",
    finishHardcoreMaps = "Finish %s hardcore map(s).",
    sprayGraffiti = "Spray a graffiti %s times.",
    rewindTimes = "Rewind %s times.",
    dontRewind = "<CS>You rewinded, your stats haven't been saved!</CS>",
    enoughPlayers = "<V>[•]<BL> There are %s players in this room and all stats are counted!",
    notEnoughPlayers = "<V>[•]<BL> More players are needed for some stats to count. [%s/3]",
    statsCount = "<V>[•]<BL> All stats are now counted!",
    statsDontCount = "<V>[•]<BL> Some stats are not counted!",

    --- PARTICLE START
    particleDef = "This is the default particle.",
    particleHearts = "Add some hearts to your dash!",
    particleSleek = "Sleek. Just like you.",
    particleLikeNinja = "Wow, you really like playing #ninja.",
    particleYouPro = "Cool. You're a pro now.",
    particleToSky = "To the sky!",

    --- GRAFFITI COLOR START
    graffitiColDef = "This is the default graffiti color.",
    graffitiColBlack = "You're a dark person.",
    graffitiColDarkRed = "Where's this... blood from?",

    --- GRAFFITI FONT START
    graffitiFontDef = "This is the default font for graffitis.",
    graffitiFontPapyrus = "You seem old.",
    graffitiFontVerdana = "A classic.",
    graffitiFontCenturyGothic = "Wow, you're so modern.",

    infobarLevel = "Level:",
    infobarMice = "Mice:",
    infobarHardcore = "<R>HARDCORE</R>",
    infobarTimeOver = "STATISTICS TIME!",
    infobarRecord = "Record:",
    infobarLoading = "Loading...",

    levelUp = "<v>%s</v> <Bl>is now level <J>%s</J>!",

    --- SENSEI

    senseiGreeting1 = "Welcome to #ninja! You’ll have a great time here if you keep practicing!",

    senseiHelp1 = "You need to double press in a direction to dash, %s!",

    senseiRecord1 = "I knew you could do it!",
    senseiRecord2 = "I trained you well, %s!",
    senseiRecord3 = "You’re faster than the wind, %s!",
    senseiRecord4 = "Impressive!",
    senseiRecord5 = "Such a clear expression of skill!",
    senseiRecord6 = "Some day you might even have a chance against me.",
    senseiRecord7 = "Consider me impressed, %s.",
    senseiRecord8 = "One day you could take my place if you keep practicing!",

    senseiTip1 = "As your Sensei, it’s my duty to help. In order to become a true ninja, you must learn to use your abilities. Double press in a direction to dash.",
	senseiTip2 = "%s, double press in a direction to dash.",
	senseiTip3 = "Take your time, no need to rush, but I’d double press in a direction to dash if a were you, %s.",

    senseiReply1 = "GG",	
    senseiReply2 = "Gj!",
	senseiReply3 = "Well played!",	
	senseiReply4 = "Wow!",
	senseiReply5 = "gg wp, bro",
	senseiReply6 = "Wp!",
	senseiReply7 = "Ez?",
    senseiReply8 = "gg",
    
    senseiLeaderboard1 = "You’ll become a good ninja one day, %s.",
	senseiLeaderboard2 = "Your unmatched speed is a clear proof of your skill, %s.",
	senseiLeaderboard3 = "He is %s. We can all agree %s is a very fast mouse. Be like %s.",
	senseiLeaderboard4 = "1v1, bro? %s",
	senseiLeaderboard5 = "You can all learn something from %s today. Well done, my student!"	


}
--[[ End of file translations/en.lua ]]--
--[[ File translations/es.lua ]]--
translations.es = {
    name = "es",
    lastTime = "Tu último tiempo: %ss",
    lastBestTime = "Tu record: %ss",
    helpToolTip = "<p align='center'>Presiona <b>H</b> para obtener ayuda.</p>",
    optionsYes = "<font color='#53ba58'>Sí</font>",
    optionsNo = "<font color='#f73625'>No</font>",
    graffitiSetting = "Activar graffitis",
    particlesSetting = "Activar partículas de impulso/salto",
    timePanelsSetting = "Activar paneles de tiempos",
    globalChatSetting = "Activar chat global",
    voteStart = "%s empezó a votar para saltar el mapa. Escribe !yes para votar.",
    newRecord = "<R>%s finalizó el mapa con el tiempo más rápido! %ss</R>",
    devInfo = "<V>¿Quieres enviar un mapa? Usa este enlace: https://atelier801.com/topic?f=6&t=888399</V>\n<font color='#CB546B'>El módulo está en desarrollo. Por favor reporta cualquier bug a Extremq#0000 o Railysse#0000.</font>",
    discordInfo = "<BV>¡Únete a nuestro discord! https://discord.gg/WawZVaq</BV>",
    welcomeInfo = "¡Bienvenido a <font color='#E68D43'>#ninja</font>! Presiona <font color='#E68D43'>H</font> para obtener ayuda.",
    finishedInfo = "¡Finalizaste el mapa! <V>(%ss)</V>",
    helpBody = "Tienes que traer el queso de vuelta al agujero tan rápido como puedas.\n\n<b>Habilidades</b>:\n» Impulso - Presiona <b><font color='#CB546B'>Izquierda</font></b> o <b><font color='#CB546B'>Derecha</font></b> dos veces. (espera de 1s)\n» Salto - Presiona <b><font color='#CB546B'>Arriba</font></b> dos veces. (espera de 2s)\n» Rebobinar - Presiona <b><font color='#CB546B'>Espacio</font></b> para dejar un checkpoint. Presiona <b><font color='#CB546B'>Espacio</font></b> de nuevo dentro de 3 segundos para teletransportarte al checkpoint. (espera de 10s)\n\n<b>Otros atajos</b>:\n» Matar tu ratón - Presiona <b><font color='#CB546B'>X</font></b> o escribe /mort para matar a tu ratón.\n» Abrir menú - Presionar <b><font color='#CB546B'>M</font></b> o clickea en el lado izquierdo de tu pantalla para abrir/cerrar el menú.\n» Colocar un graffiti - Presiona <b><font color='#CB546B'>C</font></b> para dejar un graffiti. (espera de 60s)\n» Abrir ayuda - Presiona <b><font color='#CB546B'>H</font></b> para abrir/cerrar esta ventana.\n\n<b>Comandos</b>:\n» !p Nombre#id - Ver las estadísticas de otro jugador.\n» !pw Contraseña - Cambiar la contraseña de la sala. (debe ser creada por tí)\n» !m @code - Cargar cualquier mapa que quieras. (la sala debe tener una contraseña)\n» !langue país - Cambiar el lenguaje del módulo. (sólo para tí)\n\n<p align='center'><a href='event:CloseMenu'><b><font color='#CB546B'>Cerrar</font></b></a></p>", --23
    Xbtn = "X",
    -- IF YOUR LANGUAGE HAS SEPCIAL CHARACTERS, PLEASE JUST LEAVE THESE AS DEFAULT
    shopTitle = "Colección",
    profileTitle = "Perfil",
    leaderboardsTitle = "Rankings",
    settingsTitle = "Ajustes",
    aboutTitle = "Acerca de",
    -- END
    aboutBody = "Módulo programado por <font color='#FFD991'>Extremq#0000</font>.\nIdeas de juego, testeo de errores y mapas por <font color='#FFD991'>Railysse#0000</font>.\n\nEste módulo está totalmente respaldado por la fundación de ratones „Red Cheese” con el proyecto „Save Module”. Todas las donaciones que ganemos serán donadas a los ratones que juegan #parkour para sobornarlos y que vengan a jugar nuestro módulo.\n\nSólo estamos bromeando, ¡gracias por jugar nuestro módulo! :D\n\n<p align='center'><font color='#f73625'>&lt;3</font></p>", -- 30
    playtime = "Tiempo de juego",
    firsts = "Firsts",
    finishedMaps = "Mapas completados",
    firstRate = "Porcentaje de firsts",
    holeEnters = "Veces que entró al agujero",
    graffitiUses = "Usos del graffiti",
    dashUses = "Veces que usó un impulso",
    rewindUses = "Veces que rebobinó",
    hardcoreMaps = "Mapas difíciles completados",
    shopNotice = "La tienda está en desarrollo.",
    leaderboardsNotice = "Una tabla de clasificación será implementada cuando el módulo se vuelva oficial.",
    notValidCommand = "%s no es un comando válido o escribiste mal un argumento.",
    cantSetPass = "No se puede cambiar la contraseña de esta sala.",
    translator = "Traducido por Tocutoeltuco#0000.",
    version = "Versión: %s",
    yourLoadout = "Tus objetos:",
    yourGraffiti = "Tu graffiti:",
    change = "Cambiar",
    select = "Seleccionar",
    selected = "Select",
    locked = "Bloqueado",
    back = "Atrás",
    comingSoon = "¡Muy pronto!",
    requirements = "Requisitos",
    particleUnlock = "<ROSE>¡Desbloqueaste una nueva partícula! Presiona M y navega a Colección para probarla.</ROSE>",
    graffitiColorUnlock = "<ROSE>¡Desbloqueaste un nuevo color de graffiti! Presiona M y navega a Colección para probarlo.</ROSE>",
    graffitiFontUnlock = "<ROSE>¡Desbloqueaste una nueva letra de graffiti! Presiona M y navega a Colección para probarla.</ROSE>",
    free = "Gratis.",
    finishMaps = "Completa %s mapa(s).",
    finishMapsFirst = "Completa %s mapa(s) siendo primero.",
    dashTimes = "Impulsate %s veces.",
    finishHardcoreMap = "Completa %s mapa(s) difíciles.",
    sprayGraffiti = "Usa un graffiti %s veces.",
    rewindTimes = "Usa un checkpoint %s veces.",

    --- PARTICLE START
    particleDef = "Esta es la partícula por defecto.",
    particleHearts = "¡Añade algunos corazones a tu impulso!",
    particleSleek = "Cool. Como tú.",

    --- GRAFFITI COLOR START
    graffitiColDef = "Este es el color de graffiti por defecto.",
    graffitiColBlack = "Eres una persona oscura.",
    graffitiColDarkRed = "¿De dónde... salió la sangre?",

    --- GRAFFITI FONT START
    graffitiFontDef = "Este es la letra de graffiti por defecto.",
    graffitiFontPapyrus = "Pareces viejo.",
    graffitiFontVerdana = "Un clásico.",
    graffitiFontCenturyGothic = "Wow, bastante moderno.",

    
    infobarLevel = "Nivel:",
    infobarMice = "Ratones:",
    infobarHardcore = "<R>DIFICIL</R>",
    infobarTimeOver = "¡ESTADISTICAS!",
    infobarRecord = "Record:",
    infobarLoading = "Cargando..."
}
--[[ End of file translations/es.lua ]]--
--[[ File translations/fr.lua ]]--
translations.fr = {
    name = "fr",
    lastTime = "La dernière fois: %ss",
    lastBestTime = "Votre meilleur temps: %ss",
    helpToolTip = "<p align='center'>Appuyez sur <b>H</b> pour de l'aide.</p>",
    optionsYes = "<font color='#53ba58'>Oui</font>",
    optionsNo = "<font color='#f73625'>Non</font>",
    graffitiSetting = "Activer les graffitis",
    particlesSetting = "Activer les particules de boost et de saut",
    timePanelsSetting = "Activer les panneaux de temps",
    globalChatSetting = "Activer la discussion global",
    voteStart = "%s a comencé un vote pour passer la carte actuelle. Ecrivez !yes pour voter positivement.",
    newRecord = "<R>%s a fini la carte avec le meilleur temps! %ss</R>",
    devInfo = "<V>Vous voulez proposer une carte? Allez sur ce lien : https://atelier801.com/topic?f=6&t=888399</V>\n<font color='#CB546B'>Ce module est toujours en développement. Merci de signaler tous les bugs à Extremq#0000 ou Railysse#0000.</font>",
    discordInfo = "<BV>Rejoignez le discord! https://discord.gg/WawZVaq</BV>",
    welcomeInfo = "Bienvenue dans <font color='#E68D43'>#ninja</font>! Appuyez sur <font color='#E68D43'>H</font> pour de l'aide.",
    finishedInfo = "Vous avez fini la carte! Temps: <V>(%ss)</V>",
    helpBody = "Vous devez ramener le fromage dans le trou le plus rapidement possible.\n\n<b>Capacités </b>:\n» Boost - Appuyez deux fois sur <b><font color='#CB546B'>la flèche gauche</font></b> ou <b><font color='#CB546B'>la flèche droite</font></b>. (1s de rechargement)\n» Saut - Appuyez deux fois sur <b><font color='#CB546B'>la flèche du haut</font></b>. (2s de rechargement)\n» Retour - Appuyez sur <b><font color='#CB546B'>espace</font></b> pour laisser un point de sauvegarde. Appuyez sur <b><font color='#CB546B'></font></b> encore une fois dans les 3 secondes qui suivent pour vous téléporter sur ce point de sauvegarde. (10s de recharge)\n\n<b>Autres raccourcis</b>:\n» Se tuer - Appuyez sur <b><font color='#CB546B'>X</font></b> ou écrivez /mort pour tuer la souris.\n» Ouvrir le menu - Apuyez sur <b><font color='#CB546B'>M</font></b> ou cliquez sur la partie gauche de votre écran pour ouvrir/fermer le menu.\n» Placer un graffiti - Appuyez sur <b><font color='#CB546B'>C</font></b> pour afficher un graffiti. (60s de rechargement)\n» Ouvrir l'aide - Appuyez sur <b><font color='#CB546B'>H</font></b> pour ouvrir/fermer cette affichage.\n\n<b>Commands</b>:\n» !p Name#id - Affiche les statistiques d'un autre joueur.\n» !pw mot de passe - Ajoute un mot de passe au salon. (le salon doit être créé par vous)\n» !m @code - Charge n'importe quel carte que vous voulez. (le salon doit avoir un mot de passe)\n» !langue pays - Change la langue du module. (seulement pour toi)\n\n<p align='center'><a href='event:CloseMenu'><b><font color='#CB546B'>Fermer</font></b></a></p>", --23
    Xbtn = "X",
    -- IF YOUR LANGUAGE HAS SEPCIAL CHARACTERS, PLEASE JUST LEAVE THESE AS DEFAULT
    shopTitle = "Collection",
    profileTitle = "Profile",
    leaderboardsTitle = "Classement",
    settingsTitle = "Paramètres",
    aboutTitle = "A propos",
    -- END
    aboutBody = "Module codé par <font color='#FFD991'>Extremq#0000</font>.\nIdée de jeu, test des bugs and cartes fournies par <font color='#FFD991'>Railysse#0000</font>.\n\nCe module est complétement soutenu par la fondation „Red Cheese” avec le projet „Save Module”. Tous les revenus que nous recevrons seront directement versées aux joueur qui jouent à #parkour comme ça on les supplie de jouer à notre module.\n\nC'est une blague! Merci d'avoir joué à notre module! :D\n\n<p align='center'><font color='#f73625'>&lt;3</font></p>", -- 30
    playtime = "Playtime",
    firsts = "Premiers",
    finishedMaps = "Cartes complétées",
    firstRate = "Taux de premiers",
    holeEnters = "Entrées de troues",
    graffitiUses = "Graffitis utilisés",
    dashUses = "Nombre de Boosts utilisés",
    rewindUses = "Nombre de Retour utilisés",
    hardcoreMaps = "Hardcore cartes",
    shopNotice = "La boutique est en developpement.",
    leaderboardsNotice = "Un classement sera implenté quand le module deviendra officiel.",
    notValidCommand = "%s n'est pas une commande valide ou vous avez mal écris l'argument.",
    cantSetPass = "Impossible d'instaurer un mot de passe dans ce salon.",
    translator = "Traduit par Jaker#9310.",
    version = "Version: %s",
    yourLoadout = "Votre chargement:",
    yourGraffiti = "Votre graffiti:",
    change = "Changer",
    select = "Choisir",
    selected = "Choisi",
    locked = "Verouillé",
    back = "Retour",
    comingSoon = "Prochainement !",
    particleUnlock = "<ROSE>Vous avez débloqué de nouvelles particules ! Appuyez sur M et allez dans Collection pour l'essayer.</ROSE>",
    graffitiColorUnlock = "<ROSE>Vous avez débloqué une nouvelle couleur de graffiti ! Appuyez sur M et allez dans Collection pour l'essayer.</ROSE>",
    graffitiFontUnlock = "<ROSE>Vous avez débloqué une nouvelle police de graffiti !Appuyez sur M et allez dans Collection pour l'essayer.</ROSE>",
    free = "Gratuit.",
    finishMaps = "Terminez %s carte(s).",
    finishMapsFirst = "Terminez %s cartes(s) en premier.",
    dashTimes = "Faite des boosts %s fois.",
    finishHardcoreMap = "Finissez % carte(s) compliquées.",
    sprayGraffiti = "Dessinez un graffiti % fois.",
    rewindTimes = "Utilisez Retour % fois.",

    --- PARTICLE START
    particleDef = "Ce sont les particules par défaut.",
    particleHearts = "Ajoutez quelques coeurs à vos boosts !",
    particleSleek = "Thug. Comme toi.",

    --- GRAFFITI COLOR START
    graffitiColDef = "Couleur apr défaut des graffitis.",
    graffitiColBlack = "Vous êtes une personne sombre.",
    graffitiColDarkRed = "D'où vient... ce sang ?",

    --- GRAFFITI FONT START
    graffitiFontDef = "C'est la police par défaut des graffitis.",
    graffitiFontPapyrus = "T'es vieux.",
    graffitiFontVerdana = "Un classique.",
    graffitiFontCenturyGothic = "Wow, tu es tellement moderne."
}
--[[ End of file translations/fr.lua ]]--
--[[ File translations/lv.lua ]]--
translations.lv = {
    name = "lv",
    lastTime = "Tavs pēdējais laiks: %ss",
    lastBestTime = "Tavs labākais laiks: %ss",
    helpToolTip = "<p align='center'>Spied <b>H</b>, lai atvērtu palīdzību.</p>",
    optionsYes = "<font color='#53ba58'>Jā</font>",
    optionsNo = "<font color='#f73625'>Nē</font>",
    graffitiSetting = "Iespējot grafiti",
    particlesSetting = "Iespējot paātrināšanas/lēkšanas efektus",
    timePanelsSetting = "Iespējot laika paneļus",
    globalChatSetting = "Iespējot globālo čatu",
    voteStart = "%s sāka balsojumu esošās mapes izlaišanai. Raksti !yes, lai balsotu par.",
    newRecord = "<R>%s pabeidza mapi visīsākajā laikā! %ss</R>",
    devInfo = "<V>Vēlies iesniegt mapi? Skaties šeit: https://atelier801.com/topic?f=6&t=888399</V>\n<font color='#CB546B'>Šis modulis ir izveides procesā. Lūdzu, ziņo par jebkādām kļūdām Extremq#0000 vai Railysse#0000.</font>",
    discordInfo = "<BV>Pievienojies mūsu Discord! https://discord.gg/WawZVaq</BV>",
    welcomeInfo = "Esi sveicināts <font color='#E68D43'>#ninja</font>! Spied <font color='#E68D43'>H</font>, lai atvērtu palīdzību.",
    finishedInfo = "Tu pabeidzi mapi! Laiks: <V>(%ss)</V>",
    helpBody = "Tev ir jānogādā siers atpakaļ uz alu, cik vien ātri spēj.\n\n<b>Spējas</b>:\n» Paātrināšana - Nospied <b><font color='#CB546B'>kreiso</font></b> vai <b><font color='#CB546B'>labo bultiņu</font></b> divreiz. (1s noildze)\n» Lēkšana - Nospied <b><font color='#CB546B'>augšējo bultiņu</font></b> divreiz. (2s noildze)\n» Attīt - Nospied <b><font color='#CB546B'>atstarpi</font></b>, lai izveidotu atskaites punktu. Nospied <b><font color='#CB546B'>atstarpi</font></b> vēlreiz 3 sekunžu laikā, lai teleportētos atpakaļ uz to. (10s noildze)\n\n<b>Citi īsceļi</b>:\n» Peles nogalināšana - Nospied <b><font color='#CB546B'>X</font></b> vai ieraksti /mort, lai nogalinātu peli.\n» Atvērt izvēlni - Nospied <b><font color='#CB546B'>M</font></b> vai klikšķini ekrāna kreisajā pusē, lai  atvērtu/aizvērtu izvēlni.\n» Atstāt grafiti - Nospied <b><font color='#CB546B'>C</font></b>, lai atstātu grafiti. (60s noildze)\n» Atvērt palīdzību - Nospied <b><font color='#CB546B'>H</font></b>, lai atvērtu/aizvērtu šo logu.\n\n<b>Komandas</b>:\n» !p Vārds#id - Pārbauda cita spēlētāja statistiku.\n» !pw Parole - Iestata paroli istabai. (istabai ir jābūt tevis veidotai)\n» !m @kods - Ielādē jebkuru mapi, kuru vēlies. (istabai ir jābūt parolei)\n» !langue valsts - Maina moduļa valodu. (tikai tev)\n\n<p align='center'><a href='event:CloseMenu'><b><font color='#CB546B'>Aizvērt</font></b></a></p>", --23
    Xbtn = "X",
    -- IF YOUR LANGUAGE HAS SEPCIAL CHARACTERS, PLEASE JUST LEAVE THESE AS DEFAULT
    shopTitle = "Kolekcija",
    profileTitle = "Profils",
    leaderboardsTitle = "Rezultātu tablo",
    settingsTitle = "Iestatījumi",
    aboutTitle = "Par",
    -- END
    aboutBody = "Moduli kodēja <font color='#FFD991'>Extremq#0000</font>.\nIdejas spēlei, kļūdu testēšanu un mapes nodrošināja <font color='#FFD991'>Railysse#0000</font>.\n\nŠo moduli pilnībā atbalsta peļu organizācija „Red Cheese” ar „Save Module” projektu. Visas iegūtās finanses tiks ziedotas pelēm, kuras spēlē #parkour, lai varam piekukuļot viņas spēlēt mūsu moduli.\n\nMēs tikai jokojam, paldies, ka izmēģinājāt mūsu moduli! :D\n\n<p align='center'><font color='#f73625'>&lt;3</font></p>", -- 30
    playtime = "Nospēlētais laiks",
    firsts = "Pirmās vietas",
    finishedMaps = "Pabeigtās mapes",
    firstRate = "Pirmo vietu attiecība",
    holeEnters = "Reizes, cik ieiets alā",
    graffitiUses = "Reizes, cik lietots grafiti",
    dashUses = "Paātrināšanas reizes",
    rewindUses = "Attīšanas reizes",
    hardcoreMaps = "Pabeigtās „Hardcore” mapes",
    shopNotice = "Veikals ir izveides procesā.",
    leaderboardsNotice = "Rezultātu tablo tiks ieviests, kad modulis kļūs oficiāls.",
    notValidCommand = "%s nav derīga komanda vai tu nepareizi ievadīji kādu argumentu.",
    cantSetPass = "Nevar iestatīt paroli šajā istabā.",
    translator = "Tulkoja Syrius#8114.",
    version = "Versija: %s",
    yourLoadout = "Tavi piederumi:",
    yourGraffiti = "Tavi grafiti:",
    change = "Mainīt",
    select = "Izvēlēties",
    selected = "Izvēlēts",
    locked = "Slēgts",
    back = "Atpakaļ",
    comingSoon = "Drīzumā!",
    requirements = "Priekšnoteikumi",
    particleUnlock = "<ROSE>Tu atbloķēji jaunu efektu! Spied M un dodies uz kolekciju, lai to izmēģinātu.</ROSE>",
    graffitiColorUnlock = "<ROSE>Tu atbloķēji jaunu grafiti krāsu! Spied M un dodies uz kolekciju, lai to izmēģinātu.</ROSE>",
    graffitiFontUnlock = "<ROSE>Tu atbloķēji jaunu grafiti fontu! Spied M un dodies uz kolekciju, lai to izmēģinātu.</ROSE>",
    free = "Bezmaksas.",
    finishMaps = "Pabeidz %s mapes.",
    finishMapsFirst = "Pabeidz %s mapes pirmais.",
    dashTimes = "Lieto paātrinājumu %s reizes.",
    finishHardcoreMap = "Pabeidz %s „Hardcore” mapes.",
    sprayGraffiti = "Lieto paātrinājumu %s reizes.",
    rewindTimes = "Lieto attīšanu %s reizes.",

    --- PARTICLE START
    particleDef = "Šis ir noklusējuma efekts.",
    particleHearts = "Pievieno sirsniņas savam paātrinājumam!",
    particleSleek = "Foršs. Gluži kā tu.",

    --- GRAFFITI COLOR START
    graffitiColDef = "Šī ir noklusētā grafiti krāsa.",
    graffitiColBlack = "Tu esi tumšs cilvēks.",
    graffitiColDarkRed = "No kurienes ir šīs asinis?",

    --- GRAFFITI FONT START
    graffitiFontDef = "Šis ir noklusējuma grafiti fonts.",
    graffitiFontPapyrus = "Tu šķieti vecs.",
    graffitiFontVerdana = "Klasika.",
    graffitiFontCenturyGothic = "Ak, cik tu esi moderns.",

    infobarLevel = "Grūtība:", -- "Difficulty" makes more sense in this case so I used that
    infobarMice = "Peles:",
    infobarHardcore = "<R>HARDCORE</R>", -- didn't touch
    infobarTimeOver = "LAIKS STATISTIKAI!",
    infobarRecord = "Rekords:",
    infobarLoading = "Notiek ielāde..."

}
--[[ End of file translations/lv.lua ]]--
--[[ File translations/ro.lua ]]--
translations.ro = {
    name = "ro",
    lastTime = "Ultimul timp: %ss",
    lastBestTime = "Cel mai bun timp: %ss",
    helpToolTip = "<p align='center'>Apasă <b>H</b> pentru ajutor.</p>",
    optionsYes = "<font color='#53ba58'>Da</font>", -- 12
    optionsNo = "<font color='#f73625'>Nu</font>",  -- 13
    graffitiSetting = "Activezi graffitiurile", -- 14
    particlesSetting = "Activezi particulele de dash", -- 15
    timePanelsSetting = "Activezi panourile de timp", -- 16
    globalChatSetting = "Activezi chatul global",
    voteStart = "%s a inițiat un vot pentru a trece la următoarea mapă. Scrie !yes pentru a vota pozitiv.", -- 18
    newRecord = "<R>%s a terminat harta cel mai rapid! %ss</R>", --19
    devInfo = "<V>Vrei să faci o hartă pentru acest modul? Întră pe acest link: https://atelier801.com/topic?f=6&t=888399</V>\n<font color='#CB546B'>Acest modul este în curs de dezvoltare. Raportează orice problemă lui Extremq#0000 sau Railysse#0000.</font>", -- 20
    discordInfo = "<BV>Alătură-te discordului nostru! https://discord.gg/WawZVaq</BV>",
    welcomeInfo = "Bine ai venit pe <font color='#E68D43'>#ninja</font>! Apasă <font color='#E68D43'>H</font> pentru ajutor.", -- 21
    finishedInfo = "Ai terminat harta! <V>(%ss)</V>", --22
    helpBody = "Trebuie să aduci brânza înapoi la gaură cât mai rapid posibil.\n\n<b>Abilități</b>:\n» Dash - Apasă <b><font color='#CB546B'>săgeată Stânga</font></b> sau <b><font color='#CB546B'>Dreapta</font></b> de două ori. (reîncărcare 1s)\n» Jump - Apasă <b><font color='#CB546B'>săgeată Sus</font></b> de două ori. (reîncărcare 2s)\n» Rewind - Apasă <b><font color='#CB546B'>Spațiu</font></b> pentru a lăsa un checkpoint. Apasă <b><font color='#CB546B'>Spațiu</font></b> din nou în maximum 3 secunde pentru a te teleporta înapoi la checkpoint. (reîncărcare 10s)\n\n<b>Alte scurtături</b>:\n» Deschide meniul - Apasă <b><font color='#CB546B'>M</font></b> sau dă click în partea stângă a ecranului pentru a închide/deschide meniul.\n» Pune un graffiti - Apasă <b><font color='#CB546B'>C</font></b> pentru a lăsa un graffiti. (reîncărcare 60s\n» Omoară șoricelul - Apasă <b><font color='#CB546B'>X</font></b> sau scrie /mort pentru a omorî șoarecele.\n» Deschide instrucțiunile - Apasă <b><font color='#CB546B'>H</font></b> pentru a deschide/închide acest ecran.\n\n<b>Comenzi</b>:\n» !p Nume#id - Verifică statisticile altui player.\n» !pw Parolă - Pune parolă pe sală. (sala trebuie făcută de tine)\n» !m @cod - Încarcă ce hartă vrei tu. (trebuie ca sala să aibă parolă)\n» !langue țară - Schimbă limba modulului. (doar pentru tine)\n\n<p align='center'><a href='event:CloseMenu'><b><font color='#CB546B'>Închide</font></b></a></p>", --23
    Xbtn = "X", -- 24
    shopTitle = "Colecție", -- 25
    profileTitle = "Profil", -- 26
    leaderboardsTitle = "Clasamente", -- 27
    settingsTitle = "Setări", -- 28
    aboutTitle = "Despre", -- 29
    aboutBody = "Modul codat de <font color='#FFD991'>Extremq#0000</font>.\nIdei de joc, bug-testing și hărți asigurate de <font color='#FFD991'>Railysse#0000</font>.\n\nAcest modul este susținut în întregime de fundația șoricească „Brânza Roșie” în cadrul proiectului „Salvați Module”. Toate fondurile pe care le primim vor fi donate șoarecilor care stau pe #parkour cu scopul de a-i mitui să vină aici.\n\nGlumim, mulțumim că ne-ai încercat jocul! :D\n\n<p align='center'><font color='#f73625'>&lt;3</font></p>", -- 30
    playtime = "Timp jucat",
    firsts = "First-uri",
    finishedMaps = "Hărți completate",
    firstRate = "Rata first-urilor",
    holeEnters = "Intrări în gaură",
    graffitiUses = "Utilizări graffiti",
    dashUses = "Dash-uri folosite",
    rewindUses = "Rewind-uri folosite",
    hardcoreMaps = "Hărți grele completate",
    shopNotice = "Magazinul va fi deschis în curând.",
    leaderboardsNotice = "Clasamentul va fi implementat când modulul va deveni oficial.",
    notValidCommand = "%s nu este o comandă validă sau ai scris un argument greșit.",
    cantSetPass = "Nu se poate seta o parolă pe această sală.",
    translator = "Tradus de Extremq#0000.",
    version = "Versiune: %s",
    yourLoadout = "Echipamentul tău:",
    yourGraffiti = "Graffiti-ul tău:",
    change = "Schimbă",
    select = "Selectează",
    selected = "Selectat",
    locked = "Blocat",
    back = "Înapoi",
    comingSoon = "În curând!",
    requirements = "Cerințe",
    particleUnlock = "<ROSE>Ai deblocat o nouă particulă! Apasă M și selectează Colecție pentru a o încerca.</ROSE>",
    graffitiColorUnlock = "<ROSE>Ai deblocat o nouă culoare pentru graffiti! Apasă M și selectează Colecție pentru a o încerca.</ROSE>",
    graffitiFontUnlock = "<ROSE>Ai deblocat un nou font pentru graffiti! Apasă M și selectează Colecție pentru a îl încerca.</ROSE>",
    free = "Gratis.",
    finishMaps = "Termină %s hărți.",
    finishMapsFirst = "Termină %s hărți primul.",
    dashTimes = "Folosește abilitatea de dash de %s ori.",
    finishHardcoreMap = "Termină %s hărți hardcore.",
    sprayGraffiti = "Folosește graffiti-ul de %s ori.",
    rewindTimes = "Folosește abilitatea de rewind de %s ori.",
    dontRewind = "<CS>You rewinded, your stats haven't been saved!<CS>",

    --- PARTICLE START
    particleDef = "Aceasta este particula de bază",
    particleHearts = "Adaugă inimi dash-ului tău!",
    particleSleek = "Șmecher. Exact ca tine.",

    --- GRAFFITI COLOR START
    graffitiColDef = "Aceasta este culoarea de bază a graffiti-ului",
    graffitiColBlack = "Ești o persoană întunecată.",
    graffitiColDarkRed = "De unde este... sângele acesta?",

    --- GRAFFITI FONT START
    graffitiFontDef = "Acesta este font-ul de bază pentru graffiti-uri.",
    graffitiFontPapyrus = "Pari bărtân.",
    graffitiFontVerdana = "Un clasic.",
    graffitiFontCenturyGothic = "Wow, ești așa de modern.",
    
    infobarLevel = "Nivel:",
    infobarMice = "Șoareci:",
    infobarHardcore = "<R>DIFICIL</R>",
    infobarTimeOver = "STATISTICI!",
    infobarRecord = "Record:",
    infobarLoading = "Se încarcă..."
}
--[[ End of file translations/ro.lua ]]--
--[[ End of directory translations ]]--

--[[ File translationUtils.lua ]]--
--[[
    name: translationUtils.lua
    description: Contains translate() which formats strings and checks for available language
]]--

do
    function translate(playerName, what, ...)
        -- if we don't have this string translated, use english
        local language
        if playerName == nil then
            language = translations.en
        elseif string.sub(playerName, 1, 1) ~= "*" and string.find(playerName, "#") == nil then
            language = translations[playerName] or translations.en
        else
            language = playerVars[playerName].playerLanguage or translations.en
        end
        local translated = language[what] or translations.en[what]
        assert(translated, "'"..what.."' is an invalid argument.")
        
        if select("#", ...) > 0 then
            return string.format(translated, ...)
        end
        return translated
    end
end
--[[ End of file translationUtils.lua ]]--

--[[ File roles.lua ]]--
--[[
    name: roles.lua
    description: contains roles (mapper, mod, translator, etc.)
]]--
modList = {['Extremq#0000'] = true, ['Railysse#0000'] = true, ['Syrius#8114'] = true, ['Salmove#0000'] = true}
translatorList = {['Extremq#0000'] = true, ['Railysse#0000'] = true, ['Syrius#8114'] = true, ['Jaker#9310'] = true, ['Tocutoeltuco#0000'] = true, ['Osmanyksk123#5925'] = true, ['Poklava#0000'] = true}
devList = {['Extremq#0000'] = true, ['Railysse#0000'] = true, ['Syrius#8114'] = true}
mapperList = {['Railysse#0000'] = true}
modRoom = {}
opList = {}
--[[ End of file roles.lua ]]--

--[[ File maps.lua ]]--
--[[
    name: maps.lua
    description: Contains the maps.
]]--


-- Standard maps
stMapCodes = {{"@7725753", 3}, {"@7726015", 1}, {"@7726744", 2}, {"@7728063", 4}, {"@7731641", 2}, {"@7730637", 3}, {"@7732486", 2}, {"@6784223", 4}, {"@7734262", 3}, {"@7735744", 3}, {"@7735771", 3}, {"@7737995", 3}, {"@7048028", 2}, {"@7753263", 3}, {"@7734451", 5}, {"@7723036", 2}}
stMapsLeft = {{"@7725753", 3}, {"@7726015", 1}, {"@7726744", 2}, {"@7728063", 4}, {"@7731641", 2}, {"@7730637", 3}, {"@7732486", 2}, {"@6784223", 4}, {"@7734262", 3}, {"@7735744", 3}, {"@7735771", 3}, {"@7737995", 3}, {"@7048028", 2}, {"@7753263", 3}, {"@7734451", 5}, {"@7723036", 2}}

-- Hardcore maps
hcMapCodes = {{"@7733773", 6}, {"@7733777", 6}, {"@7737218", 6}, {"@7739215", 6}}
hcMapsLeft = {{"@7733773", 6}, {"@7733777", 6}, {"@7737218", 6}, {"@7739215", 6}}
--[[ End of file maps.lua ]]--

--[[ File mapUtils.lua ]]--
--[[
    name: mapUtils.lua
    description: Contains functions that help with the map picker algorithm and title setter.
]]--

MAPTIME = 3 * 60 + 3
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
    MAPTIME = BASETIME + (mapDiff - 1) * 30
    if mapDiff == 6 then
        MAPTIME = 4 * 60
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

    local difficultyMessage = "<J>"..difficulty.."/5</J>"
    if difficulty == 6 then
        difficultyMessage = translate(roomCommunity, "infobarHardcore")
    end

    local name = currentmapauthor.." <G>-<N> "..currentmapcode.." <G>-<N> "..translate(roomCommunity, "infobarLevel").." "..difficultyMessage.." <G>| <N>"..translate(roomCommunity, "infobarMice").." <J>"..room.uniquePlayers.." <G>| <N>"..minutes..":"..seconds
    -- Append record
    if fastestplayer ~= -1 then
        local record = (bestTime / 100)
        if fastestplayer:lower():find("http") then fastestplayer = ">:(#1234" end
        name = name.." <G>| <N2>"..translate(roomCommunity, "infobarRecord").." <R>"..removeTag(fastestplayer).."<font size='-3'><g>"..fastestplayer:match("#%d+").."</g></font>".." - "..record.."s"
    end

    -- If the map is over, we show stats
    if timeRemaining < 0 then
        name = translate(roomCommunity, "infobarTimeOver")
    end

    name = name.."<"
    setMapName(name)
end
--[[ End of file mapUtils.lua ]]--

--[[ File vars.lua ]]--
--[[
    name: vars.lua
    description: contains all player and map variables (shop, player structures and map vars)
]]--

unlocks = {
    -- same struct as shop
}

function shopListing(values, imgId, tooltip, reqs, fncArgs)
    return {
        ['values'] = values,
        ['imgId'] = imgId,
        ['tooltip'] = tooltip,
        ['reqs'] = reqs,
        ['fnc'] = function(playerName)
            if fncArgs == nil then 
                return true 
            elseif playerStats[playerName][fncArgs[1]] >= fncArgs[2] then
                return true
            else
                return false
            end
        end
    }
end

lastMap = ""
mapWasSkipped = false
mapStartTime = 0
mapDiff = 0
mapCount = 1
globalPlayerCount = 0
fastestplayer = -1
playerSortedBestTime = {}
playerCount = 0
playerWon = 0
mapfinished = false
admin = ""
customRoom = false
hasShownStats = false
bestTime = 99999

keys = {0, 1, 2, 3, 9, 27, 32, 67, 71, 72, 77, 80, 84, 88}

shop = {
    dashAcc = {
        shopListing({3}, "1730a4ad53e.png", "particleDef", {"free", nil}, nil),
        shopListing({3, 31}, "1730a950dc4.png", "particleHearts", {"finishMaps", 10}, {"mapsFinished", 10}),
        shopListing({3, 13}, "1730a952a0d.png", "particleSleek", {"finishMapsFirst", 1}, {"mapsFinishedFirst", 1}),
        shopListing({31, 32, 31}, "1730a94d7af.png", "particleLikeNinja", {"finishMaps", 50}, {"mapsFinished", 50}),
        shopListing({9, 14}, "1730a94f62a.png", "particleYouPro", {"finishHardcoreMaps", 1}, {"hardcoreMaps", 1}),
        shopListing({2, 24, 11}, "1730a9544bd.png", "particleToSky", {"doubleJumps", 100}, {"doubleJumps", 100})
    },
    graffitiCol = {
        shopListing(0xffffff, '#ffffff', "graffitiColDef", {"free", nil}, nil),
        shopListing(0x000001, '#000001', "graffitiColBlack", {"finishMaps", 25}, {"mapsFinished", 25}),
        shopListing(0x8c0404, '#8c0404', "graffitiColDarkRed", {"dashTimes", 100}, {"timesDashed", 100})
    },
    graffitiImgs = {
        shopListing(nil, nil, "This is the default image (no image).", "Free.", nil),
        shopListing("17290c497e1.png", "17290c497e1.png", "Say cheese!", "Finish 1 harcore map.", {"hardcoreMaps", 1})
    },
    graffitiFonts = {
        shopListing("Comic Sans MS", "Comic Sans MS", "graffitiFontDef", {"free", nil}, nil),
        shopListing("Papyrus", "Papyrus", "graffitiFontPapyrus", {"sprayGraffiti", 50}, {"graffitiSprays", 50}),
        shopListing("Verdana", "Verdana", "graffitiFontVerdana", {"doubleJumps", 200}, {"doubleJumps", 200}),
        shopListing("Century Gothic", "Century Gothic", "graffitiFontCenturyGothic", {"dashTimes", 50}, {"timesDashed", 50})
    }
}

-- We save ids so when a player leaves we still have their id (mostly to remove graffitis)
playerIds = {}
loaded = {}
inRoom = {}

queue = {

}

playerStats = {
    -- {
    --     playtime = 0,
    --     mapsFinished = 0,
    --     mapsFinishedFirst = 0,
    --     timesEnteredInHole = 0,
    --     graffitiSprays = 0,
    --     timesDashed = 0,
    --     timesRewinded = 0,
    --     hardcoreMaps = 0,
    --     equipment = {0, 0, 0, 0}
    -- }
}

function checkUnlock(playerName, what, index, message, ...)
    if customRoom == true then return end

    if unlocks[playerName][what][index] == false and shop[what][index].fnc(playerName) == true then
        chatMessage(translate(playerName, message, ...), playerName)
        unlocks[playerName][what][index] = true
    end
end


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
    --     playerPreferences = {true, true, false, false},
    --     playerLanguage = "en",
    --     playerFinished = false,
    --     rewindPos = {x, y},
    --     menuPage = 0,
    --     helpOpen = false,
    --     joinTime = os.time()
    -- }
}
--[[ End of file vars.lua ]]--

--[[ File eventWrapper.lua ]]--
local secureWrapper
do
  local function playerChecker(player)
    if loaded[player] == true and inRoom[player] == true then
        return true
    else
        return false
    end
  end

  function secureWrapper(fnc, first)
    if first then 
        return function(a, b, c, d, e)
        if playerChecker(a) then
          return fnc(a, b, c, d, e)
        end
      end
    else
      return function(a, b, c, d, e)
        if playerChecker(b) then
          return fnc(a, b, c, d, e)
        end
      end
    end
  end
end
--[[ End of file eventWrapper.lua ]]--

--[[ File abilities.lua ]]--
--[[
    name: abilities.lua
    description: Contains keyboard and mouse events + eventloop, all of which update ability cooldowns
    and such.
]]--

--CONSTANTS
STATSTIME = 10 * 1000
DASHCOOLDOWN = 0.5 * 1000
JUMPCOOLDOWN = 2 * 1000
REWINDCOOLDONW = 10 * 1000
GRAFFITICOOLDOWN = 10 * 1000

function showDashParticles(playerName, types, direction, x, y)
    -- Only display particles to the players who haven't disabled the setting
    for name, data in pairs(room.playerList) do
        if playerVars[name].playerPreferences[2] == true or playerName == name then
            for i = 1, #types do
                displayParticle(types[i], x, y, random() * direction, random(), 0, 0, name)
                displayParticle(types[i], x, y, random() * direction, -random(), 0, 0, name)
                displayParticle(types[i], x, y, random() * direction, -random(), 0, 0, name)
            end
        end
    end
end

-- This is different because jump has other directions
function showJumpParticles(playerName, types, x, y)
    -- Only display particles to the players who haven't disabled the setting
    for name, data in pairs(room.playerList) do
        if playerVars[name].playerPreferences[2] == true or playerName == name then
            for i = 1, #types do
                displayParticle(types[i], x, y, random(), -random()*2, 0, 0, name)
                displayParticle(types[i], x, y, -random(), -random()*2, 0, 0, name)
                displayParticle(types[i], x, y, -random(), -random()*2, 0, 0, name)
                displayParticle(types[i], x, y, random(), -random()*2, 0, 0, name)
            end
        end
    end
end

function showRewindParticles(type, playerName, x, y)
    displayParticle(type, x, y, -random(), random(), 0, 0, playerName)
    displayParticle(type, x, y, -random(), -random(), 0, 0, playerName)
    displayParticle(type, x, y, -random(), -random(), 0, 0, playerName)
    displayParticle(type, x, y, random(), -random(), 0, 0, playerName)
end

-- MOUSE POWERS
eventKeyboard = secureWrapper(function(playerName, keyCode, down, xPlayerPosition, yPlayerPosition)
    local id = playerId(playerName)

    local ostime = os.time()

    -- Everything here is for gameplay, so we only check them if the player isnt dead
    if room.playerList[playerName].isDead == false then
        --[[
            Because of the nature my dash works (both left and right keys share the same cooldown) I cannot shorten without checking for both
            doublepress and keypress. (though i can make the checker variable an array but it would look ugly.)
        ]]--
        if (keyCode == 0 or keyCode == 2) and ostime - cooldowns[playerName].lastDashTime > DASHCOOLDOWN then
            if ostime - playerVars[playerName].joinTime > 20 * 1000 and playerStats[playerName].timesDashed == 0 and playerVars[playerName].shownHelp == false then
                chatMessage("<V>[Sensei]</V> <N>"..translate(playerName, "senseiHelp1", playerName), playerName)
                playerVars[playerName].shownHelp = true
            end
            local dashUsed = false
            local direction = keyCode - 1 -- Tocu

            -- we check wether its left or right and if we double-tapped or not (can't shorten this)
            if keyCode == 2 and ostime - cooldowns[playerName].lastRightPressTime < 200 then
                dashUsed = true;
            elseif
                keyCode == 0 and ostime - cooldowns[playerName].lastLeftPressTime < 200 then
                dashUsed = true;
            end

            -- When we succesfully double tap without being on cooldown, we execute this.
            if dashUsed == true then
                -- Update cooldowns
                cooldowns[playerName].lastDashTime = ostime
                states[playerName].dashState = false

                -- Update cd image
                removeImage(imgs[playerName].dashButtonId)
                imgs[playerName].dashButtonId = addImage(DASH_BTN_OFF, "&1", DASH_BTN_X, DASH_BTN_Y, playerName)

                -- Update stats
                playerStats[playerName].timesDashed = playerStats[playerName].timesDashed + 1

                -- Check achievement
                checkUnlock(playerName, "graffitiCol", 3, "graffitiColorUnlock")
                checkUnlock(playerName, "graffitiFonts", 4, "graffitiFontUnlock")

                -- Move the palyer
                movePlayer(playerName, 0, 0, true, 150 * direction, 0, false)

                -- Now, we can change the 3 with whatever the player has equipped in the shop!
                showDashParticles(playerName, shop.dashAcc[playerStats[playerName].equipment[1]].values, direction, xPlayerPosition, yPlayerPosition)
            end
        --[[
            We check for the key, then if its a double press, then the cooldown. (by the way, if it fails to check, for example,
            keyCode == 1 then it won't check the other conditions, so we put the most important conditions first then follow up with
            those who are most likely to happen when we actually want to jump - its more likely that the player double presses when he has
            the cooldown available instead of doublepressing when the cooldown is offline.)
        ]]--
        elseif keyCode == 1 and ostime - cooldowns[playerName].lastJumpPressTime < 200 and ostime - cooldowns[playerName].lastJumpTime > JUMPCOOLDOWN  then
            -- Update cooldowns (press is for doublepress and the other for cooldown)
            cooldowns[playerName].lastJumpTime = ostime
            states[playerName].jumpState = false

            -- Update jump cd image
            removeImage(imgs[playerName].jumpButtonId)
            imgs[playerName].jumpButtonId = addImage(JUMP_BTN_OFF, "&1", JUMP_BTN_X, JUMP_BTN_Y, playerName)

            -- Update stats
            playerStats[playerName].doubleJumps = playerStats[playerName].doubleJumps + 1

            -- Check achievement
            checkUnlock(playerName, "dashAcc", 6, "particleUnlock")

            -- Move player
            movePlayer(playerName, 0, 0, true, 0, -60, false)

            -- Display jump particles
            showJumpParticles(playerName, shop.dashAcc[playerStats[playerName].equipment[1]].values, xPlayerPosition, yPlayerPosition)
        --[[
            The rewind is a bit more complicated, since it has 3 states: available, in use, not available.
            My first check is if I can rewind (state 2), then if my cooldown is available (state 1).
            If state 1 is true, then next time we press space state 2 must be true. After we use state 2, we will be on cooldown.
            The only states that enter this states 1 and 2.
        ]]--
        elseif keyCode == 32 and ostime - cooldowns[playerName].lastRewindTime > REWINDCOOLDONW then
            if cooldowns[playerName].canRewind == true then
                -- Tell game the player rewinded
                playerVars[playerName].hasUsedRewind = true

                -- Teleport the player to the checkpoint
                movePlayer(playerName, playerVars[playerName].rewindPos[1], playerVars[playerName].rewindPos[2], false, 0, 0, false)

                -- Update states & cooldowns
                cooldowns[playerName].lastRewindTime = ostime
                cooldowns[playerName].canRewind = false

                -- Update hourglass
                removeImage(imgs[playerName].rewindButtonId)
                imgs[playerName].rewindButtonId = addImage(REWIND_BTN_ACTIVE, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)

                -- Remove the mouse (the checkpoint)
                removeImage(imgs[playerName].mouseImgId)

                -- Show teleport particle
                displayParticle(36, xPlayerPosition, yPlayerPosition, 0, 0, 0, 0, nil)

                -- Show random particles (only time we use this are when we create the checkpoint and when the checkpoint dies (3 times in the code))
                showRewindParticles(2, playerName, xPlayerPosition, yPlayerPosition)

                -- If the player didn't have cheese when he created the checkpoint, we remove it
                if playerVars[playerName].rewindPos[3] == false then
                    tfm.exec.removeCheese(playerName)
                end

                -- Add to stats
                playerStats[playerName].timesRewinded = playerStats[playerName].timesRewinded + 1

                -- Check achiev
                checkUnlock(playerName, "graffitiFonts", 3, "graffitiFontUnlock")
            else
                -- Update cooldowns
                cooldowns[playerName].canRewind = true
                cooldowns[playerName].checkpointTime = ostime

                -- Save current player state (pos and cheese)
                playerVars[playerName].rewindPos = {xPlayerPosition, yPlayerPosition, room.playerList[playerName].hasCheese}

                -- Update hourglass
                imgs[playerName].mouseImgId = addImage(CHECKPOINT_MOUSE, "_100", xPlayerPosition - 59/2, yPlayerPosition - 73/2, playerName)
                removeImage(imgs[playerName].rewindButtonId)
                imgs[playerName].rewindButtonId = addImage(REWIND_BTN_OFF, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)

                -- Show particles where we teleport to
                showRewindParticles(2, playerName, playerVars[playerName].rewindPos[1], playerVars[playerName].rewindPos[2])
            end
            -- GRAFFITI (C)
        elseif id ~= 0 and keyCode == 67 and ostime - cooldowns[playerName].lastGraffitiTime > GRAFFITICOOLDOWN  then
            -- Update cooldowns
            cooldowns[playerName].lastGraffitiTime = ostime

            -- Update stats
            playerStats[playerName].graffitiSprays = playerStats[playerName].graffitiSprays + 1

            
            -- Check achiev
            checkUnlock(playerName, "graffitiFonts", 2, "graffitiFontUnlock")

            -- Create graffiti
            for player, data in pairs(room.playerList) do
                local _id = data.id
                -- If the player has graffitis enabled, we display them
                if _id ~= 0 and playerVars[player].playerPreferences[1] == true then
                    addTextArea(id, "<p align='center'><font face='"..shop.graffitiFonts[playerStats[playerName].equipment[4]].imgId.."' size='16' color='"..shop.graffitiCol[playerStats[playerName].equipment[2]].imgId.."'>"..string.gsub(playerName, "#%d%d%d%d", "").."</font></p>", player, xPlayerPosition - 300/2, yPlayerPosition - 25/2, 300, 25, 0x324650, 0x000000, 0, false)
                end
            end
        end
        -- This needs to be after dash/jump blocks.
        if keyCode == 0 then
            cooldowns[playerName].lastLeftPressTime = ostime
        elseif keyCode == 1 then
            cooldowns[playerName].lastJumpPressTime = ostime
        elseif keyCode == 2 then
            cooldowns[playerName].lastRightPressTime = ostime
        end
    end
    -- These keys are for various other purposes
    -- MORT (X) (mort is more likely to be called than the menu/help)
    if keyCode == 88 then
        killPlayer(playerName)
    -- MENU (M)
    elseif keyCode == 77 then
        -- If we don't have the menu open, then we dont have an image
        if imgs[playerName].menuImgId == nil then
            addTextArea(12, "<font color='#E9E9E9' size='10'><a href='event:ShopOpen'>             "..translate(playerName, "shopTitle").."</a>\n\n\n\n<a href='event:StatsOpen'>             "..translate(playerName, "profileTitle").."</a>\n\n\n\n<a href='event:LeaderOpen'>             "..translate(playerName, "leaderboardsTitle").."</a>\n\n\n\n<a href='event:SettingsOpen'>             "..translate(playerName, "settingsTitle").."</a>\n\n\n\n<a href='event:AboutOpen'>             "..translate(playerName, "aboutTitle").."</a>", playerName, 13, 103, 184, 220, 0x324650, 0x000000, 0, true)
            imgs[playerName].menuImgId = addImage(MENU_BUTTONS, ":10", MENU_BTN_X, MENU_BTN_Y, playerName)
        -- Else we had it already open, so we close the page
        else
            closePage(playerName)
        end
    -- PROFILE (P)
    elseif keyCode == 80 then
        if playerVars[playerName].menuPage ~= "profile" then
            openPage(translate(playerName, "profileTitle"), stats(playerName, playerName), playerName, "profile")
        elseif playerVars[playerName].menuPage == "profile" then
            closePage(playerName)
        end
        -- OPEN GUIDE / HELP (H)
    elseif keyCode == 72 then
        -- Help system
        if playerVars[playerName].menuPage ~= "help" then
            openPage("#ninja", "\n<font face='Verdana' size='12'>"..translate(playerName, "helpBody").."</font>", playerName, "help")
        elseif playerVars[playerName].menuPage == "help" then
            closePage(playerName)
        end
    -- CLOSE (ESC)
    elseif keyCode == 27 then
        if playerVars[playerName].menuPage ~= nil then
            closePage(playerName)
        end
    end
end, true)

-- I need the X for mouse computations
function extractMapDimensions()
    xml = tfm.get.room.xmlMapInfo.xml
    local p = string.match(xml, '<P(.*)/>')
    local x = string.match(p, 'L="(%d+)"')
    if x == nil then
        return 800
    end
    return tonumber(x)
end

eventMouse = secureWrapper(function(playerName, xMousePosition, yMousePosition)
    local id = playerId(playerName)
    local playerX = room.playerList[playerName].x
    -- print("click at "..xMousePosition)
    if modRoom[playerName] == true or opList[playerName] == true then
        movePlayer(playerName, xMousePosition, yMousePosition, false, 0, 0, false)
    end
    -- else
    --     --[[
    --         I basically convert mouse coordinates into ui coordinates (only for x, i don't care about y)
    --         in order to be able to open the menu when the mouse is in the left part of the screen.
    --         :D
    --     ]]--
    --     local uiMouseX = xMousePosition
    --     local mapX = extractMapDimensions()
    --     -- print("mapX ".. mapX)
    --     if playerX > 400 and playerX < mapX - 400 then
    --         uiMouseX = xMousePosition - (playerX - 400)
    --     elseif playerX > mapX - 400 then
    --         uiMouseX = xMousePosition - (mapX - 800)
    --     end
    --     -- print("uimouse "..uiMouseX)
    --     if -100 <= uiMouseX and uiMouseX <= 250 then
    --         if imgs[playerName].menuImgId == nil then
    --             addTextArea(12, "<font color='#E9E9E9' size='10'><a href='event:ShopOpen'>             "..translate(playerName, "shopTitle").."</a>\n\n\n\n<a href='event:StatsOpen'>             "..translate(playerName, "profileTitle").."</a>\n\n\n\n<a href='event:LeaderOpen'>             "..translate(playerName, "leaderboardsTitle").."</a>\n\n\n\n<a href='event:SettingsOpen'>             "..translate(playerName, "settingsTitle").."</a>\n\n\n\n<a href='event:AboutOpen'>             "..translate(playerName, "aboutTitle").."</a>", playerName, 13, 103, 184, 220, 0x324650, 0x000000, 0, true)
    --             imgs[playerName].menuImgId = addImage(MENU_BUTTONS, ":10", MENU_BTN_X, MENU_BTN_Y, playerName)
    --         else
    --             closePage(playerName)
    --         end
    --     end
    -- end
end, true)

local lastGug = 0

-- UI UPDATER & PLAYER RESPAWNER & REWINDER
function eventLoop(elapsedTime, timeRemaining)
    local ostime = os.time()
    local minute = os.date("%M", ostime)

    if minute == "00" then
        if ostime - lastGug > 60 * 1000 then
            lastGug = ostime
            local message = "GUG!"
            chatMessage("<V>[Sensei]</V><N> "..message)
        end 
    end

    -- Can't rely on elapsedTime
    updateMapName(MAPTIME * 1000 - (ostime - mapStartTime))
    --print(elapsedTime / 1000)

    -- When time reaches 0, we kill everyone and show stats
    if ((ostime - mapStartTime) >= MAPTIME * 1000 and (ostime - mapStartTime) < MAPTIME * 1000 + STATSTIME) then
        for index, value in pairs(room.playerList) do
            killPlayer(index)
        end
        if hasShownStats == false then
            hasShownStats = true
            showStats()
        end
    -- When passing the stats time or when skipping a map, we choose a new map
    elseif (ostime - mapStartTime) >= MAPTIME * 1000 + STATSTIME or mapWasSkipped == true then
        mapWasSkipped = false

        mapCount = mapCount + 1
        tfm.exec.setAutoMapFlipMode(randomFlip())
        -- Choose maptipe
        if mapCount % 6 == 0 then -- I don't want to run this yet
            tfm.exec.newGame(randomMap(hcMapsLeft, hcMapCodes))
        else
            tfm.exec.newGame(randomMap(stMapsLeft, stMapCodes))
        end
        -- Reset player values.
        resetAll()
    -- Else we are currently in the round, we respawn/update the cooldown indicators
    else
        for playerName in pairs(room.playerList) do
            local id = playerId(playerName)
            if inRoom[playerName] ~= nil and loaded[playerName] ~= nil then 
                -- RESPAWN PLAYER
                if playerVars[playerName].spectate == false then
                    respawnPlayer(playerName)
                else
                    killPlayer(playerName)
                end
                -- UPDATE UI
                --[[
                    This is where i use states: i basically keep track if i changed an icon's cooldown indicator. Why?
                    For example, lets say i have my cooldown ready. Without a state, i have no idea if i just got it now
                    or i had it already, so i have to remove the image and make it available, even if it was available.
                    With states, i can do it once and then just check if the state was changed (basically if i used the ability).
                ]]--
                if states[playerName].jumpState == false and ostime - cooldowns[playerName].lastJumpTime > JUMPCOOLDOWN then
                    states[playerName].jumpState = true
                    removeImage(imgs[playerName].jumpButtonId)
                    imgs[playerName].jumpButtonId = addImage(JUMP_BTN_ON, "&1", JUMP_BTN_X, JUMP_BTN_Y, playerName)
                end
                if states[playerName].dashState == false and ostime - cooldowns[playerName].lastDashTime > DASHCOOLDOWN then
                    states[playerName].dashState = true
                    removeImage(imgs[playerName].dashButtonId)
                    imgs[playerName].dashButtonId = addImage(DASH_BTN_ON, "&1", DASH_BTN_X, DASH_BTN_Y, playerName)
                end

                -- Don't forget i have 3 states for rewind, this happens if we are in state 2 (can rewind) but passed the time we had.
                if cooldowns[playerName].canRewind == true and ostime - cooldowns[playerName].checkpointTime > 3000 then
                    cooldowns[playerName].canRewind = false
                    cooldowns[playerName].lastRewindTime = ostime
                    removeImage(imgs[playerName].mouseImgId)
                    showRewindParticles(2, playerName, playerVars[playerName].rewindPos[1], playerVars[playerName].rewindPos[2])
                end

                if cooldowns[playerName].canRewind == true and states[playerName].rewindState ~= 2 then
                    states[playerName].rewindState = 2
                    removeImage(imgs[playerName].rewindButtonId)
                    imgs[playerName].rewindButtonId = addImage(REWIND_BTN_ACTIVE, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)
                elseif cooldowns[playerName].canRewind == false and states[playerName].rewindState ~= 1 and ostime - cooldowns[playerName].lastRewindTime > REWINDCOOLDONW then
                    states[playerName].rewindState = 1
                    removeImage(imgs[playerName].rewindButtonId)
                    imgs[playerName].rewindButtonId = addImage(REWIND_BTN_ON, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)
                elseif states[playerName].rewindState ~= 3 and ostime - cooldowns[playerName].lastRewindTime <= REWINDCOOLDONW then
                    states[playerName].rewindState = 3
                    removeImage(imgs[playerName].rewindButtonId)
                    imgs[playerName].rewindButtonId = addImage(REWIND_BTN_OFF, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)
                end
            end
        end
    end
end
--[[ End of file abilities.lua ]]--

--[[ File events.lua ]]--
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
        chatMessage("<CE>&lt; [<FC>Sensei</FC>] "..translate(playerName, "senseiTip"..math.random(1, 3), playerName), playerName)
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
            chatMessage("<CE>&lt; [<FC>Sensei</FC>] "..translate(playerName, "senseiRecord"..math.random(1, 8), playerName), playerName)
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
--[[ End of file events.lua ]]--

--[[ File initialization.lua ]]--
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
--[[ End of file initialization.lua ]]--

--[[ File ui.lua ]]--
--[[
    name: ui.lua
    description: Contains textAreaCallback and the functions that handle UI.
    and such.
]]--

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
HIDDEN_DASH = "172a559bc3d.png"
BLOCKED_DASH = "172a55a0456.png"
COLOR_IMG = "172b489f973.png"
FONTS_IMG = "172b48a10e4.png"
CLOSE_BTN = "173051dcff1.png"
BACK_BTN = "173064c765a.png"
SMALL_HEADER = "172cc5e81dd.png"
WIDE_HEADER = "172cc77b99a.png"
AREA_402_302 = "172e1893b19.png"
AREA_642_302 = "172e18cb032.png"
AREA_578_272 = "172e18ba635.png"
FORBIDDEN = "172cbf668e3.png"
LOCK = "172cbf0f080.png"
SELECTED = "172e3aa95bf.png"
PROFILE_LINE = "1731eef8db0.png"
MOD_BADGE = "17324209e2a.png"
DEV_BADGE = "172e0cf7ce5.png"
TRS_BADGE = "17323cc5687.png"
MPR_BADGE = "17323cc35d1.png"

--[[
    The way i manage UI in this module is basically this:
    Every page of the UI is the same textarea.
    I just call openPage and it will update/create on demand.
    This way i have standard UI and never have conflicts.
]]--

function putInClearQueue(what, where, playerName)
    if type(what) == "table" then
        for i = 1, #what do
            queue[playerName][where][#queue[playerName][where] + 1] = what[i]
        end
    else
        queue[playerName][where][#queue[playerName][where] + 1] = what
    end
end

function pageOperation(title, body, playerName, pageId)
    local id = playerId(playerName)

    playerVars[playerName].menuPage = pageId
    return body
end

-- Used to open a page
function openPage(title, body, playerName, pageId)
    updateTextArea(12, "<font color='#E9E9E9' size='10'><a href='event:ShopOpen'>             </a>\n\n\n\n<a href='event:StatsOpen'>             </a>\n\n\n\n<a href='event:LeaderOpen'>             </a>\n\n\n\n<a href='event:SettingsOpen'>             </a>\n\n\n\n<a href='event:AboutOpen'>             </a>", playerName)
    clear(playerName)
    windowConfig(title, body, playerName, pageId)
    lateUI(playerName)
end

function windowConfig(title, body, playerName, pageId)
    
    -- Area, Header and closebtn
    if pageId:find("profile") ~= nil then
        addTextArea(13, pageOperation(title, body, playerName, pageId), playerName, 126, 136, 410, 182, 0x1A353A, 0x7B5A35, 0, true)
        putInClearQueue(addImage(AREA_578_272, ":100", 111, 63, playerName), "img", playerName)
        putInClearQueue(addImage(CLOSE_BTN, ":100", 661, 55, playerName), "img", playerName)
        putInClearQueue(addImage(PROFILE_LINE, "&100", 128, 123, playerName), "img", playerName)
        addTextArea(15, "<a href='event:CloseMenu'>\n</a>", playerName, 663, 53, 20, 20, 0x324650, 0x000000, 0, true) 
    elseif pageId:find("about") ~= nil or pageId:find("help") ~= nil or pageId:find("leaderboards") ~= nil or pageId:find("settings") ~= nil then
        addTextArea(13, pageOperation(title, body, playerName, pageId), playerName, 230, 82, 340, 260, 0x1A353A, 0x7B5A35, 0, true)
        putInClearQueue(addImage(AREA_402_302, ":100", 198, 63, playerName), "img", playerName)
        putInClearQueue(addImage(CLOSE_BTN, ":100", 572, 55, playerName), "img", playerName)
        addTextArea(15, "<a href='event:CloseMenu'>\n</a>", playerName, 574, 53, 20, 20, 0x324650, 0x000000, 0, true) 
        putInClearQueue(13, "area", playerName)
    else
        addTextArea(13, pageOperation(title, body, playerName, pageId), playerName, 200, 62, 400, 300, 0x1A353A, 0x7B5A35, 0, true)
        putInClearQueue(addImage(AREA_402_302, ":100", 198, 63, playerName), "img", playerName)
        putInClearQueue(addImage(CLOSE_BTN, ":100", 572, 55, playerName), "img", playerName)
        addTextArea(15, "<a href='event:CloseMenu'>\n</a>", playerName, 574, 53, 20, 20, 0x324650, 0x000000, 0, true) 
        putInClearQueue(13, "area", playerName)
    end

    if #string.utf8(title) > 10 then
        putInClearQueue(addImage(WIDE_HEADER, ":100", 299, 35, playerName), "img", playerName)
    else 
        putInClearQueue(addImage(SMALL_HEADER, ":100", 316, 35, playerName), "img", playerName)
    end
    addTextArea(14, "<p align='center'><j><font size='16' face='tahoma' color='#F6CF34'><b>"..title.."</b></font></p>", playerName, 300, 45, 200, 26, 0x324650, 0x000000, 0, true)
    putInClearQueue({14,15}, "area", playerName)
end

-- Used to close a page
function closePage(playerName)
    clear(playerName)
    local id = playerId(playerName)
    removeTextArea(12, playerName)
    if imgs[playerName].menuImgId ~= nil then
        removeImage(imgs[playerName].menuImgId)
        imgs[playerName].menuImgId = nil
    end
    playerVars[playerName].menuPage = 0
end

-- End of round stats
function showStats()
    -- Init some empty array
    bestPlayers = {{"N/A", "N/A"}, {"N/A", "N/A"}, {"N/A", "N/A"}}
    table.sort(playerSortedBestTime, function(a, b)
        return a[2] < b[2]
    end)
    for i = 1, #playerSortedBestTime do
        if i == 4 then
            break
        end
        bestPlayers[i][1] = playerSortedBestTime[i][1]
        bestPlayers[i][2] = playerSortedBestTime[i][2]/100
    end

    local message = "\n\n\n\n\n\n\n\n<p align='center'>"
    message = message.."<font color='#ffd700' size='24'>1. "..bestPlayers[1][1].." - "..bestPlayers[1][2].."s</font>\n"
    message = message.."<font color='#c0c0c0' size='20'>2. "..bestPlayers[2][1].." - "..bestPlayers[2][2].."s</font>\n"
    message = message.."<font color='#cd7f32' size='18'>3. "..bestPlayers[3][1].." - "..bestPlayers[3][2].."s</font></p>"
    -- We open the stats for every player: if the player has a menu opened, we just update the text, otherwise create
    for name, value in pairs(room.playerList) do
        local _id = value.id
        openPage(translate(name, "leaderboardsTitle"), message, name, "roomStats")
    end
    -- If we had a best player, we update his firsts stat
    if bestPlayers[1][1] ~= "N/A" and tfm.get.room.uniquePlayers > 2 then
        local bestPlayer = bestPlayers[1][1]
        
        checkUnlock(bestPlayer, "dashAcc", 3, "particleUnlock")
        
        local beforeLevel = calculateLevel(bestPlayer)[1]
        playerStats[room.playerList[bestPlayer].playerName].mapsFinishedFirst = playerStats[room.playerList[bestPlayers[1][1]].playerName].mapsFinishedFirst + 1
        local afterLevel = calculateLevel(bestPlayer)[1]
        
        if afterLevel > beforeLevel then
            for index, value in pairs(room.playerList) do
                local message = translate(index, "levelUp", removeTag(bestPlayer).."<font size='-3'><g>"..bestPlayer:match("#%d+").."</g></font>", afterLevel)
                chatMessage(message, index)
            end
        end
        
        if math.random() < 1/2 then
            chatMessage("<V>[Sensei]</V> <N>"..translate(room.community, "senseiLeaderboard"..math.random(1, 5), bestPlayer, bestPlayer, bestPlayer))
        end
    end
end

--This returns the body of the profile screen, generating the stats of the selected player's profile.
function stats(playerName, creatorName)
    if playerName:sub(1,1) == "*" then return end
    local body = "<font size='12' face='Verdana'>"

    local seconds = math.floor((playerStats[playerName].playtime + os.time() - playerVars[playerName].joinTime) / 1000)

    local result = calculateLevel(playerName)

    body = body.."<textformat tabstops='0,205' font='Verdana'>Title: <V>«Speedy»</V>\tLevel: <v>"..result[1].."</v> <bl><font size='10'>("..result[2]..")</font></bl>\n\n"
    body = body..translate(creatorName, "firsts")..": <bl>"..playerStats[playerName].mapsFinishedFirst.."</bl>\t"..translate(creatorName, "graffitiUses")..": <bl>"..playerStats[playerName].graffitiSprays.."</bl>\n"
    body = body..translate(creatorName, "finishedMaps")..": <bl>"..playerStats[playerName].mapsFinished.."</bl>\t"..translate(creatorName, "playtime")..": <bl>"..math.floor(seconds/3600).."h "..math.floor(seconds%3600/60).."m "..(seconds%3600%60).."s</bl>\n"
    local firstrate = "0%"
    if playerStats[playerName].mapsFinishedFirst > 0 then
        firstrate = (math.floor(playerStats[playerName].mapsFinishedFirst/playerStats[playerName].mapsFinished * 10000) / 100).."%"
    end
    body = body..translate(creatorName, "firstRate")..": <bl>"..firstrate.."</bl>\t"..translate(creatorName, "holeEnters")..": <bl>"..playerStats[playerName].timesEnteredInHole.."</bl>\n"
    body = body.."\t"..translate(creatorName, "hardcoreMaps")..": <bl>"..playerStats[playerName].hardcoreMaps.."</bl>\n"
    body = body..translate(creatorName, "dashUses")..": <bl>"..playerStats[playerName].timesDashed.."</bl>\n"
    body = body..translate(creatorName, "timesDoubleJumped")..": <bl>"..playerStats[playerName].doubleJumps.."</bl>\n"
    body = body..translate(creatorName, "rewindUses")..": <bl>"..playerStats[playerName].timesRewinded.."</bl></textformat>"

    return body
end

function generateProfileImgs(playerName, target)
    
    if target:sub(1,1) == "*" then return end
    local graffitiTextX, graffitiTextY = 566, 245
    local badge_x, badge_y = {515, 490, 465, 450}, 95
    local currentBadges = {}

    if translatorList[target] == true then
        currentBadges[#currentBadges + 1] = TRS_BADGE
    end
    if mapperList[target] == true then
        currentBadges[#currentBadges + 1] = MPR_BADGE
    end
    if modList[target] == true then
        currentBadges[#currentBadges + 1] = MOD_BADGE
    end
    if devList[target] == true then
        currentBadges[#currentBadges + 1] = DEV_BADGE
    end

    for i=1, #currentBadges do
        putInClearQueue(addImage(currentBadges[i], "&100", badge_x[i], badge_y, playerName), "img", playerName)
    end

    local profileName = playerName
    local pageId = playerVars[playerName].menuPage
    if pageId:find("@") then
        profileName = pageId:match("@(%+?[a-zA-Z0-9_]+#%d+)")
    end
    local playerTag = profileName:match("#%d%d%d%d")
    local colorTag = 'V'
    if playerTag == "#0010" then
        colorTag = 'J'
    elseif playerTag == "#0020" then
        colorTag = 'BV'
    elseif playerTag == "#0001" then
        colorTag = 'R'
    end
    addTextArea(16, "<font face='Soopafresh,Verdana' size='30' color='#000000'>"..removeTag(profileName).." <font size='-5'>"..playerTag.." </font></font>", playerName, 128, 83, 438, 45, 0x324650, 0x000000, 0, true)
    addTextArea(17, "<font face='Soopafresh,Verdana' size='30'><"..colorTag..">"..removeTag(profileName).."</v> <font size='-5'></"..colorTag.."><g>"..playerTag.." </g></font></font>", playerName, 126, 80, 438, 45, 0x324650, 0x000000, 0, true)

    addTextArea(120, "", playerName, graffitiTextX, 89, 100, 100, 0x264E57, 0x264E57, 1, true)
    addTextArea(121, "", playerName, graffitiTextX, 210, 100, 100, 0x264E57, 0x264E57, 1, true)
    addTextArea(122, "<p align='center'><font face='"..shop.graffitiFonts[playerStats[target].equipment[4]].imgId.."' size='16' color='"..shop.graffitiCol[playerStats[target].equipment[2]].imgId.."'>"..string.gsub(target, "#%d%d%d%d", "").."</font></p>", playerName, graffitiTextX, graffitiTextY, 100, 50, 0x324650, 0x000000, 0, true)
    putInClearQueue(addImage(shop.dashAcc[playerStats[target].equipment[1]].imgId, "&2", 595, 115, playerName), "img", playerName)
    putInClearQueue({16, 17, 120, 121, 122}, "area", playerName)
end

-- This generates the settings body
function remakeOptions(playerName)
    -- REMAKE OPTIONS TEXT (UPDATE YES - NO)
    local id = playerId(playerName)

    local toggles = {}
    for i = 1, #playerVars[playerName].playerPreferences do
        if playerVars[playerName].playerPreferences[i] == true then
            toggles[i] = translate(playerName, "optionsYes")
        else
            toggles[i] = translate(playerName, "optionsNo")
        end
    end

    local body = "\n\n\n<font size='12' face='Verdana'><textformat tabstops='0, 280'>"
    body = body .. "<a href=\"event:ToggleGraffiti\">"..translate(playerName, "graffitiSetting").."?</a> \t"..toggles[1].." \n"
    body = body .. "\n<a href=\"event:ToggleDashPart\">"..translate(playerName, "particlesSetting").."?</a> \t"..toggles[2].." \n"
    body = body .. "\n<a href=\"event:ToggleTimePanels\">"..translate(playerName, "timePanelsSetting").."?</a> \t"..toggles[3].." \n"
    body = body .. "\n<a href=\"event:ToggleGlobalChat\">"..translate(playerName, "globalChatSetting").."?</a> \t"..toggles[4].." \n"

    return body
end

function clear(playerName)
    removeTextArea(13, playerName)
    for i = 1, #queue[playerName].area do
        removeTextArea(queue[playerName].area[i], playerName)
    end
    for i = 1, #queue[playerName].img do
        removeImage(queue[playerName].img[i], playerName)
    end
end

function addBackButton(playerName)
    putInClearQueue(addImage(BACK_BTN, ":101", 207, 55, playerName), "img", playerName)
    addTextArea(16, "<a href='event:Back'>\n</a>", playerName, 205, 53, 20, 20, 0x324650, 0x000000, 0, true) 
    putInClearQueue(16, "area", playerName)
end

-- For some textareas we have to add later than the main textarea
function lateUI(playerName)
    local page = playerVars[playerName].menuPage
    local pageNumber = tonumber(string.match(page, "%d+"))
    
    if page == "shop" then
        generateShopImgs(playerName)
    elseif string.sub(page, 1, 7) == "dashAcc" then
        addBackButton(playerName)
        createPageNumber(pageNumber, "dashAcc", playerName)
        generatedashAccImgsText(playerName, tonumber(string.match(page, "%d+")))
    elseif page == "graffiti" then
        generateGraffitiImages(playerName)
        addBackButton(playerName)
    elseif string.sub(page, 1, 11) == "graffitiCol" then 
        addBackButton(playerName)
        createPageNumber(pageNumber, "graffitiCol", playerName)
        generateGraffitiShopText(playerName, tonumber(string.match(page, "%d+")), "graffitiCol")
    elseif string.sub(page, 1, 13) == "graffitiFonts" then
        addBackButton(playerName)
        createPageNumber(pageNumber, "graffitiFonts", playerName)
        generateGraffitiShopText(playerName, tonumber(string.match(page, "%d+")), "graffitiFonts")
    elseif string.sub(page, 1, 7) == "profile" then
        local target = page:match("@(%w+#%d+)")
        if target == nil then
            target = playerName
        end
        generateProfileImgs(playerName, target)
    end
end

function createPageNumber(pageNumber, type, playerName)
    addTextArea(20, "<p align='center'><a href='event:PrevPage'>&lt;</a> "..pageNumber.."/"..maxShopPages(#shop[type]).." <a href='event:NextPage'>&gt;</a>", playerName, 367, 371, 66, 17, 0x1A353A, 0x7b5a35, 1, true) 
    putInClearQueue(20, "area", playerName)
end

-- Clears welcomeScreen images
function clearWelcomeImages(playerName)
    local id = playerId(playerName)
    if imgs[playerName].shopWelcomeDash ~= nil then
        removeImage(imgs[playerName].shopWelcomeDash, playerName)
        imgs[playerName].shopWelcomeDash = nil
    end

    local graffitiTextOffset = 1000000000
    removeTextArea(id + graffitiTextOffset, playerName)
end

-- This only is the welcome screen :D
function generateShopWelcome(playerName)
    local wordLength = #string.utf8(translate(playerName, "change"))
    local paddingCount = 10 - (wordLength - 6)
    local padding = ""
    for i = 1, paddingCount do
        padding = padding.." "
    end
    local body = "\n\n\n\n\n<font face='Verdana' size='16'><p align='center'><CS>"..translate(playerName, "yourLoadout").."</CS></p></font><font face='Lucida Console' size='16'>\n\n\n\n\n\n\n<p align='center'><a href='event:ChangePart'>["..translate(playerName, "change").."]</a><textformat>"..padding.."<textformat><a href='event:ChangeGraffiti'>["..translate(playerName, "change").."]\n</a></p></font>"
    return body
end

function generateGraffitiWelcome(playerName)
    local wordLength = #string.utf8(translate(playerName, "change"))
    local paddingCount = 10 - (wordLength - 6)
    local padding = ""
    for i = 1, paddingCount do
        padding = padding.." "
    end
    local body = "\n\n\n\n\n<font face='Verdana' size='16'><p align='center'><CS>"..translate(playerName, "yourGraffiti").."</CS></p></font><font face='Lucida Console' size='16'>\n\n\n\n\n\n\n<p align='center'><a href='event:GraffitiChangeColor'>["..translate(playerName, "change").."]</a><textformat>"..padding.."<textformat><a href='event:GraffitiChangeFont'>["..translate(playerName, "change").."]\n</a></p></font>"
    return body
end

function generateGraffitiImages(playerName)
    local colorX, colorY = 265, 155
    local fontX, fontY = 440, 155

    putInClearQueue(addImage(COLOR_IMG, "&2", colorX, colorY, playerName), "img", playerName)
    putInClearQueue(addImage(FONTS_IMG, "&3", fontX, fontY, playerName), "img", playerName)
end

--DEPRECATED
function generateShopPage(playerName, pageNumber, type)
    -- local body = "<a href='event:Back'>["..translate(playerName, "back").."]</a></p></font>"
    return ""
end

function generateShopImgs(playerName)
    local dashX, dashY = 260, 150

    putInClearQueue(addImage(shop.dashAcc[playerStats[playerName].equipment[1]].imgId, "&2", dashX + 30, dashY + 30, playerName), "img", playerName)
    
    local graffitiTextX, graffitiTextY = 375, 185
    addTextArea(120, "", playerName, 270, 160, 80, 80, 0x264E57, 0x264E57, 1, true)
    addTextArea(121, "", playerName, 450, 160, 80, 80, 0x264E57, 0x264E57, 1, true)
    addTextArea(122, "<p align='center'><font face='"..shop.graffitiFonts[playerStats[playerName].equipment[4]].imgId.."' size='16' color='"..shop.graffitiCol[playerStats[playerName].equipment[2]].imgId.."'>"..string.gsub(playerName, "#%d%d%d%d", "").."</font></p>", playerName, graffitiTextX, graffitiTextY, 230, 50, 0x324650, 0x000000, 0, true)

    putInClearQueue({120, 121, 122}, "area", playerName)
end

function maxShopPages(size)
    local value = size / 5
    if value - math.floor(value) > 0 then
        value = math.ceil(value)
    end
    return value
end

function generatedashAccImgsText(playerName, pageNumber)
    local ids = {50, 51, 52, 53, 54}
    local y = {85, 140, 195, 250, 305}
    local x = 270
    local imgBgX = 215
    local statusOffset = 35

    
    -- We sort them so the player only sees the unlocked items first
    local sortedOrder = {}
    for i = 1, #shop.dashAcc do
        if unlocks[playerName].dashAcc[i] == true then
            sortedOrder[#sortedOrder + 1] = i
        end
    end
    
    for i = 1, #shop.dashAcc do
        if unlocks[playerName].dashAcc[i] == false then
            sortedOrder[#sortedOrder + 1] = i
        end
    end

    for i = 1, 5 do
        local currentShopItem = shop.dashAcc[sortedOrder[(pageNumber - 1) * 5 + i]]
        local reqs

        if currentShopItem == nil then
            return
        end

        if currentShopItem ~= nil and currentShopItem.reqs[2] == nil then
            reqs = translate(playerName, currentShopItem.reqs[1])
        elseif currentShopItem ~= nil then
            reqs = translate(playerName, currentShopItem.reqs[1], currentShopItem.reqs[2])
        end

        if currentShopItem.fnc(playerName) == false then
            addTextArea(ids[i], "<font size='12'><CS><i>"..translate(playerName, currentShopItem.tooltip).."</i></CS></font>\n"..reqs, playerName, x, y[i], 315, 33, 0x0a1517, 0x122529, 0, true)
            putInClearQueue(addImage(LOCK, "&"..i + 100, imgBgX + statusOffset, y[i] + statusOffset, playerName), "img", playerName)
            addTextArea(ids[i] + 20, "", playerName, imgBgX, y[i] - 3, 40, 40, 0x264E57, 0x264E57, 1, true)
        else
            putInClearQueue(addImage(currentShopItem.imgId, "&"..i, imgBgX, y[i] - 2, playerName), "img", playerName)
            local selectState = "<a href='event:Select"..sortedOrder[(pageNumber - 1) * 5 + i].."'>"..translate(playerName, currentShopItem.tooltip).."</a>"
            if playerStats[playerName].equipment[1] == sortedOrder[(pageNumber - 1) * 5 + i] then
                selectState = "<b>"..translate(playerName, currentShopItem.tooltip).."</b>"
                addTextArea(ids[i] + 20, "", playerName, imgBgX, y[i] - 3, 40, 40, 0x264E57, 0x6FA105, 1, true)
                --putInClearQueue(addImage(SELECTED, "&"..i + 100, imgBgX + statusOffset, y[i] + statusOffset, playerName), "img", playerName)
            else
                addTextArea(ids[i] + 20, "", playerName, imgBgX, y[i] - 3, 40, 40, 0x264E57, 0x264E57, 1, true)
            end
            addTextArea(ids[i], "<font size='12'><i><CS>"..selectState.."</CS></i></font>\n"..reqs, playerName, x, y[i], 315, 33, 0x0a1517, 0x122529, 0, true)
        end 
        putInClearQueue(addImage(currentShopItem.imgId, "&"..i, imgBgX, y[i] - 2, playerName), "img", playerName)
        putInClearQueue({ids[i], ids[i] + 20}, "area", playerName)
    end
end

function generateGraffitiShopText(playerName, pageNumber, type)
    local ids = {50, 51, 52, 53, 54}
    local y = {85, 140, 195, 250, 305}
    local colIds = {60, 61, 62, 63, 64}
    local offsetX = 65
    local imgBgX = 215
    local statusOffset = 35
    local xText = {230 - offsetX, 350 - offsetX, 470 - offsetX}
    local x = 270
    
    -- We sort them so the player only sees the unlocked items first
    local sortedOrder = {}
    for i = 1, #shop[type] do
        if unlocks[playerName][type][i] == true then
            sortedOrder[#sortedOrder + 1] = i
        end
    end
    
    for i = 1, #shop[type] do
        if unlocks[playerName][type][i] == false then
            sortedOrder[#sortedOrder + 1] = i
        end
    end

    for i = 1, 5 do
        local currentShopItem = shop[type][sortedOrder[(pageNumber - 1) * 5 + i]]
        local reqs

        if currentShopItem == nil then
            return
        end

        if currentShopItem ~= nil and currentShopItem.reqs[2] == nil then
            reqs = translate(playerName, currentShopItem.reqs[1])
        elseif currentShopItem ~= nil then
            reqs = translate(playerName, currentShopItem.reqs[1], currentShopItem.reqs[2])
        end

        if currentShopItem.fnc(playerName) == false then
            addTextArea(ids[i], "<font size='12'><CS><i>"..translate(playerName, currentShopItem.tooltip).."</i></CS></font>\n"..reqs, playerName, x, y[i], 315, 33, 0x0a1517, 0x122529, 0, true)
            putInClearQueue(addImage(LOCK, "&"..i, imgBgX + statusOffset, y[i] + statusOffset, playerName), "img", playerName)
            if type == "graffitiCol" then
                addTextArea(ids[i] + 20, "", playerName, imgBgX, y[i] - 3, 40, 40, shop.graffitiCol[sortedOrder[(pageNumber - 1) * 5 + i]].values, 0x264E57, 1, true)
            elseif type == "graffitiFonts" then
                addTextArea(ids[i] + 20, "", playerName, imgBgX, y[i] - 3, 40, 40, 0x264E57, 0x264E57, 1, true)
                addTextArea(ids[i] + 100, "<p align='center'><font face='"..shop.graffitiFonts[sortedOrder[(pageNumber - 1) * 5 + i]].values.."' size='12' color='#ffffff'>Abc</font></p>", playerName, imgBgX, y[i] + 5, 40, 40, 0x264E57, 0x264E57, 0, true)
                putInClearQueue(ids[i] + 100, "area", playerName)
            end
        else
            local selectState = "<a href='event:Select"..sortedOrder[(pageNumber - 1) * 5 + i].."'>"..translate(playerName, currentShopItem.tooltip).."</a>"
            local isSelected = false
            local index = 2
            if type == "graffitiFonts" then
                index = 4
            end
            if playerStats[playerName].equipment[index] == sortedOrder[(pageNumber - 1) * 5 + i] then
                selectState = "<b>"..translate(playerName, currentShopItem.tooltip).."</b>"
                isSelected = true
                --putInClearQueue(addImage(SELECTED, "&"..i, imgBgX + statusOffset, y[i] + statusOffset, playerName), "img", playerName)
            end
            if type == "graffitiCol" then
                if isSelected == false then
                    addTextArea(ids[i] + 20, "", playerName, imgBgX, y[i] - 3, 40, 40, shop.graffitiCol[sortedOrder[(pageNumber - 1) * 5 + i]].values, 0x264E57, 1, true)
                else
                    addTextArea(ids[i] + 20, "", playerName, imgBgX, y[i] - 3, 40, 40, shop.graffitiCol[sortedOrder[(pageNumber - 1) * 5 + i]].values, 0x6FA105, 1, true)
                end
            elseif type == "graffitiFonts" then
                if isSelected == false then
                    addTextArea(ids[i] + 20, "", playerName, imgBgX, y[i] - 3, 40, 40, 0x264E57, 0x264E57, 1, true)
                else
                    addTextArea(ids[i] + 20, "", playerName, imgBgX, y[i] - 3, 40, 40, 0x264E57, 0x6FA105, 1, true)
                end
                addTextArea(ids[i] + 100, "<p align='center'><font face='"..shop.graffitiFonts[sortedOrder[(pageNumber - 1) * 5 + i]].values.."' size='12' color='#ffffff'>Abc</font></p>", playerName, imgBgX, y[i] + 5, 40, 40, 0x264E57, 0x264E57, 0, true)
                putInClearQueue(ids[i] + 100, "area", playerName)
            end
            addTextArea(ids[i], "<font size='12'><i><CS>"..selectState.."</CS></i></font>\n"..reqs, playerName, x, y[i], 315, 33, 0x0a1517, 0x122529, 0, true)
        end
        putInClearQueue({ids[i], ids[i] + 20}, "area", playerName)
    end
end

function eventTextAreaCallback(textAreaId, playerName, eventName)
    local id = playerId(playerName)

    -- 12 is the id for the menu buttons
    if textAreaId == 12 then
        if eventName == "ShopOpen" then
            openPage(translate(playerName, "shopTitle"), generateShopWelcome(playerName), playerName, "shop")
        elseif eventName == "StatsOpen" then
            openPage(translate(playerName, "profileTitle"), stats(playerName, playerName), playerName, "profile")
        elseif eventName == "LeaderOpen" then
            openPage(translate(playerName, "leaderboardsTitle"), "\n<font face='Verdana' size='12'>"..translate(playerName, "leaderboardsNotice").."</font>", playerName, "leaderboards")
        elseif eventName == "SettingsOpen" then
            openPage(translate(playerName, "settingsTitle"), remakeOptions(playerName), playerName, "settings")
        elseif eventName == "AboutOpen" then
            openPage(translate(playerName, "aboutTitle"), "\n<font face='Verdana' size='12'>"..translate(playerName, "aboutBody").."\n<p align='right'><CS>"..translate(playerName, "translator").."\n</CS><V>"..translate(playerName, "version", VERSION).."</V></p></font>", playerName, "about")
        end
    end

    local currentPage = playerVars[playerName].menuPage

    -- SETTINGS PAGE
    if currentPage == "settings" and textAreaId == 13 then
        if eventName == "ToggleGraffiti" then
            if playerVars[playerName].playerPreferences[1] == true then
                playerVars[playerName].playerPreferences[1] = false
                -- Remove graffitis
                for player, data in pairs(room.playerList) do
                    if data.id ~= 0 then
                        removeTextArea(data.id, playerName)
                    end
                end
            else
                playerVars[playerName].playerPreferences[1] = true
            end
        elseif eventName == "ToggleDashPart" then
            if playerVars[playerName].playerPreferences[2] == true then
                playerVars[playerName].playerPreferences[2] = false
            else
                playerVars[playerName].playerPreferences[2] = true
            end
        elseif eventName == "ToggleTimePanels" then
            if playerVars[playerName].playerPreferences[3] == true then
                playerVars[playerName].playerPreferences[3] = false
                removeTextArea(5, playerName)
                removeTextArea(4, playerName)
            else
                -- REGENERATE PANELS
                playerVars[playerName].playerPreferences[3] = true
                addTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translate(playerName, "lastTime", "N/A"), playerName, 10, 45, 200, 21, 0xffffff, 0x000000, 0, true)
                addTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translate(playerName, "lastBestTime", "N/A"), playerName, 10, 30, 200, 21, 0xffffff, 0x000000, 0, true)
                if playerVars[playerName].playerFinished == true then
                    ui.updateTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translate(playerName, "lastTime", playerVars[playerName].playerLastTime/100), playerName)
                    ui.updateTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translate(playerName, "lastBestTime", playerVars[playerName].playerBestTime/100), playerName)
                end
            end
        elseif eventName == "ToggleGlobalChat" then
            if playerVars[playerName].playerPreferences[4] == true then
                playerVars[playerName].playerPreferences[4] = false
            else
                playerVars[playerName].playerPreferences[4] = true
            end
        end
        if eventName ~= "CloseMenu" then
            openPage(translate(playerName, "settingsTitle"), remakeOptions(playerName), playerName, "settings")
        end
    elseif currentPage == "shop" then
        if eventName == "ChangePart" then
            openPage(translate(playerName, "shopTitle"), generateShopPage(playerName, 1, "dashAcc"), playerName, "dashAcc#1")
        elseif eventName == "ChangeGraffiti" then
            openPage(translate(playerName, "shopTitle"), generateGraffitiWelcome(playerName), playerName, "graffiti")
        end
    elseif currentPage == "graffiti" then
        if eventName == "GraffitiChangeColor" then
            openPage(translate(playerName, "shopTitle"), generateShopPage(playerName, 1, "graffitiCol"), playerName, "graffitiCol#1")
        elseif eventName == "GraffitiChangeFont" then
            openPage(translate(playerName, "shopTitle"), generateShopPage(playerName, 1, "graffitiFonts"), playerName, "graffitiFonts#1")
        end
    elseif string.find(currentPage, "dashAcc") then
        shopSystem(playerName, currentPage, "dashAcc", 1, eventName)
    elseif string.find(currentPage, "graffitiCol") then
        shopSystem(playerName, currentPage, "graffitiCol", 2, eventName)
    elseif string.find(currentPage, "graffitiFonts") then
        shopSystem(playerName, currentPage, "graffitiFonts", 4, eventName)
    end

    if eventName == "Back" then
        if string.find(currentPage, "dashAcc") or currentPage == "graffiti" then
            openPage(translate(playerName, "shopTitle"), generateShopWelcome(playerName), playerName, "shop")
        elseif string.find(currentPage, "graffitiCol") or string.find(currentPage, "graffitiFonts") then
            openPage(translate(playerName, "shopTitle"), generateGraffitiWelcome(playerName), playerName, "graffiti")
        end
    end

    if eventName == "CloseMenu" then
        closePage(playerName)
    end

    if eventName == "CloseWelcome" then
        if imgs[playerName].helpImgId ~= nil then
            removeImage(imgs[playerName].helpImgId)
        end
        removeTextArea(10, playerName)
    end
end

function shopSystem(playerName, currentPage, type, index, eventName)
    local currentPageNumber = tonumber(string.match(currentPage, "%d+"))

    if eventName == "NextPage" and currentPageNumber + 1 <= maxShopPages(#shop[type]) then
        openPage(translate(playerName, "shopTitle"), generateShopPage(playerName, currentPageNumber + 1, type), playerName, type.."#"..(currentPageNumber + 1))
    elseif eventName == "PrevPage" and tonumber(currentPageNumber) - 1 > 0 then
        openPage(translate(playerName, "shopTitle"), generateShopPage(playerName, currentPageNumber - 1, type), playerName, type.."#"..(currentPageNumber - 1))
    end

    if string.find(eventName, "Select") then
        local selectedcurrentPageNumber = tonumber(string.match(eventName, "%d+"))
        playerStats[playerName].equipment[index] = selectedcurrentPageNumber
        openPage(translate(playerName, "shopTitle"), generateShopPage(playerName, currentPageNumber, type), playerName, type.."#"..currentPageNumber)
    end
end
--[[ End of file ui.lua ]]--

--[[ File chatUtils.lua ]]--
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
--[[ End of file chatUtils.lua ]]--

--[[ File startFuncs.lua ]]--
--[[
    name: startFuncs.lua
    description: Contains code that must be executed at start.
]]--

do
    local _, msg = pcall(nil)
    local img = tfm.exec.addImage("a.jpg", "_0", 1, 1)
    local pdata = system.loadPlayerData("")

    tfm.get.room.loader = string.match(msg, "^(.-)%.")
    tfm.get.room.elevation = img and (pdata and "module" or "funcorp") or "player"
end

if tfm.get.room.elevation == "player" then
    addImage = function() end
    removeImage = function() end
    chatMessage = function() end
end

print("loader: " .. tfm.get.room.loader)
print("elevation: " .. tfm.get.room.elevation)
tfm.exec.disableAutoTimeLeft(true)
tfm.exec.disableAutoScore(true)
tfm.exec.disableAutoShaman(true)
tfm.exec.disableAfkDeath(true)
tfm.exec.disableAutoNewGame(true)
tfm.exec.setAutoMapFlipMode(randomFlip())
tfm.exec.newGame(randomMap(stMapsLeft, stMapCodes))
tfm.exec.disablePhysicalConsumables(true)
tfm.exec.setGameTime(MAPTIME, true)
tfm.exec.setRoomMaxPlayers(16)
tfm.exec.disablePrespawnPreview(true)
tfm.exec.disableAllShamanSkills(true)

if not tfm.get.room.name:find('#') or string.find(room.name, "^[a-z][a-z2]%-#ninja%d+editor%d*$") or string.find(room.name, "^%*?#ninja%d+editor%d*$") then
    customRoom = true
end

-- INIT ALL EXISTING PLAYERS
for playerName in pairs(room.playerList) do
    inRoom[playerName] = true
    initPlayer(playerName)
end
--[[ End of file startFuncs.lua ]]--
end