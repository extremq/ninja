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

if not tfm.get.room.name:find('#') or string.find(room.name, "^[a-z][a-z2]%-#ninja%d+editor%d*$") or string.find(room.name, "^%*?#ninja%d+editor%d*$") then
    customRoom = true
end

-- INIT ALL EXISTING PLAYERS
for playerName in pairs(room.playerList) do
    inRoom[playerName] = true
    initPlayer(playerName)
end