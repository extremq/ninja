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

--[[
    The way i manage UI in this module is basically this:
    Every page of the UI is the same textarea.
    I just call openPage and it will update/create on demand.
    This way i have standard UI and never have conflicts.
]]--
function pageOperation(title, body, playerName, pageId)
    clear(playerName)
    local id = playerId(playerName)
    local closebtn = "<font color='#CB546B'><a href='event:CloseMenu'>"..translations[playerVars[playerName].playerLanguage].Xbtn.."</a></font>"

    local spaceLength = 40 - #translations[playerVars[playerName].playerLanguage].Xbtn - #title
    local padding = ""
    for i = 1, spaceLength do
        padding = padding.." "
    end

    local pageTitle = "<font size='16' face='Lucida Console'>"..title.."<textformat>"..padding.."</textformat>"..closebtn.."</font>\n"
    local pageBody = body
    playerVars[playerName].menuPage = pageId
    return pageTitle..pageBody
end

-- Used to open a page
function openPage(title, body, playerName, pageId)
    if playerVars[playerName].menuPage == 0 then
        ui.addTextArea(13, pageOperation(title, body, playerName, pageId), playerName, 198, 50, 406, 300, 0x122529, 0x2b5860, 0.9, true)
    else  
        ui.updateTextArea(13, pageOperation(title, body, playerName, pageId), playerName)
    end
end


-- Used to close a page
function closePage(playerName)
    clear(playerName)
    local id = playerId(playerName)
    removeTextArea(13, playerName)
    removeTextArea(12, playerName)
    removeImage(imgs[playerName].menuImgId)
    playerVars[playerName].menuPage = 0
    imgs[playerName].menuImgId = -1
end

-- Used to clear images from menu
function clear(playerName)
    local page = playerVars[playerName].menuPage
    if page == "shop" then
        clearWelcomeImages(playerName)
    end
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

    local message = "\n\n\n\n\n\n\n<p align='center'>"
    message = message.."<font color='#ffd700' size='24'>1. "..bestPlayers[1][1].." - "..bestPlayers[1][2].."s</font>\n"
    message = message.."<font color='#c0c0c0' size='20'>2. "..bestPlayers[2][1].." - "..bestPlayers[2][2].."s</font>\n"
    message = message.."<font color='#cd7f32' size='18'>3. "..bestPlayers[3][1].." - "..bestPlayers[3][2].."s</font></p>"
    -- We open the stats for every player: if the player has a menu opened, we just update the text, otherwise create
    for name, value in pairs(room.playerList) do
        local _id = value.id
        openPage(translations[playerVars[name].playerLanguage].leaderboardsTitle, message, name, "roomStats")
    end
    -- If we had a best player, we update his firsts stat
    if bestPlayers[1][1] ~= "N/A" then
        playerStats[room.playerList[bestPlayers[1][1]].playerName].mapsFinishedFirst = playerStats[room.playerList[bestPlayers[1][1]].playerName].mapsFinishedFirst + 1
    end
end

--This returns the body of the profile screen, generating the stats of the selected player's profile.
function stats(playerName, creatorName)
    local body = "\n"

    local seconds = math.floor((os.time() - playerVars[playerName].joinTime) / 1000)

    body = body.." » "..translations[playerVars[creatorName].playerLanguage].playtime..": <font color='#f73625'>"..math.floor(seconds/3600).."</font>h <font color='#f73625'>"..math.floor(seconds%3600/60).."</font>m <font color='#f73625'>"..(seconds%3600%60).."</font>s\n"
    body = body.." » "..translations[playerVars[creatorName].playerLanguage].firsts..": <font color='#f73625'>"..playerStats[playerName].mapsFinishedFirst.."</font>\n"
    body = body.." » "..translations[playerVars[creatorName].playerLanguage].finishedMaps..": <font color='#f73625'>"..playerStats[playerName].mapsFinished.."</font>\n"
    local firstrate = "0%"
    if playerStats[playerName].mapsFinishedFirst > 0 then
        firstrate = (math.floor(playerStats[playerName].mapsFinishedFirst/playerStats[playerName].mapsFinished * 10000) / 100).."%"
    end
    body = body.." » "..translations[playerVars[creatorName].playerLanguage].firstRate..": <font color='#f73625'>"..firstrate.."</font>\n"
    body = body.." » "..translations[playerVars[creatorName].playerLanguage].holeEnters..": <font color='#f73625'>"..playerStats[playerName].timesEnteredInHole.."</font>\n"
    body = body.." » "..translations[playerVars[creatorName].playerLanguage].graffitiUses..": <font color='#f73625'>"..playerStats[playerName].graffitiSprays.."</font>\n"
    body = body.." » "..translations[playerVars[creatorName].playerLanguage].dashUses..": <font color='#f73625'>"..playerStats[playerName].timesDashed.."</font>\n"
    body = body.." » "..translations[playerVars[creatorName].playerLanguage].rewindUses..": <font color='#f73625'>"..playerStats[playerName].timesRewinded.."</font>\n"
    body = body.." » "..translations[playerVars[creatorName].playerLanguage].hardcoreMaps..": <font color='#f73625'>"..playerStats[playerName].hardcoreMaps.."</font>\n"

    return "<font face='Verdana' size='11'>"..body.."</font>"
end

-- This generates the settings body
function remakeOptions(playerName)
    -- REMAKE OPTIONS TEXT (UPDATE YES - NO)
    local id = playerId(playerName)

    toggles = {}
    for i = 1, #playerVars[playerName].playerPreferences do
        if playerVars[playerName].playerPreferences[i] == true then
            toggles[i] = translations[playerVars[playerName].playerLanguage].optionsYes
        else
            toggles[i] = translations[playerVars[playerName].playerLanguage].optionsNo
        end
    end

    local body = " » <a href=\"event:ToggleGraffiti\">"..translations[playerVars[playerName].playerLanguage].graffitiSetting.."?</a> "..toggles[1].."\n » <a href=\"event:ToggleDashPart\">"..translations[playerVars[playerName].playerLanguage].particlesSetting.."?</a> "..toggles[2].."\n » <a href=\"event:ToggleTimePanels\">"..translations[playerVars[playerName].playerLanguage].timePanelsSetting.."?</a> "..toggles[3]
    body = body.."\n » <a href=\"event:ToggleGlobalChat\">"..translations[playerVars[playerName].playerLanguage].globalChatSetting.."?</a> "..toggles[4].."\n"
    return "\n<font face='Verdana' size='11'>"..body.."</font>"
end

-- This only is the welcome screen :D
function generateShopWelcome(playerName)
    local id = playerId(playerName)
    local dashX, dashY = 255, 150

    imgs[playerName].shopWelcomeDash = addImage(shop.dashAcc[playerStats[playerName].equipment[1]].imgId, "&2", dashX, dashY, playerName)

    local body = "\n\n\n\n<font face='Lucida Console' size='16'><p align='center'><CS>Your loadout!</CS></p>\n\n\n\n\n\n<textformat>       <textformat><a href='event:ChangePart'>[change]</a><textformat>         <textformat><a href='event:ChangeGraffiti'>[change]</a></font>\n\n\n"
    return body
end

-- Clears welcomeScreen images
function clearWelcomeImages(playerName)
    local id = playerId(playerName)
    removeImage(imgs[playerName].shopWelcomeDash, playerName)
    local graffitiTextOffset = 1000000000
    removeTextArea(id + graffitiTextOffset, playerName)
end

function eventTextAreaCallback(textAreaId, playerName, eventName)
    local id = playerId(playerName)

    -- 12 is the id for the menu buttons
    if textAreaId == 12 then
        if eventName == "ShopOpen" then
            openPage(translations[playerVars[playerName].playerLanguage].shopTitle, generateShopWelcome(playerName), playerName, "shop")
            local graffitiTextX, graffitiTextY, graffitiTextOffset = 365, 185, 1000000000
            ui.addTextArea(id + graffitiTextOffset, "<p align='center'><font face='"..shop.graffitiFonts[playerStats[playerName].equipment[4]].imgId.."' size='16' color='"..shop.graffitiCol[playerStats[playerName].equipment[2]].imgId.."'>"..playerName.."</font></p>", playerName, graffitiTextX, graffitiTextY, 230, 25, 0x324650, 0x000000, 0, true)
        end
        if eventName == "StatsOpen" then
            openPage(translations[playerVars[playerName].playerLanguage].profileTitle.." - "..playerName, stats(playerName, playerName), playerName, "profile")
        end
        if eventName == "LeaderOpen" then
            openPage(translations[playerVars[playerName].playerLanguage].leaderboardsTitle, "\n<font face='Verdana' size='11'>"..translations[playerVars[playerName].playerLanguage].leaderboardsNotice.."</font>", playerName, "leaderboards")
        end
        if eventName == "SettingsOpen" then
            openPage(translations[playerVars[playerName].playerLanguage].settingsTitle, remakeOptions(playerName), playerName, "settings")
        end
        if eventName == "AboutOpen" then
            openPage(translations[playerVars[playerName].playerLanguage].aboutTitle, "\n<font face='Verdana' size='11'>"..translations[playerVars[playerName].playerLanguage].aboutBody.."\n\n\n\n\n\n<p align='right'><CS>"..translations[playerVars[playerName].playerLanguage].translator.."\n</CS><V>version: "..VERSION.."</V></p></font>", playerName, "about")
        end
    end

    -- SETTINGS PAGE
    if playerVars[playerName].menuPage == "settings" and textAreaId == 13 then
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
                addTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[playerName].playerLanguage].lastTime..": N/A", playerName, 10, 45, 200, 21, 0xffffff, 0x000000, 0, true)
                addTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[playerName].playerLanguage].lastBestTime..": N/A", playerName, 10, 30, 200, 21, 0xffffff, 0x000000, 0, true)
                if playerVars[playerName].playerFinished == true then
                    ui.updateTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[playerName].playerLanguage].lastTime..": "..(playerVars[playerName].playerLastTime/100).."s", playerName)
                    ui.updateTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[playerName].playerLanguage].lastBestTime..": "..(playerVars[playerName].playerBestTime/100).."s", playerName)
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
            openPage(translations[playerVars[playerName].playerLanguage].settingsTitle, remakeOptions(playerName), playerName, "settings")
        end
    end

    if eventName == "CloseMenu" then
        closePage(playerName)
    end

    if eventName == "CloseWelcome" then
        if imgs[playerName].helpImgId ~= 0 then
            removeImage(imgs[playerName].helpImgId)
        end
        removeTextArea(10, playerName)
    end
end