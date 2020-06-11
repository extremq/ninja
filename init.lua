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

-- RETURN PLAYER ID
function playerId(playerName)
    return playerIds[playerName]
end

local translations = {}

VERSION = "1.5.4, 09.06.2020"

{% require-dir "translations" %}

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