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
    if bestPlayers[1][1] ~= "N/A" and tfm.get.room.uniquePlayers > 2 then
        checkUnlock(bestPlayers[1][1], "dashAcc", 3, "particleUnlock")
        playerStats[room.playerList[bestPlayers[1][1]].playerName].mapsFinishedFirst = playerStats[room.playerList[bestPlayers[1][1]].playerName].mapsFinishedFirst + 1
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

    return "<font face='Verdana' size='11'>"..body.."</font>"
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
        profileName = pageId:match("@(%w+#%d+)")
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