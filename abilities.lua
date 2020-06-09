--[[
    name: abilities.lua
    description: Contains keyboard and mouse events + eventloop, all of which update ability cooldowns
    and such.
]]--

--CONSTANTS
STATSTIME = 10 * 1000
DASHCOOLDOWN = 1 * 1000
JUMPCOOLDOWN = 3 * 1000
REWINDCOOLDONW = 10 * 1000
GRAFFITICOOLDOWN = 15 * 1000

function showDashParticles(types, direction, x, y)
    -- Only display particles to the players who haven't disabled the setting
    for name, data in pairs(room.playerList) do
        if playerVars[name].playerPreferences[2] == true then
            for i = 1, #types do
                displayParticle(types[i], x, y, random() * direction, random(), 0, 0, name)
                displayParticle(types[i], x, y, random() * direction, -random(), 0, 0, name)
                displayParticle(types[i], x, y, random() * direction, -random(), 0, 0, name)
                displayParticle(types[i], x, y, random() * direction, -random(), 0, 0, name)
            end
        end
    end
end

-- This is different because jump has other directions
function showJumpParticles(types, x, y)
    -- Only display particles to the players who haven't disabled the setting
    for name, data in pairs(room.playerList) do
        if playerVars[name].playerPreferences[2] == true then
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
function eventKeyboard(playerName, keyCode, down, xPlayerPosition, yPlayerPosition)
    local id = playerId(playerName)

    local ostime = os.time()

    -- Everything here is for gameplay, so we only check them if the player isnt dead
    if room.playerList[playerName].isDead == false then
        --[[
            Because of the nature my dash works (both left and right keys share the same cooldown) I cannot shorten without checking for both
            doublepress and keypress. (though i can make the checker variable an array but it would look ugly.)
        ]]--
        if (keyCode == 0 or keyCode == 2) and ostime - cooldowns[playerName].lastDashTime > DASHCOOLDOWN then
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

                -- Move the palyer
                movePlayer(playerName, 0, 0, true, 150 * direction, 0, false)

                -- Now, we can change the 3 with whatever the player has equipped in the shop!
                showDashParticles(shop.dashAcc[playerStats[playerName].equipment[1]].values, direction, xPlayerPosition, yPlayerPosition)
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
            playerStats[playerName].timesDashed = playerStats[playerName].timesDashed + 1

            -- Move player
            movePlayer(playerName, 0, 0, true, 0, -60, false)

            -- Display jump particles
            showJumpParticles(shop.dashAcc[playerStats[playerName].equipment[1]].values, xPlayerPosition, yPlayerPosition)
        --[[
            The rewind is a bit more complicated, since it has 3 states: available, in use, not available.
            My first check is if I can rewind (state 2), then if my cooldown is available (state 1).
            If state 1 is true, then next time we press space state 2 must be true. After we use state 2, we will be on cooldown.
            The only states that enter this states 1 and 2.
        ]]--
        elseif keyCode == 32 and ostime - cooldowns[playerName].lastRewindTime > REWINDCOOLDONW then
            if cooldowns[playerName].canRewind == true then
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

            -- Create graffiti
            for player, data in pairs(room.playerList) do
                local _id = data.id
                -- If the player has graffitis enabled, we display them
                if _id ~= 0 and playerVars[player].playerPreferences[1] == true then
                    addTextArea(id, "<p align='center'><font face='"..shop.graffitiFonts[playerStats[playerName].equipment[4]].imgId.."' size='16' color='"..shop.graffitiCol[playerStats[playerName].equipment[2]].imgId.."'>"..playerName.."</font></p>", player, xPlayerPosition - 300/2, yPlayerPosition - 25/2, 300, 25, 0x324650, 0x000000, 0, false)
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
        if imgs[playerName].menuImgId == -1 then
            addTextArea(12, "<font color='#E9E9E9' size='10'><a href='event:ShopOpen'>             "..playerVars[playerName].playerLanguage.shopTitle.."</a>\n\n\n\n<a href='event:StatsOpen'>             "..playerVars[playerName].playerLanguage.profileTitle.."</a>\n\n\n\n<a href='event:LeaderOpen'>             "..playerVars[playerName].playerLanguage.leaderboardsTitle.."</a>\n\n\n\n<a href='event:SettingsOpen'>             "..playerVars[playerName].playerLanguage.settingsTitle.."</a>\n\n\n\n<a href='event:AboutOpen'>             "..playerVars[playerName].playerLanguage.aboutTitle.."</a>", playerName, 13, 103, 184, 220, 0x324650, 0x000000, 0, true)
            imgs[playerName].menuImgId = addImage(MENU_BUTTONS, ":10", MENU_BTN_X, MENU_BTN_Y, playerName)
        -- Else we had it already open, so we close the page
        else
            closePage(playerName)
        end
    -- OPEN GUIDE / HELP (H)
    elseif keyCode == 72 then
        -- Help system
        if playerVars[playerName].menuPage ~= "help" then
            openPage("#ninja", "\n<font face='Verdana' size='11'>"..playerVars[playerName].playerLanguage.helpBody.."</font>", playerName, "help")
        elseif playerVars[playerName].menuPage == "help" then
            closePage(playerName)
        end
    end
end

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

function eventMouse(playerName, xMousePosition, yMousePosition)
    local id = playerId(playerName)
    local playerX = room.playerList[playerName].x
    -- print("click at "..xMousePosition)
    if modRoom[playerName] == true or opList[playerName] == true then
        movePlayer(playerName, xMousePosition, yMousePosition, false, 0, 0, false)
    else
        --[[
            I basically convert mouse coordinates into ui coordinates (only for x, i don't care about y)
            in order to be able to open the menu when the mouse is in the left part of the screen.
            :D
        ]]--
        local uiMouseX = xMousePosition
        local mapX = extractMapDimensions()
        -- print("mapX ".. mapX)
        if playerX > 400 and playerX < mapX - 400 then
            uiMouseX = xMousePosition - (playerX - 400)
        elseif playerX > mapX - 400 then
            uiMouseX = xMousePosition - (mapX - 800)
        end
        -- print("uimouse "..uiMouseX)
        if -100 <= uiMouseX and uiMouseX <= 250 then
            if imgs[playerName].menuImgId == -1 then
                addTextArea(12, "<font color='#E9E9E9' size='10'><a href='event:ShopOpen'>             "..playerVars[playerName].playerLanguage.shopTitle.."</a>\n\n\n\n<a href='event:StatsOpen'>             "..playerVars[playerName].playerLanguage.profileTitle.."</a>\n\n\n\n<a href='event:LeaderOpen'>             "..playerVars[playerName].playerLanguage.leaderboardsTitle.."</a>\n\n\n\n<a href='event:SettingsOpen'>             "..playerVars[playerName].playerLanguage.settingsTitle.."</a>\n\n\n\n<a href='event:AboutOpen'>             "..playerVars[playerName].playerLanguage.aboutTitle.."</a>", playerName, 13, 103, 184, 220, 0x324650, 0x000000, 0, true)
                imgs[playerName].menuImgId = addImage(MENU_BUTTONS, ":10", MENU_BTN_X, MENU_BTN_Y, playerName)
            else
                closePage(playerName)
            end
        end
    end
end

-- UI UPDATER & PLAYER RESPAWNER & REWINDER
function eventLoop(elapsedTime, timeRemaining)
    local ostime = os.time()

    -- Can't rely on elapsedTime
    updateMapName(MAPTIME * 1000 - (ostime - mapStartTime))
    --print(elapsedTime / 1000)

    -- When time reaches 0, we kill everyone and show stats
    if (elapsedTime >= MAPTIME * 1000 and elapsedTime < MAPTIME * 1000 + STATSTIME) then
        for index, value in pairs(room.playerList) do
            killPlayer(index)
        end
        if hasShownStats == false then
            hasShownStats = true
            showStats()
        end
    -- When passing the stats time or when skipping a map, we choose a new map
    elseif elapsedTime >= MAPTIME * 1000 + STATSTIME or mapWasSkipped == true then
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
            -- RESPAWN PLAYER
            tfm.exec.respawnPlayer(playerName)
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