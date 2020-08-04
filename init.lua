local roomCreate = os.time()
tfm.exec.setRoomPassword("")

if string.find(tfm.get.room.name, "^[a-z][a-z2]%-#ninja%d+trade%d*$") or string.find(tfm.get.room.name, "^%*?#ninja%d+trade%d*$") then
{% require-file "trade.lua" %}
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

{% require-file "json.lua" %}

{% require-file "string.utf8.lua" %}

{% require-dir "translations" %}

{% require-file "translationUtils.lua" %}

{% require-file "roles.lua" %}

{% require-file "maps.lua" %}

{% require-file "mapUtils.lua" %}

{% require-file "vars.lua" %}

{% require-file "eventWrapper.lua" %}

{% require-file "abilities.lua" %}

{% require-file "events.lua" %}

{% require-file "initialization.lua" %}

{% require-file "ui.lua" %}

{% require-file "chatUtils.lua" %}

{% require-file "startFuncs.lua" %}
end