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
CLOSE_BTN = "172e0c9820e.png"
SMALL_HEADER = "172cc5e81dd.png"
AREA_402_302 = "172e1893b19.png"
FORBIDDEN = "172cbf668e3.png"
LOCK = "172cbf0f080.png"
SELECTED = "172e3aa95bf.png"

--[[
    The way i manage UI in this module is basically this:
    Every page of the UI is the same textarea.
    I just call openPage and it will update/create on demand.
    This way i have standard UI and never have conflicts.
]]--


function pageOperation(title, body, playerName, pageId)
    clear(playerName)
    local id = playerId(playerName)

    playerVars[playerName].menuPage = pageId
    return body
end

-- Used to open a page
function openPage(title, body, playerName, pageId)
    addTextArea(13, pageOperation(title, body, playerName, pageId), playerName, 200, 62, 400, 300, 0x1A353A, 0x7B5A35, 0, true)
    
    lateUI(playerName)

    -- Area, Header and closebtn
    imgs[playerName].area = addImage(AREA_402_302, ":100", 198, 63, playerName)
    imgs[playerName].header = addImage(SMALL_HEADER, ":100", 316, 35, playerName)
    imgs[playerName].closeBtn = addImage(CLOSE_BTN, ":100", 572, 55, playerName)
    addTextArea(14, "<p align='center'><j><font size='16' face='tahoma' color='#F6CF34'><b>"..title.."</b></font></p>", playerName, 300, 45, 200, 26, 0x324650, 0x000000, 0, true)
    addTextArea(15, "<a href='event:CloseMenu'>\n</a>", playerName, 574, 53, 20, 20, 0x324650, 0x000000, 0, true) 
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

    local message = "\n\n\n\n\n\n\n<p align='center'>"
    message = message.."<font color='#ffd700' size='24'>1. "..bestPlayers[1][1].." - "..bestPlayers[1][2].."s</font>\n"
    message = message.."<font color='#c0c0c0' size='20'>2. "..bestPlayers[2][1].." - "..bestPlayers[2][2].."s</font>\n"
    message = message.."<font color='#cd7f32' size='18'>3. "..bestPlayers[3][1].." - "..bestPlayers[3][2].."s</font></p>"
    -- We open the stats for every player: if the player has a menu opened, we just update the text, otherwise create
    for name, value in pairs(room.playerList) do
        local _id = value.id
        openPage(translate(name, "leaderboardsTitle"), message, name, "roomStats")
    end
    -- If we had a best player, we update his firsts stat
    if bestPlayers[1][1] ~= "N/A" then
        checkUnlock(bestPlayers[1][1], "dashAcc", 3, "particleUnlock")
        playerStats[room.playerList[bestPlayers[1][1]].playerName].mapsFinishedFirst = playerStats[room.playerList[bestPlayers[1][1]].playerName].mapsFinishedFirst + 1
    end
end

--This returns the body of the profile screen, generating the stats of the selected player's profile.
function stats(playerName, creatorName)
    local body = "\n"

    local seconds = math.floor((os.time() - playerVars[playerName].joinTime) / 1000)

    body = body.." » "..translate(playerName, "playtime")..": <font color='#f73625'>"..math.floor(seconds/3600).."</font>h <font color='#f73625'>"..math.floor(seconds%3600/60).."</font>m <font color='#f73625'>"..(seconds%3600%60).."</font>s\n"
    body = body.." » "..translate(playerName, "firsts")..": <font color='#f73625'>"..playerStats[playerName].mapsFinishedFirst.."</font>\n"
    body = body.." » "..translate(playerName, "finishedMaps")..": <font color='#f73625'>"..playerStats[playerName].mapsFinished.."</font>\n"
    local firstrate = "0%"
    if playerStats[playerName].mapsFinishedFirst > 0 then
        firstrate = (math.floor(playerStats[playerName].mapsFinishedFirst/playerStats[playerName].mapsFinished * 10000) / 100).."%"
    end
    body = body.." » "..translate(playerName, "firstRate")..": <font color='#f73625'>"..firstrate.."</font>\n"
    body = body.." » "..translate(playerName, "holeEnters")..": <font color='#f73625'>"..playerStats[playerName].timesEnteredInHole.."</font>\n"
    body = body.." » "..translate(playerName, "graffitiUses")..": <font color='#f73625'>"..playerStats[playerName].graffitiSprays.."</font>\n"
    body = body.." » "..translate(playerName, "dashUses")..": <font color='#f73625'>"..playerStats[playerName].timesDashed.."</font>\n"
    body = body.." » "..translate(playerName, "timesDoubleJumped")..": <font color='#f73625'>"..playerStats[playerName].doubleJumps.."</font>\n"
    body = body.." » "..translate(playerName, "rewindUses")..": <font color='#f73625'>"..playerStats[playerName].timesRewinded.."</font>\n"
    body = body.." » "..translate(playerName, "hardcoreMaps")..": <font color='#f73625'>"..playerStats[playerName].hardcoreMaps.."</font>\n"

    return "<font face='Verdana' size='11'>"..body.."</font>"
end

-- This generates the settings body
function remakeOptions(playerName)
    -- REMAKE OPTIONS TEXT (UPDATE YES - NO)
    local id = playerId(playerName)

    toggles = {}
    for i = 1, #playerVars[playerName].playerPreferences do
        if playerVars[playerName].playerPreferences[i] == true then
            toggles[i] = translate(playerName, "optionsYes")
        else
            toggles[i] = translate(playerName, "optionsNo")
        end
    end

    local body = " » <a href=\"event:ToggleGraffiti\">"..translate(playerName, "graffitiSetting").."?</a> "..toggles[1].."\n » <a href=\"event:ToggleDashPart\">"..translate(playerName, "particlesSetting").."?</a> "..toggles[2].."\n » <a href=\"event:ToggleTimePanels\">"..translate(playerName, "timePanelsSetting").."?</a> "..toggles[3]
    body = body.."\n » <a href=\"event:ToggleGlobalChat\">"..translate(playerName, "globalChatSetting").."?</a> "..toggles[4].."\n"
    return "\n<font face='Verdana' size='11'>"..body.."</font>"
end

function clear(playerName)
    removeTextArea(13, playerName)
    removeTextArea(14, playerName)
    removeTextArea(15, playerName)
    removeTextArea(20, playerName)
    if imgs[playerName].header ~= nil then
        removeImage(imgs[playerName].header, playerName)
        imgs[playerName].header = nil
    end
    if imgs[playerName].closeBtn ~= nil then
        removeImage(imgs[playerName].closeBtn, playerName)
        imgs[playerName].closeBtn = nil
    end
    if imgs[playerName].area ~= nil then
        removeImage(imgs[playerName].area, playerName)
        imgs[playerName].area = nil
    end
    local page = playerVars[playerName].menuPage
    if page == "shop" then
        clearWelcomeImages(playerName)
    elseif string.find(page, "dashAcc") then
        clearShopPageImgsTextAreas(playerName)
    elseif page == "graffiti" then
        clearGraffitiImgs(playerName)
    elseif string.find(page, "graffitiCol") or string.find(page, "graffitiFonts") then
        clearGraffitiColTextAreas(playerName)
    end
end

-- For some textareas we have to add later than the main textarea
function lateUI(playerName)
    local page = playerVars[playerName].menuPage
    local pageNumber = tonumber(string.match(page, "%d+"))
    
    if page == "shop" then
        generateShopImgs(playerName)
    elseif string.find(page, "dashAcc") then
        createPageNumber(pageNumber, "dashAcc", playerName)
        generatedashAccImgsText(playerName, tonumber(string.match(page, "%d+")))
    elseif page == "graffiti" then
        generateGraffitiImages(playerName)
    elseif string.find(page, "graffitiCol") then 
        createPageNumber(pageNumber, "graffitiCol", playerName)
        generateGraffitiShopText(playerName, tonumber(string.match(page, "%d+")), "graffitiCol")
    elseif string.find(page, "graffitiFonts") then
        createPageNumber(pageNumber, "graffitiFonts", playerName)
        generateGraffitiShopText(playerName, tonumber(string.match(page, "%d+")), "graffitiFonts")
    end
end

function createPageNumber(pageNumber, type, playerName)
    addTextArea(20, "<p align='center'><a href='event:PrevPage'>&lt;</a> "..pageNumber.."/"..maxShopPages(#shop[type]).." <a href='event:NextPage'>&gt;</a>", playerName, 367, 371, 66, 17, 0x1A353A, 0x7b5a35, 1, true) 
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
    local body = "\n\n\n\n\n<font face='Verdana' size='16'><p align='center'><CS>"..translate(playerName, "yourLoadout").."</CS></p></font><font face='Lucida Console' size='16'>\n\n\n\n\n\n\n<p align='center'><a href='event:ChangePart'>["..translate(playerName, "change").."]</a><textformat>"..padding.."<textformat><a href='event:ChangeGraffiti'>["..translate(playerName, "change").."]\n</a></p>\n\n\n\n</font>"
    return body
end

function generateGraffitiWelcome(playerName)
    local wordLength = #string.utf8(translate(playerName, "change"))
    local paddingCount = 10 - (wordLength - 6)
    local padding = ""
    for i = 1, paddingCount do
        padding = padding.." "
    end
    local body = "\n\n\n\n\n<font face='Verdana' size='16'><p align='center'><CS>"..translate(playerName, "yourGraffiti").."</CS></p></font><font face='Lucida Console' size='16'>\n\n\n\n\n\n\n<p align='center'><a href='event:GraffitiChangeColor'>["..translate(playerName, "change").."]</a><textformat>"..padding.."<textformat><a href='event:GraffitiChangeFont'>["..translate(playerName, "change").."]\n</a></p></font>\n\n\n<font face='Lucida Console' size='12'><p align='center'><a href='event:Back'>["..translate(playerName, "back").."]</a></p></font>"
    return body
end

function generateGraffitiImages(playerName)
    local colorX, colorY = 265, 155
    local fontX, fontY = 440, 155

    imgs[playerName].graffitiColor = addImage(COLOR_IMG, "&2", colorX, colorY, playerName)
    imgs[playerName].graffitiFont = addImage(FONTS_IMG, "&3", fontX, fontY, playerName)
end

function clearGraffitiImgs(playerName)
    removeImage(imgs[playerName].graffitiColor, playerName)
    removeImage(imgs[playerName].graffitiFont, playerName)

    imgs[playerName].graffitiColor = nil
    imgs[playerName].graffitiFont = nil
end

--TextAreaIds = 50, 51, 52
function generateShopPage(playerName, pageNumber, type)
    local body = "<a href='event:Back'>["..translate(playerName, "back").."]</a></p></font>"
    return body
end

function generateShopImgs(playerName)
    local id = playerId(playerName)
    local dashX, dashY = 260, 150

    if playerVars[playerName].menuPage == "shop" then
        clearWelcomeImages(playerName)
    end

    imgs[playerName].shopWelcomeDash = addImage(shop.dashAcc[playerStats[playerName].equipment[1]].imgId, "&2", dashX, dashY, playerName)

    local graffitiTextX, graffitiTextY, graffitiTextOffset = 375, 185, 1000000000
    addTextArea(id + graffitiTextOffset, "<p align='center'><font face='"..shop.graffitiFonts[playerStats[playerName].equipment[4]].imgId.."' size='16' color='"..shop.graffitiCol[playerStats[playerName].equipment[2]].imgId.."'>Test</font></p>", playerName, graffitiTextX, graffitiTextY, 230, 25, 0x324650, 0x000000, 0, true)
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
        if currentShopItem ~= nil and currentShopItem.reqs[2] == nil then
            reqs = translate(playerName, currentShopItem.reqs[1])
        elseif currentShopItem ~= nil then
            reqs = translate(playerName, currentShopItem.reqs[1], currentShopItem.reqs[2])
        end
        if currentShopItem == nil then
            imgs[playerName]["dashAcc"..i] = addImage(FORBIDDEN, "&"..i, imgBgX - 1, y[i] - 1, playerName)
            imgs[playerName]["status"..i] = addImage(LOCK, "&"..i, imgBgX + statusOffset, y[i] + statusOffset, playerName)
            addTextArea(ids[i], "<i><CS>"..translate(playerName, "comingSoon").."</CS></i>", playerName, x, y[i], 315, 33, 0x0a1517, 0x122529, 1, true)
        elseif currentShopItem.fnc(playerName) == false then
            --imgs[playerName]["dashAcc"..i] = addImage(HIDDEN_DASH, "&"..i, imgBgX - 50, y[i] - 50, playerName)
            imgs[playerName]["status"..i] = addImage(LOCK, "&"..i, imgBgX + statusOffset, y[i] + statusOffset, playerName)
            addTextArea(ids[i], "<font size='12'><CS><i>"..translate(playerName, currentShopItem.tooltip).."</i></CS></font>\n"..reqs, playerName, x, y[i], 315, 33, 0x0a1517, 0x122529, 1, true)
        else
            --imgs[playerName]["dashAcc"..i] = addImage(currentShopItem.imgId, "&"..i, imgBgX- 50, y[i]- 50, playerName)
            local selectState = "<a href='event:Select"..sortedOrder[(pageNumber - 1) * 5 + i].."'>"..translate(playerName, currentShopItem.tooltip).."</a>"
            if playerStats[playerName].equipment[1] == sortedOrder[(pageNumber - 1) * 5 + i] then
                selectState = "<b>"..translate(playerName, currentShopItem.tooltip).."</b>"
                imgs[playerName]["status"..i] = addImage(SELECTED, "&"..i, imgBgX + statusOffset, y[i] + statusOffset, playerName)
            end
            addTextArea(ids[i], "<font size='12'><i><CS>"..selectState.."</CS></i></font>\n"..reqs, playerName, x, y[i], 315, 33, 0x0a1517, 0x122529, 1, true)
        end
        addTextArea(ids[i] + 20, "", playerName, imgBgX, y[i] - 3, 40, 40, 0x264E57, 0x264E57, 1, true)
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
        if currentShopItem ~= nil and currentShopItem.reqs[2] == nil then
            reqs = translate(playerName, currentShopItem.reqs[1])
        elseif currentShopItem ~= nil then
            reqs = translate(playerName, currentShopItem.reqs[1], currentShopItem.reqs[2])
        end

        if currentShopItem == nil then
            imgs[playerName]["dashAcc"..i] = addImage(FORBIDDEN, "&"..i, imgBgX - 1, y[i] - 1, playerName)
            imgs[playerName]["status"..i] = addImage(LOCK, "&"..i, imgBgX + statusOffset, y[i] + statusOffset, playerName)
            addTextArea(ids[i] + 20, "", playerName, imgBgX, y[i] - 3, 40, 40, 0x264E57, 0x264E57, 1, true)
            addTextArea(ids[i], "<i><CS>"..translate(playerName, "comingSoon").."</CS></i>", playerName, x, y[i], 315, 33, 0x0a1517, 0x122529, 1, true)
        elseif currentShopItem.fnc(playerName) == false then
            addTextArea(ids[i], "<font size='12'><CS><i>"..translate(playerName, currentShopItem.tooltip).."</i></CS></font>\n"..reqs, playerName, x, y[i], 315, 33, 0x0a1517, 0x122529, 1, true)
            imgs[playerName]["status"..i] = addImage(LOCK, "&"..i, imgBgX + statusOffset, y[i] + statusOffset, playerName)
            if type == "graffitiCol" then
                addTextArea(ids[i] + 20, "", playerName, imgBgX, y[i] - 3, 40, 40, shop.graffitiCol[sortedOrder[(pageNumber - 1) * 5 + i]].values, shop.graffitiCol[sortedOrder[(pageNumber - 1) * 5 + i]].values, 1, true)
            elseif type == "graffitiFonts" then
                addTextArea(ids[i] + 20, "<p align='center'><font face='"..shop.graffitiFonts[sortedOrder[(pageNumber - 1) * 5 + i]].imgId.."' size='12' color='"..shop.graffitiCol[playerStats[playerName].equipment[2]].values.."'>Test</font></p>", playerName, imgBgX, y[i] - 3, 40, 40, 0x264E57, 0x264E57, 1, true)
                --addTextArea(colIds[i], "<p align='center'><font face='"..shop.graffitiFonts[sortedOrder[(pageNumber - 1) * 5 + i]].imgId.."' size='11' color='"..shop.graffitiCol[playerStats[playerName].equipment[2]].values.."'>Test</font></p>", playerName, xText[i], 123, 230, 50, 0x324650, 0x000000, 0, true) 
            end
        else
            --imgs[playerName]["dashAcc"..i] = addImage(shop.graffitiCol[sortedOrder[(pageNumber - 1) * 5 + i]].imgId, "&"..i, y[i], 80, playerName)
            local selectState = "<a href='event:Select"..sortedOrder[(pageNumber - 1) * 5 + i].."'>"..translate(playerName, currentShopItem.tooltip).."</a>"
            local index = 2
            if type == "graffitiFonts" then
                index = 4
            end
            if playerStats[playerName].equipment[index] == sortedOrder[(pageNumber - 1) * 5 + i] then
                selectState = "<b>"..translate(playerName, currentShopItem.tooltip).."</b>"
                imgs[playerName]["status"..i] = addImage(SELECTED, "&"..i, imgBgX + statusOffset, y[i] + statusOffset, playerName)
            end
            if type == "graffitiCol" then
                addTextArea(ids[i] + 20, "", playerName, imgBgX, y[i] - 3, 40, 40, shop.graffitiCol[sortedOrder[(pageNumber - 1) * 5 + i]].values, shop.graffitiCol[sortedOrder[(pageNumber - 1) * 5 + i]].values, 1, true)
            elseif type == "graffitiFonts" then
                addTextArea(ids[i] + 20, "<p align='center'><font face='"..shop.graffitiFonts[sortedOrder[(pageNumber - 1) * 5 + i]].imgId.."' size='12' color='"..shop.graffitiCol[playerStats[playerName].equipment[2]].values.."'>Test</font></p>", playerName, imgBgX, y[i] - 3, 40, 40, 0x264E57, 0x264E57, 1, true)
                --addTextArea(colIds[i], , playerName, xText[i], 123, 230, 50, 0x324650, 0x000000, 0, true) 
            end
            addTextArea(ids[i], "<font size='12'><i><CS>"..selectState.."</CS></i></font>\n"..reqs, playerName, x, y[i], 315, 33, 0x0a1517, 0x122529, 1, true)
        end
    end
end

function clearShopPageImgsTextAreas(playerName)
    local ids = {50, 51, 52, 53, 54}
    for i = 1, 5 do
        removeTextArea(ids[i], playerName)
        removeTextArea(ids[i] + 20, playerName)
        removeImage(imgs[playerName]["dashAcc"..i], playerName)
        removeImage(imgs[playerName]["status"..i], playerName)
        imgs[playerName]["dashAcc"..i] = nil
        imgs[playerName]["dashAcc"..i] = nil
    end
end

function clearGraffitiColTextAreas(playerName)
    local ids = {50, 51, 52, 53, 54}
    for i = 1, 5 do
        removeTextArea(ids[i], playerName)
        removeTextArea(ids[i] + 10, playerName)
        removeTextArea(ids[i] + 20, playerName)
        removeImage(imgs[playerName]["status"..i], playerName)
        removeImage(imgs[playerName]["dashAcc"..i], playerName)
        imgs[playerName]["status"..i] = nil
        imgs[playerName]["dashAcc"..i] = nil
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
            openPage(translate(playerName, "leaderboardsTitle"), "\n<font face='Verdana' size='11'>"..translate(playerName, "leaderboardsNotice").."</font>", playerName, "leaderboards")
        elseif eventName == "SettingsOpen" then
            openPage(translate(playerName, "settingsTitle"), remakeOptions(playerName), playerName, "settings")
        elseif eventName == "AboutOpen" then
            openPage(translate(playerName, "aboutTitle"), "\n<font face='Verdana' size='11'>"..translate(playerName, "aboutBody").."\n\n\n\n\n\n<p align='right'><CS>"..translate(playerName, "translator").."\n</CS><V>"..translate(playerName, "version", VERSION).."</V></p></font>", playerName, "about")
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