tfm.exec.disableAutoShaman(true)
tfm.exec.newGame("@7735241")
tfm.exec.setGameTime(10000)
tfm.exec.disableAfkDeath(true)
function showDashParticles(types, direction, x, y) 
    for i = 1, #types do
        tfm.exec.displayParticle(types[i], x, y, math.random() * direction, math.random(), 0, 0, nil)
        tfm.exec.displayParticle(types[i], x, y, math.random() * direction, -math.random(), 0, 0, nil)
        tfm.exec.displayParticle(types[i], x, y, math.random() * direction, -math.random(), 0, 0, nil)
        tfm.exec.displayParticle(types[i], x, y, math.random() * direction, -math.random(), 0, 0, nil)
    end
end


function eventChatCommand(playerName, message)
    local arg = {}
    for argument in message:gmatch("[^%s]+") do
        table.insert(arg, argument)
    end

    arg[1] = string.lower(arg[1])
    
    if arg[1] == "p" and arg[2] ~= nil then
        local types = {arg[2]}
        for i = 3, #arg do
            table.insert(types, arg[i])
        end
        showDashParticles(types, 1, 400, 200)
    end
end