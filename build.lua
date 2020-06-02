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

-- addImage = function() end
-- removeImage = function() end

translations = {
    {"RO",
    "<p align='center'>^\n^</p>",
    "<p align='center'>\n>></p>",
    "<p align='center'><b>Cum să joci ninjaMouse!</b></p>\nTermină harta <b>cât mai rapid posibil</b> folosindu-ți puterile de ninja!\nPentru a folosi puterile, <b>apasă de două ori pe săgeți</b> în orice direcție (stânga, dreapta, sus) și vei face un dash în acea direcție (în afară de jos).\nAi un timp de reîncărcare de 1 secundă la dash-urile pentru stânga și dreapta și un timp de reîncărcare de 3 secunde la dash-ul pentru sus (le poți vedea în colțul ecranului).\nDe asemenea, când apeși pe <b>Spațiu</b> vei fi teleportat înapoi în timp, unde erai acum 3 secunde.\nDacă ai terminat harta, numele tău va avea această <b><font color='#BABD2F'>culoare</font></b>. Dacă ai terminat harta cel mai rapid, numele tău va avea această <b><font color='#EB1D51'>culoare</font></b>.\nDacă vei vrea să recitești asta, apasă <b>H</b>.\nPentru a accesa setările, apasă <b>G</b>.",
    "<font color='#E68D43'><B>Instrucțiuni: </B></font><font color='#EDCC8D'>Dash/Sari - apasă de două ori orice săgeată. Poți da dash la fiecare 1s și sări la fiecare 3s.\nApasă H pentru mai multe detalii. Modul codat de </font><font color='#2E72CB'>Extremq#0000</font><font color='#EDCC8D'>, mape făcute de </font><font color='#2E72CB'>Railysse#0000.</font>",
	"Ultimul timp",
	"Cel mai bun timp",
	"CEL MAI RAPID NINJA",
	"Nimeni nu a terminat harta încă.",
	"<p align='center'>Apasă <b>H</b> pentru ajutor.</p>",
    "<p align='center'>\nR</p>",
    "<font color='#53ba58'>Da</font>", -- 12
    "<font color='#ba5353'>Nu</font>",  -- 13
	"Setare de testare", -- 14
	"Activezi particulele de dash", -- 15
    "Activezi panourile de timp", -- 16
    "Opțiuni", -- 17
    " a inițiat un vot pentru a trece la următoarea mapă. Scrie !yes pentru a vota pozitiv.", -- 18
    " a terminat harta cel mai rapid!", --19
    "<font color='#CB546B'>Acest modul este în construcție. Raportează orice problemă lui Extremq#0000 sau Railysse#0000.</font>", -- 20
    "Bine ai venit pe <font color='#E68D43'>#ninja</font>! Apasă <font color='#E68D43'>H</font> pentru ajutor.", -- 21
    "Ai terminat harta! Timp: ", --22
    "Trebuie să aduci brânza înapoi la gaură cât mai repede poți.\n\n<b>Abilități</b>:\n» Dash - Apasă <b><font color='#CB546B'>săgeată Stânga</font></b> sau <b><font color='#CB546B'>Dreapta</font></b> de două ori. (reîncărcare 1s)\n» Jump - Apasă <b><font color='#CB546B'>săgeată Sus</font></b> de două ori. (reîncărcare 3s)\n» Rewind - Apasă <b><font color='#CB546B'>Spațiu</font></b> pentru a lăsa un checkpoint. Apasă <b><font color='#CB546B'>Spațiu</font></b> din nou în maximum 3 secunde pentru a te teleporta înapoi la checkpoint. (reîncărcare 10s)\n\n<b>Alte scurtături</b>:\n» Deschide meniul - Apasă <b><font color='#CB546B'>M</font></b> sau dă click în partea stângă a ecranului pentru a închide/deschide meniul.\n» Pune un graffiti - Apasă <b><font color='#CB546B'>C</font></b> pentru a lăsa un graffiti. (reîncărcare 60s\n» Omoară șoricelul - Apasă <b><font color='#CB546B'>X</font></b> sau scrie /mort pentru a omorî șoarecele.\n» Deschide instrucțiunile - Apasă <b><font color='#CB546B'>H</font></b> pentru a deschide/închide acest ecran.\n\n<b>Comenzi</b>:\n» !p Nume#id - Verifică statisticile altui player.\n» !pw Parolă - Pune parolă pe sală. (sala trebuie făcută de tine)\n» !m @cod - Încarcă ce hartă vrei tu. (trebuie ca sala să aibă parolă)\n\n<p align='center'><a href='event:CloseMenu'><b><font color='#CB546B'>Închide</font></b></a></p>", --23
    "X", -- 24
    "Magazin", -- 25
    "Profil", -- 26
    "Clasamente", -- 27
    "Configurare", -- 28
    "Despre", -- 29
    "Modul codat de <font color='#FFD991'>Extremq#0000</font>.\nIdei de joc, bug-testing și hărți asigurate de <font color='#FFD991'>Railysse#0000</font>.\n\nAcest modul este susținut în întregime de fundația șoricească „Brânza Roșie” în cadrul proiectului „Salvați Module”. Toate fondurile pe care le primim vor fi donate șoarecilor care stau pe #parkour cu scopul de a-i mitui să vină aici.\n\nGlumim, mulțumim că ne-ai încercat jocul! :D\n\n<p align='center'><font color='#EB1D51'>&lt;3</font></p>", -- 30
    "First-uri",
    "Hărți terminate",
    "Rata first-urilor",
    "Intrări în gaură",
    "Utilizări graffiti",
    "Dash-uri folosite",
    "Rewind-uri folosite"
    },
    {"EN",
    "<p align='center'>^\n^</p>",
	 "<p align='center'>\n>></p>",
	 "<p align='center'><b>How to play ninjaMouse!</b></p>\nFinish the map <b>as fast as possible</b> by using your ninja powers!\nTo use the powers, <b>double-tap the arrow keys</b> in any direction (left, right, up) and you will dash in the desired direction (except for down).\nYou have a 1 second cooldown on left and right dashes and a 3 second cooldown on up dashes (you can see them in the corner of your screen).\nAlso, if you press on <b>Space</b> you will be teleported back in time where you were 3 seconds ago.\nIf you finished the map, your name will have this <b><font color='#BABD2F'>color</font></b>. If you finished with the fastest time, your name will be this <b><font color='#EB1D51'>color</font></b>.\nIf you want to read this again at any time, press <b>H</b>.\nTo access the settings, press <b>G</b>.",
     "<font color='#E68D43'><B>Instructions: </B></font><font color='#EDCC8D'>Dash/Jump - double tap any arrow keys. Cooldown on dash is 1s and on jump is 3s.\nPress H for more details. Module coded by </font><font color='#2E72CB'>Extremq#0000</font><font color='#EDCC8D'>, maps made by </font><font color='#2E72CB'>Railysse#0000.</font>",
	 "Your last time",
	 "Your best time",
	 "FASTEST NINJA",
	 "Nobody finished the map yet.",
	 "<p align='center'>Press <b>H</b> for help.</p>",
	 "<p align='center'>\nR</p>",
	 "<font color='#53ba58'>Yes</font>", --12
	 "<font color='#ba5353'>No</font>",   --13
	"Dummy setting", --14
	"Enable dash/jump particles", --15
    "Enable time panels", --16
    "Options", --17
    " started a vote to skip the current map. Type !yes to vote positively.", --18
    " finished the map in the fastest time!", --19
    "<font color='#CB546B'>This module is in development. Please report any bugs to Extremq#0000 or Railysse#0000.</font>", -- 20
    "Welcome to <font color='#E68D43'>#ninja</font>! Press <font color='#E68D43'>H</font> for help.", -- 21
    "You finished the time! Time: ", --22
    "You have to bring the cheese back to the hole as fast as you can.\n\n<b>Abilities</b>:\n» Dash - Press <b><font color='#CB546B'>Left</font></b> or <b><font color='#CB546B'>Right Arrows</font></b> twice. (1s cooldown)\n» Jump - Press <b><font color='#CB546B'>Up Arrow</font></b> twice. (3s cooldown)\n» Rewind - Press <b><font color='#CB546B'>Space</font></b> to leave a checkpoint. Press <b><font color='#CB546B'>Space</font></b> again within 3 seconds to teleport back to the checkpoint. (10s cooldown)\n\n<b>Other shortcuts</b>:\n» Kill the mouse - Press <b><font color='#CB546B'>X</font></b> or write /mort to kill the mouse.\n» Open menu - Press <b><font color='#CB546B'>M</font></b> or click in the left side of your screen to open/close the menu.\n» Place a graffiti - Press <b><font color='#CB546B'>C</font></b> to leave a graffiti. (60s cooldown)\n» Open help - Press <b><font color='#CB546B'>H</font></b> to open/close this screen.\n\n<b>Comenzi</b>:\n» !p Name#id - Check the stats of another player.\n» !pw Password - Place a password on the room. (the room must be made by you)\n» !m @code - Load any map you want. (the room must have a password)\n\n<p align='center'><a href='event:CloseMenu'><b><font color='#CB546B'>Close</font></b></a></p>", --23
    "X", -- 24
    "Shop", -- 25
    "Profile", -- 26
    "Leaderboards", -- 27
    "Settings", -- 28
    "About", -- 29
    "Module coded by <font color='#FFD991'>Extremq#0000</font>.\nGamplay ideas, bug-testing and maps provided by <font color='#FFD991'>Railysse#0000</font>.\n\nThis module is fully supported by the mice fundation „Red Cheese” with the „Save Module” project. All funds that we will earn will be donated to mice which play #parkour so we can bribe them to play our module.\n\nWe're just kidding, thank you for trying our module! :D\n\n<p align='center'><font color='#EB1D51'>&lt;3</font></p>", -- 30
    "Firsts", -- 31
    "Finished maps", -- 32
    "First rate", -- 33
    "Times entered the hole", -- 34
    "Graffiti uses", --3 5
    "Times dashed", -- 36
    "Times rewinded" --37
    }
}

mapcodes = {"@7725753", "@7726015", "@7726744", "@7728063", "@7731641", "@7730637", "@7732486"}
mapsleft = {"@7725753", "@7726015", "@7726744", "@7728063", "@7731641", "@7730637", "@7732486"}
-- mapcodes = {"@7732115"}
-- mapsleft = {"@7732115"}

currentspawnpos = {0, 0}
modlist = {"Extremq#0000", "Railysse#0000", "Melibellule#0001"}
modroom = {}
oplist = {}
lastmap = ""
lastmaparr = {"", ""}
mapwasskipped = false
mapstarttime = 0

--CONSTANTS
MAPTIME = 5 * 60
STATSTIME = 10 * 1000
DASHCOOLDOWN = 1 * 1000
JUMPCOOLDOWN = 3 * 1000
REWINDCOOLDONW = 10 * 1000
GRAFFITICOOLDOWN = 60 * 1000
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

-- CHOOSE MAP
function randomMap()  
    -- DELETE THE CHOSEN MAP
    if #mapsleft == 0 then
        for key, value in pairs(mapcodes) do
            table.insert(mapsleft, value)
        end
    end
    local pos = random(1, #mapsleft)
    local newMap = mapsleft[pos]
    -- IF THE MAPS ARE THE SAME, PICK AGAIN
    if newMap == lastmap then
        table.remove(mapsleft, pos)
        pos = random(1, #mapsleft)
        newMap = mapsleft[pos]
        table.insert(mapsleft, lastmap)
    end
    table.remove(mapsleft, pos)
    currentspawnpos = {0, 0}
    lastmap = newMap
    return newMap
end

-- CHOOSE FLIP
function randomFlip()
    local number = random()
    mapstarttime = os.time()
    if number < 0.5 then
        return true
    else
        return false
    end
end

tfm.exec.disableAutoTimeLeft(true)
tfm.exec.disableAutoScore(true)
tfm.exec.disableAutoShaman(true)
tfm.exec.disableAfkDeath(true)
tfm.exec.disableAutoNewGame(true)
tfm.exec.setAutoMapFlipMode(randomFlip())
tfm.exec.newGame(randomMap())
tfm.exec.disablePhysicalConsumables(true)
system.disableChatCommandDisplay()
tfm.exec.setGameTime(MAPTIME, true)

keys = {32, 37, 39, 38, 65, 67, 68, 71, 72, 77, 84, 87, 88}
besttime = 99999

playerStats = {
    -- {
    --     mapsFinished = 0,
    --     mapsFinishedFirst = 0,
    --     timesEnteredInHole = 0,
    --     graffitiSprays = 0,
    --     timesDashed = 0,
    --     timesRewinded = 0
    -- }
}

-- TIME
globalplayercount = 0
lastkeypressed = {}
lastkeypressedtime = {}
lastdashusedtime = {}
lastjumpusedtime = {}
lastkeypressedtimeleft = {}
lastkeypressedtimeright = {}
lastkeypressedtimejump = {}
lastrewindused = {}
lastgraffititime = {}
canrewind = {}
rewindpos = {}
jumpbtnid = {}
dashbtnid = {}
rewindbtnid = {}
helpimgid = {}
mouseimgid = {}
checkpointtime = {}
jumpstate = {}
dashstate = {}
rewindstate = {}
menuimgid = {}
helpopen = {}
menupage = {}
-- SCORE OF PLAYER
fastestplayer = -1
playerbesttime = {}
playerSortedBestTime = {}
playerlasttime = {}
playerlanguage = {}
playerpreferences = {}
playerloaded = {}
playerwelcome = {}
-- TRUE/FALSE
playerfinished = {}
playerCount = 0
playerWon = 0
globalid = 0
mapfinished = fals
admin = ""
customroom = false
hasShownStats = false

function checkMod(playerName)
    for index, name in pairs(modlist) do
        if name == playerName then
            return true
        end
    end
    return false
end

function checkRoomMod(playerName)
    for index, name in pairs(modroom) do
        if name == playerName then
            return true
        end
    end
    return false
end

-- MOUSE POWERS
function eventKeyboard(playerName, keyCode, down, xPlayerPosition, yPlayerPosition)
    local id = room.playerList[playerName].id
    if id == 0 then
        return
    end
    local ostime = os.time()
    if playerloaded[id] == false then
        return
    end
    -- DOUBLE PRESS --
    if ostime - lastdashusedtime[id] > DASHCOOLDOWN then
        dashUsed = false
        if ostime - lastkeypressedtimeright[id] < 200 and room.playerList[playerName].isDead == false then
            -- DASHES textarea = 2--
            if keyCode == 39 or keyCode == 68  then
                lastkeypressedtimeright[id] = ostime
                --if lastkeypressed[id] == keyCode then
                --displayParticle(35, xPlayerPosition + 60, yPlayerPosition, 0, 0, 0, 0, nil)
                for name, data in pairs(room.playerList) do
                    if room.playerList[name].id ~= 0 and playerpreferences[room.playerList[name].id][2] == true then
                        displayParticle(3, xPlayerPosition, yPlayerPosition, random(), random(), 0, 0, name)
                        displayParticle(3, xPlayerPosition, yPlayerPosition, random(), -random(), 0, 0, name)
                        displayParticle(3, xPlayerPosition, yPlayerPosition, random(), -random(), 0, 0, name)
                        displayParticle(3, xPlayerPosition, yPlayerPosition, random(), -random(), 0, 0, name)
                    end
                end
                movePlayer(playerName, 0, 0, true, 150, 0, false)
                dashUsed = true;
                --end
            end
        end
        if ostime - lastkeypressedtimeleft[id] < 200 and room.playerList[playerName].isDead == false then
            if keyCode == 37 or keyCode == 65 then
                lastkeypressedtimeleft[id] = ostime
                for name, data in pairs(room.playerList) do
                    if room.playerList[name].id ~= 0 and playerpreferences[room.playerList[name].id][2] == true then
                        displayParticle(3, xPlayerPosition, yPlayerPosition, -random(), random(), 0, 0, name)
                        displayParticle(3, xPlayerPosition, yPlayerPosition, -random(), -random(), 0, 0, name)
                        displayParticle(3, xPlayerPosition, yPlayerPosition, -random(), -random(), 0, 0, name)
                        displayParticle(3, xPlayerPosition, yPlayerPosition, -random(), -random(), 0, 0, name)
                    end
                end
                movePlayer(playerName, 0, 0, true, -150, 0, false)
                dashUsed = true;
            end
        end

        if dashUsed == true then
            lastdashusedtime[id] = ostime
            dashstate[id] = false
            -- removeTextArea(2, playerName)
            -- addTextArea(2, "<font size='14' align='center' color='#000000'><b>"..translations[playerlanguage[id]][3].."</font>", playerName, DASH_BTN_X, DASH_BTN_Y, 50, 50, 0xff5151, 0xaf3131, 0.8, true)
            removeImage(dashbtnid[id])
            dashbtnid[id] = addImage(DASH_BTN_OFF, "&1", DASH_BTN_X, DASH_BTN_Y, playerName)
            playerStats[id].timesDashed = playerStats[id].timesDashed + 1
        end
    end
    if ostime - lastkeypressedtimejump[id] < 200 and room.playerList[playerName].isDead == false then
        -- JUMP textarea = 1--
        if (keyCode == 38 or keyCode == 87) and ostime - lastjumpusedtime[id] > JUMPCOOLDOWN then
            lastkeypressedtimejump[id] = ostime
            --if lastkeypressed[id] == keyCode then
            movePlayer(playerName, 0, 0, true, 0, -60, false)
            for name, data in pairs(room.playerList) do
                if room.playerList[name].id ~= 0 and playerpreferences[room.playerList[name].id][2] == true then
                    displayParticle(3, xPlayerPosition, yPlayerPosition, random(), -random()*4, 0, 0, name)
                    displayParticle(3, xPlayerPosition, yPlayerPosition, -random(), -random()*3, 0, 0, name)
                    displayParticle(3, xPlayerPosition, yPlayerPosition, -random(), -random()*2, 0, 0, name)
                    displayParticle(3, xPlayerPosition, yPlayerPosition, random(), -random()*2, 0, 0, name)
                end
            end
            jumpstate[id] = false
            lastjumpusedtime[id] = ostime
            -- removeTextArea(1, playerName)
            -- addTextArea(1, "<font size='14' align='center' color='#000000'><b>"..translations[playerlanguage[id]][2].."</font>", playerName, JUMP_BTN_X, JUMP_BTN_Y, 50, 50, 0xff5151, 0xaf3131, 0.8, true)
            removeImage(jumpbtnid[id])
            jumpbtnid[id] = addImage(JUMP_BTN_OFF, "&1", JUMP_BTN_X, JUMP_BTN_Y, playerName)
            --end
        end
    end

    if keyCode == 32 then
        if canrewind[id] == true then
            movePlayer(playerName, rewindpos[id][1], rewindpos[id][2], false, 0, 0, false)
            lastrewindused[id] = ostime
            canrewind[id] = false

            removeImage(rewindbtnid[id])
            rewindbtnid[id] = addImage(REWIND_BTN_ACTIVE, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)

            -- removeTextArea(7, playerName)
            -- addTextArea(7, "<font size='14' align='center' color='#000000'><b>"..translations[playerlanguage[id]][11].."</font>", playerName, REWIND_BTN_X, REWIND_BTN_Y, 50, 50, 0xff5151, 0xaf3131, 0.8, true)
            removeImage(mouseimgid[id])

            displayParticle(36, xPlayerPosition, yPlayerPosition, 0, 0, 0, 0, nil)
            displayParticle(2, xPlayerPosition, xPlayerPosition, -random(), random(), 0, 0, playerName)
            displayParticle(2, xPlayerPosition, xPlayerPosition, -random(), -random(), 0, 0, playerName)
            displayParticle(2, xPlayerPosition, xPlayerPosition, -random(), -random(), 0, 0, playerName)
            displayParticle(2, xPlayerPosition, xPlayerPosition, random(), -random(), 0, 0, playerName)
            if rewindpos[id][3] == false then
                tfm.exec.removeCheese(playerName)
            end

            playerStats[id].timesRewinded = playerStats[id].timesRewinded + 1

        elseif ostime - lastrewindused[id] > REWINDCOOLDONW and room.playerList[playerName].isDead == false then
            canrewind[id] = true
            checkpointtime[id] = ostime
            rewindpos[id] = {xPlayerPosition, yPlayerPosition, room.playerList[playerName].hasCheese}

            mouseimgid[id] = addImage(CHECKPOINT_MOUSE, "_100", xPlayerPosition - 59/2, yPlayerPosition - 73/2, playerName)       
            removeImage(rewindbtnid[id])
            rewindbtnid[id] = addImage(REWIND_BTN_OFF, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)

            -- removeTextArea(7, playerName)
            -- addTextArea(7, "<font size='14' align='center' color='#000000'><b>"..translations[playerlanguage[id]][11].."</font>", playerName, REWIND_BTN_X, REWIND_BTN_Y, 50, 50, 0x808700, 0xfbff14, 0.8, true)
            
            displayParticle(2, rewindpos[id][1], rewindpos[id][2], -random(), random(), 0, 0, playerName)
            displayParticle(2, rewindpos[id][1], rewindpos[id][2], -random(), -random(), 0, 0, playerName)
            displayParticle(2, rewindpos[id][1], rewindpos[id][2], -random(), -random(), 0, 0, playerName)
            displayParticle(2, rewindpos[id][1], rewindpos[id][2], random(), -random(), 0, 0, playerName)
        end
    end 
    -- OPEN GUIDE / HELP
    if keyCode == 72 then
        if helpopen[id] == false then
            if menupage[id] ~= 0 then
                menupage[id] = "help"
                updatePage("#ninja", translations[playerlanguage[id]][23], playerName)
            else
                createPage("#ninja", translations[playerlanguage[id]][23], playerName)
            end
            helpopen[id] = true 
        elseif helpopen[id] == true then
            closePage(playerName)
            helpopen[id] = false 
            menupage[id] = 0
        end
    end

    -- MORT ON X
    if keyCode == 88 then
        killPlayer(playerName)
    end

    -- MENU
    if keyCode == 77 then
        if menuimgid[id] == -1 then
            addTextArea(12, "<font color='#E9E9E9' size='10'><a href='event:ShopOpen'>             "..translations[playerlanguage[id]][25].."</a>\n\n\n\n<a href='event:StatsOpen'>             "..translations[playerlanguage[id]][26].."</a>\n\n\n\n<a href='event:LeaderOpen'>             "..translations[playerlanguage[id]][27].."</a>\n\n\n\n<a href='event:SettingsOpen'>             "..translations[playerlanguage[id]][28].."</a>\n\n\n\n<a href='event:AboutOpen'>             "..translations[playerlanguage[id]][29].."</a>", playerName, 13, 103, 184, 220, 0x324650, 0x000000, 0, true)
            menuimgid[id] = addImage(MENU_BUTTONS, ":10", MENU_BTN_X, MENU_BTN_Y, playerName)
        else
            closePage(playerName)
        end
    end

    -- GRAFFITI
    if keyCode == 67 and ostime - lastgraffititime[id] > GRAFFITICOOLDOWN  then
        lastgraffititime[id] = ostime
        removeTextArea(id, nil)
        playerStats[id].graffitiSprays = playerStats[id].graffitiSprays + 1
        addTextArea(id, "<p align='center'><font face='Comic Sans MS' size='16' color='#ffffff'>"..playerName, nil, xPlayerPosition - 300/2, yPlayerPosition - 25/2, 300, 25, 0x324650, 0x000000, 0, false)   
    end

    lastkeypressedtime[id] = ostime
    if keyCode == 39 or keyCode == 68  then
        lastkeypressedtimeright[id] = ostime
    end

    if keyCode == 37 or keyCode == 65 then
        lastkeypressedtimeleft[id] = ostime
    end

    if keyCode == 38 or keyCode == 87 then
        lastkeypressedtimejump[id] = ostime
    end
end

-- UPDATE REWIND ARRAY
function eventPlayerDied(playerName)
    local id = room.playerList[playerName].id
    rewindpos[id] = {{0, 0, false}, {0, 0, false}, {0, 0, false}, {0, 0, false}, {0, 0, false}, {0, 0, false}}
    if mouseimgid[id] ~= nil then
        removeImage(mouseimgid[id])
    end
end

-- UPDATE MAP NAME
function updateMapName(timeRemaining)
    -- in case it hasn't loaded for some reason
    if MAPTIME * 1000 - timeRemaining < 3000 then
        return
    end

    local floor = math.floor
    local currentmapauthor = ""
    local currentmapcode = ""
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

    if minutes == nil then
        minutes = "?"
    end

    if seconds == nil then
        minutes = "?"
    end

    if currentmapauthor == nil then
        currentmapauthor = "?"
    end

    if currentmapcode == nil then
        currentmapcode = "?"
    end

    if playerCount == nil then
        playerCount = 0
        for name, index in pairs(room.playerList) do
            if name[1] ~= '*' then
                playerCount = playerCount + 1
            end
        end
    end

    print(currentmapcode.." "..currentmapauthor.." "..playerCount.." "..minutes.." "..seconds)

    local name = currentmapauthor.." <G>-</G><N> "..currentmapcode.."</N> <G>|<G> <N>Mice:</N> <J>"..playerCount.."</J> <G>|<G> <N>"..minutes..":"..seconds.."</N>"
    -- APPEND FASTEST
    if fastestplayer ~= -1 then
        local record = (besttime / 100)
        name = name.." <G>|<G> <N2>Record: </N2><R>"..fastestplayer.." - "..record.."s</R>"
    end

    if timeRemaining < 0 then
        name = "STATISTICS TIME!" 
    end 

    name = name.."<"
    setMapName(name)
end

function compare(a,b)
    return a[2] < b[2]
end

function showStats()
    bestPlayers = {{"N/A", "N/A"}, {"N/A", "N/A"}, {"N/A", "N/A"}}
    table.sort(playerSortedBestTime, compare)
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
    for name, index in pairs(room.playerList) do
        if menupage[id] == 0 then
            createPage(translations[playerlanguage[id]][27], message, name)
        else
            updatePage(translations[playerlanguage[id]][27], message, name)
        end
    end
    if bestPlayers[1][1] ~= "N/A" then
        playerStats[room.playerList[bestPlayers[1][1]].id].mapsFinishedFirst = playerStats[room.playerList[bestPlayers[1][1]].id].mapsFinishedFirst + 1
    end
end

-- UI UPDATER & PLAYER RESPAWNER & REWINDER
function eventLoop(elapsedTime, timeRemaining)
    local ostime = os.time()

    updateMapName(MAPTIME * 1000 - (ostime - mapstarttime))
    --print(elapsedTime / 1000)
    
    -- WHEN TIME REACHES 0 CHOOSE ANOTHER MAP
    if (elapsedTime >= MAPTIME * 1000 and elapsedTime < MAPTIME * 1000 + STATSTIME) then
        for index, value in pairs(room.playerList) do
            killPlayer(index)
        end
        if hasShownStats == false then
            hasShownStats = true
            showStats()
        end

    elseif elapsedTime >= MAPTIME * 1000 + 5000 or mapwasskipped == true then
        mapwasskipped = false
        print("Attempting to reset.")
        tfm.exec.setAutoMapFlipMode(randomFlip())
        tfm.exec.newGame(randomMap())
        resetAll()
    else    
        for playerName in pairs(room.playerList) do
            local id = room.playerList[playerName].id
            if id ~= 0 then
                if room.playerList[playerName].isDead == true then
                    -- RESPAWN PLAYER
                    tfm.exec.respawnPlayer(playerName)
                    -- UPDATE COOLDOWNS
                    lastjumpusedtime[id] = ostime - JUMPCOOLDOWN
                    lastdashusedtime[id] = ostime - DASHCOOLDOWN
                    lastrewindused[id] = ostime - 6000
                    checkpointtime[id] = 0
                    canrewind[id] = false
                    -- WHEN RESPAWNED, MAKE THE ABILITIES GREEN
                    -- removeTextArea(1, playerName)
                    -- addTextArea(1, "<font size='14' align='center' color='#000000'><b>"..translations[playerlanguage[id]][2].."</font>", playerName, JUMP_BTN_X, JUMP_BTN_Y, 50, 50, 0x5bff5b, 0x3ebc3e, 0.8, true)
                    removeImage(jumpbtnid[id])
                    jumpbtnid[id] = addImage(JUMP_BTN_ON, "&1", JUMP_BTN_X, JUMP_BTN_Y, playerName)

                    -- removeTextArea(2, playerName)
                    -- addTextArea(2, "<font size='14' align='center' color='#000000'><b>"..translations[playerlanguage[id]][3].."</font>", playerName, DASH_BTN_X, DASH_BTN_Y, 50, 50, 0x5bff5b, 0x3ebc3e, 0.8, true)
                    removeImage(dashbtnid[id])
                    dashbtnid[id] = addImage(DASH_BTN_ON, "&1", DASH_BTN_X, DASH_BTN_Y, playerName)
                end
                -- UPDATE UI
                if jumpstate[id] == false and ostime - lastjumpusedtime[id] > JUMPCOOLDOWN then
                    jumpstate[id] = true
                    removeImage(jumpbtnid[id])
                    jumpbtnid[id] = addImage(JUMP_BTN_ON, "&1", JUMP_BTN_X, JUMP_BTN_Y, playerName)
                    -- removeTextArea(1, playerName)
                    -- addTextArea(1, "<font size='14' align='center' color='#000000'><b>"..translations[playerlanguage[id]][2].."</font>", playerName, JUMP_BTN_X, JUMP_BTN_Y, 50, 50, 0x5bff5b, 0x3ebc3e, 0.8, true)
                end
                if dashstate[id] == false and ostime - lastdashusedtime[id] > DASHCOOLDOWN then
                    dashstate[id] = true
                    removeImage(dashbtnid[id])
                    dashbtnid[id] = addImage(DASH_BTN_ON, "&1", DASH_BTN_X, DASH_BTN_Y, playerName)
                    -- removeTextArea(2, playerName)
                    -- addTextArea(2, "<font size='14' align='center' color='#000000'><b>"..translations[playerlanguage[id]][3].."</font>", playerName, DASH_BTN_X, DASH_BTN_Y, 50, 50, 0x5bff5b, 0x3ebc3e, 0.8, true)
                end

                if canrewind[id] == true and ostime - checkpointtime[id] > 3000 then
                    canrewind[id] = false
                    lastrewindused[id] = ostime
                    removeImage(mouseimgid[id])
                    displayParticle(2, rewindpos[id][1], rewindpos[id][2], -random(), random(), 0, 0, playerName)
                    displayParticle(2, rewindpos[id][1], rewindpos[id][2], -random(), -random(), 0, 0, playerName)
                    displayParticle(2, rewindpos[id][1], rewindpos[id][2], -random(), -random(), 0, 0, playerName)
                    displayParticle(2, rewindpos[id][1], rewindpos[id][2], random(), -random(), 0, 0, playerName)
                end

                if canrewind[id] == true and rewindstate[id] ~= 2 then
                    rewindstate[id] = 2
                    -- removeTextArea(7, playerName)
                    -- addTextArea(7, "<font size='14' align='center' color='#000000'><b>"..translations[playerlanguage[id]][11].."</font>", playerName, REWIND_BTN_X, REWIND_BTN_Y, 50, 50, 0x808700, 0xfbff14, 0.8, true)    
                    removeImage(rewindbtnid[id])
                    rewindbtnid[id] = addImage(REWIND_BTN_ACTIVE, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)
                elseif canrewind[id] == false and rewindstate[id] ~= 1 and ostime - lastrewindused[id] > REWINDCOOLDONW then
                    rewindstate[id] = 1
                    -- removeTextArea(7, playerName)
                    -- addTextArea(7, "<font size='14' align='center' color='#000000'><b>"..translations[playerlanguage[id]][11].."</font>", playerName, REWIND_BTN_X, REWIND_BTN_Y, 50, 50, 0x5bff5b, 0x3ebc3e, 0.8, true)
                    removeImage(rewindbtnid[id])
                    rewindbtnid[id] = addImage(REWIND_BTN_ON, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)
                elseif rewindstate[id] ~= 3 and ostime - lastrewindused[id] <= REWINDCOOLDONW then
                    rewindstate[id] = 3
                    -- removeTextArea(7, playerName)
                    -- addTextArea(7, "<font size='14' align='center' color='#000000'><b>"..translations[playerlanguage[id]][11].."</font>", playerName, REWIND_BTN_X, REWIND_BTN_Y, 50, 50, 0xff5151, 0xaf3131, 0.8, true)
                    removeImage(rewindbtnid[id])
                    rewindbtnid[id] = addImage(REWIND_BTN_OFF, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)
                end
            end
        end
    end
end

-- PLAYER COLOR SETTER
function eventPlayerRespawn(playerName)
    id = room.playerList[playerName].id
    if id == 0 then
        tfm.exec.freezePlayer(playerName)
        return
    end
    setColor(playerName)
end

function setColor(playerName)
    id = room.playerList[playerName].id
    local color = 0x40a594
    -- IF BEST TIME
    if playerName == fastestplayer then
        color = 0xEB1D51
    -- ELSEIF FINISHED
    elseif playerfinished[id] == true then
        color = 0xBABD2F
    end

    if checkRoomMod(playerName) == true then
        color = 0x2E72CB
    end

    setNameColor(playerName, color)
end

-- PLAYER WIN
function eventPlayerWon(playerName, timeElapsed, timeElapsedSinceRespawn)
    local id = room.playerList[playerName].id

    if mouseimgid[id] ~= nil then
        removeImage(mouseimgid[id])
    end

    
    lastjumpusedtime[id] = 0
    lastdashusedtime[id] = 0
    
    if checkRoomMod(playerName) == true then
        return
    end

    playerStats[id].timesEnteredInHole = playerStats[id].timesEnteredInHole + 1
    
    -- SEND CHAT MESSAGE FOR PLAYER
    chatMessage(translations[playerlanguage[id]][22]..(timeElapsedSinceRespawn/100).."s", playerName)

    if playerfinished[id] == false then
        playerStats[id].mapsFinished = playerStats[id].mapsFinished + 1
        playerWon = playerWon + 1
    end
    setPlayerScore(playerName, 1, true)
    -- RESET TIMERS
    playerlasttime[id] = timeElapsedSinceRespawn
    playerfinished[id] = true
    playerbesttime[id] = math.min(playerbesttime[id], timeElapsedSinceRespawn)
    local foundvalue = false
    for i = 1, #playerSortedBestTime do
        if playerSortedBestTime[i][1] == playerName then
            playerSortedBestTime[i][2] = playerbesttime[id]
            foundvalue = true
        end
    end
    if foundvalue == false then
        table.insert(playerSortedBestTime, {playerName, playerbesttime[id]})
    end

    -- UPDATE "YOUR TIME"
    ui.updateTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerlanguage[id]][6]..": "..(timeElapsedSinceRespawn/100).."s", playerName)
    ui.updateTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerlanguage[id]][7]..": "..(playerbesttime[id]/100).."s", playerName)
    
    if timeElapsedSinceRespawn <= besttime then
        -- CHECK IF FASTEST PLAYER IS IN ROOM
        for playerName in pairs(room.playerList) do
            if playerName == fastestplayer then
                setNameColor(fastestplayer, 0xBABD2F)
            end
        end
        besttime = timeElapsedSinceRespawn
        fastestplayer = playerName
        
        -- send message
        for index, value in pairs(room.playerList) do
            local _id = room.playerList[index].id
            local message = "<font color='#CB546B'>"..fastestplayer..translations[playerlanguage[_id]][19].." Time: "..(besttime/100).."s</font>"
            chatMessage(message, index)
            print(message)
        end
    end
end

function eventPlayerLeft(playerName)
    if playerName[1] == '*' then
        return
    end
    playerCount = playerCount - 1
end

-- RETURN PLAYER ID
function playerId(playerName)
    return room.playerList[playerName].id
end

-- CALL THIS WHEN A PLAYER FIRST JOINS A ROOM
function initPlayer(playerName)
    -- ID USED FOR PLAYER ARRAYS
    globalid = room.playerList[playerName].id

    if globalid == 0 then
        killPlayer(playerName)
        return
    end

    -- NUMBER OF THE PLAYER SINCE MAP WAS CREATED
    globalplayercount = globalplayercount + 1
    -- IF FIRST PLAYER, (NEW MAP) MAKE ADMIN
    if globalplayercount == 1 then
        admin = playerName
    end

    -- BIND MOUSE
    system.bindMouse(playerName, true)

    -- CURRENT PLAYERCOUNT
    playerCount = playerCount + 1

    -- RESET SCORE
    setPlayerScore(playerName, 0)

    -- INIT ALL PLAYER TABLES
    lastkeypressed[globalid] = 0
    lastrewindused[globalid] = 0
    lastkeypressedtime[globalid] = 0
    lastdashusedtime[globalid] = 0
    lastjumpusedtime[globalid] = 0
    lastkeypressedtimeleft[globalid] = 0
    lastkeypressedtimeright[globalid] = 0
    lastkeypressedtimejump[globalid] = 0
    if playerbesttime[globalid] == nil then
        playerbesttime[globalid] = 999999
        playerlasttime[globalid] = 999999
        playerfinished[globalid] = false
        playerStats[globalid] = 
        {
            mapsFinished = 0,
            mapsFinishedFirst = 0,
            timesEnteredInHole = 0,
            graffitiSprays = 0,
            timesDashed = 0,
            timesRewinded = 0
        }
        playerpreferences[globalid] = {false, true, false}
    else 
        local hasFound = false
        for key, value in pairs(playerSortedBestTime) do
            if value[1] == playerName then
                playerbesttime[globalid] = value[2]
                playerlasttime[globalid] = value[2]
                hasFound = true
                break
            end
        end
        if hasFound == false then
            playerbesttime[globalid] = 999999
            playerlasttime[globalid] = 999999
            playerfinished[globalid] = false
        end
    end
    playerlanguage[globalid] = 2
    playerloaded[globalid] = false
    lastgraffititime[globalid] = 0
    rewindpos[globalid] = {0, 0, false}
    canrewind[globalid] = false
    jumpstate[globalid] = true
    dashstate[globalid] = true
    rewindstate[globalid] = 1
    local jmpid = addImage(JUMP_BTN_ON, "&1", JUMP_BTN_X, JUMP_BTN_Y, playerName)
    jumpbtnid[globalid] = jmpid
    local dshid = addImage(DASH_BTN_ON, "&1", DASH_BTN_X, DASH_BTN_Y, playerName)
    dashbtnid[globalid] = dshid
    local rwdid = addImage(REWIND_BTN_ON, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)
    rewindbtnid[globalid] = rwdid
    local hlpid = addImage(HELP_IMG, ":100", 114, 23, playerName)
    helpimgid[globalid] = hlpid
    addTextArea(10, "<a href='event:CloseWelcome'><font color='transparent'>\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n <font></a>", playerName, 129, 29, 541, 342, 0x324650, 0x000000, 0, true)
    helpimgid[globalid] = hlpid
    mouseimgid[globalid] = nil
    checkpointtime[globalid] = 0
    menuimgid[globalid] = -1
    helpopen[globalid] = false
    menupage[globalid] = 0
    -- SET DEFAULT COLOR
    setColor(playerName)
    -- BIND KEYS
    for index, key in pairs(keys) do
        bindKeyboard(playerName, key, true, true)
    end
    -- AUTOMATICALLY CHOOSE LANGUAGE
    chooselang(playerName)

    -- PUT PANELS IF TURNED ON
    if playerpreferences[id][3] == true then
        playerpreferences[id][3] = true
        addTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerlanguage[id]][6]..": N/A", playerName, 10, 45, 200, 21, 0xffffff, 0x000000, 0, true)
        addTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerlanguage[id]][7]..": N/A", playerName, 10, 30, 200, 21, 0xffffff, 0x000000, 0, true)
        if playerfinished[id] == true then
            ui.updateTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerlanguage[id]][6]..": "..(playerlasttime[id]/100).."s", playerName)
            ui.updateTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerlanguage[id]][7]..": "..(playerbesttime[id]/100).."s", playerName)
        end
    end
end

function chooselang(playerName)
    local id = room.playerList[playerName].id
    local community = room.playerList[playerName].community
    -- FOR NOW, ONLY RO HAS TRANSLATIONS
    if community == "ro" then
        playerlanguage[id] = 1
    else
        playerlanguage[id] = 2 -- 2 = EN
    end
    playerloaded[id] = true
    -- GENERATE UI
    addTextArea(6, translations[playerlanguage[id]][10], playerName, 267, 382, 265, 18, 0x324650, 0x000000, 0, true)
    
    -- SEND HELP message
    chatMessage(translations[playerlanguage[id]][21].."\n"..translations[playerlanguage[id]][20], playerName)
    print(translations[playerlanguage[id]][21])
    print(translations[playerlanguage[id]][20])
end

-- WHEN SOMEBODY JOINS, INIT THE PLAYER
function eventNewPlayer(playerName)
    initPlayer(playerName)
end

-- INIT ALL EXISTING PLAYERS (NOT SURE IF WORKS)
for playerName in pairs(room.playerList) do
    initPlayer(playerName)
end

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
    local id = room.playerList[playerName].id
    local playerX = room.playerList[playerName].x 
    -- print("click at "..xMousePosition)
    if checkRoomMod(playerName) then
        movePlayer(playerName, xMousePosition, yMousePosition, false, 0, 0, false)
    else
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
            if menuimgid[id] == -1 then
                addTextArea(12, "<font color='#E9E9E9' size='10'><a href='event:ShopOpen'>             "..translations[playerlanguage[id]][25].."</a>\n\n\n\n<a href='event:StatsOpen'>             "..translations[playerlanguage[id]][26].."</a>\n\n\n\n<a href='event:LeaderOpen'>             "..translations[playerlanguage[id]][27].."</a>\n\n\n\n<a href='event:SettingsOpen'>             "..translations[playerlanguage[id]][28].."</a>\n\n\n\n<a href='event:AboutOpen'>             "..translations[playerlanguage[id]][29].."</a>", playerName, 13, 103, 184, 220, 0x324650, 0x000000, 0, true)
                menuimgid[id] = addImage(MENU_BUTTONS, ":10", MENU_BTN_X, MENU_BTN_Y, playerName)
            else
                closePage(playerName)
            end
        end
    end
end

function createPage(title, body, playerName)
    local id = room.playerList[playerName].id
    if menupage[id] ~= "help" then
        helpopen[id] = false
    end
    local closebtn = "<p align='center'><font color='#CB546B'><a href='event:CloseMenu'>"..translations[playerlanguage[id]][24].."</a></font></p>"
    
    local spaceLength = 40 - #translations[playerlanguage[id]][24] - #title
    local padding = ""
    for i = 1, spaceLength do 
        padding = padding.." "
    end
    local pagetitle = "<font size='16' face='Lucida Console'>"..title.."<textformat>"..padding.."</textformat>"..closebtn.."</font>\n"
    local pagebody = body
    ui.addTextArea(13, pagetitle..pagebody, playerName, 200, 50, 405, 300, 0x241f13, 0xbfa26d, 0.9, true)
end

function updatePage(title, body, playerName)
    local id = room.playerList[playerName].id
    if menupage[id] ~= "help" then
        helpopen[id] = false
    end
    local closebtn = "<p align='center'><font color='#CB546B'><a href='event:CloseMenu'>"..translations[playerlanguage[id]][24].."</a></font></p>"
    local spaceLength = 40 - #translations[playerlanguage[id]][24] - #title
    local padding = ""
    for i = 1, spaceLength do 
        padding = padding.." "
    end
    local pagetitle = "<font size='16' face='Lucida Console'>"..title.."<textformat>"..padding.."</textformat>"..closebtn.."</font>\n"
    local pagebody = body
    ui.updateTextArea(13, pagetitle..pagebody, playerName)
end

function closePage(playerName)
    local id = room.playerList[playerName].id
    removeTextArea(13, playerName)
    removeTextArea(12, playerName)
    removeImage(menuimgid[id])
    menupage[id] = 0
    helpopen[id] = false
    menuimgid[id] = -1
end

function stats(playerName, playerId, creatorId)
    --     mapsFinished = 0,
    --     mapsFinishedFirst = 0,
    --     timesEnteredInHole = 0,
    --     graffitiSprays = 0,
    --     timesDashed = 0,
    --     timesRewinded = 0
    local body = "\n"
    
    body = body.." » "..translations[playerlanguage[creatorId]][31]..": <R>"..playerStats[playerId].mapsFinishedFirst.."</R>\n"
    body = body.." » "..translations[playerlanguage[creatorId]][32]..": <R>"..playerStats[playerId].mapsFinished.."</R>\n"
    local firstrate = "0%"
    if playerStats[playerId].mapsFinishedFirst > 0 then
        firstrate = (math.floor(playerStats[playerId].mapsFinishedFirst/playerStats[playerId].mapsFinished * 10000) / 100).."%"
    end
    body = body.." » "..translations[playerlanguage[creatorId]][33]..": <R>"..firstrate.."</R>\n"
    body = body.." » "..translations[playerlanguage[creatorId]][34]..": <R>"..playerStats[playerId].timesEnteredInHole.."</R>\n"
    body = body.." » "..translations[playerlanguage[creatorId]][35]..": <R>"..playerStats[playerId].graffitiSprays.."</R>\n"
    body = body.." » "..translations[playerlanguage[creatorId]][36]..": <R>"..playerStats[playerId].timesDashed.."</R>\n"
    body = body.." » "..translations[playerlanguage[creatorId]][37]..": <R>"..playerStats[playerId].timesRewinded.."</R>\n"
    
    return body
end

function eventTextAreaCallback(textAreaId, playerName, eventName)
    local id = room.playerList[playerName].id
    if id == 0 then
        return
    end
    if textAreaId == 12 then
        if eventName == "ShopOpen" then
            if menupage[id] == 0 then
                createPage(translations[playerlanguage[id]][25], ":D", playerName)
            else
                updatePage(translations[playerlanguage[id]][25], ":D", playerName)
            end
        end
        if eventName == "StatsOpen" then
            if menupage[id] == 0 then
                createPage(translations[playerlanguage[id]][26].." - "..playerName, stats(playerName, id, id), playerName)
            else
                updatePage(translations[playerlanguage[id]][26].." - "..playerName, stats(playerName, id, id), playerName)
            end
        end
        if eventName == "LeaderOpen" then
            if menupage[id] == 0 then
                createPage(translations[playerlanguage[id]][27], ":3", playerName)
            else
                updatePage(translations[playerlanguage[id]][27], ":3", playerName)
            end
        end
        if eventName == "SettingsOpen" then
            if menupage[id] == 0 then
                menupage[id] = "settings"
                createPage(translations[playerlanguage[id]][28], remakeOptions(playerName), playerName)
            else
                menupage[id] = "settings"
                updatePage(translations[playerlanguage[id]][28], remakeOptions(playerName), playerName)
            end
        end
        if eventName == "AboutOpen" then
            if menupage[id] == 0 then
                createPage(translations[playerlanguage[id]][29], translations[playerlanguage[id]][30], playerName)
            else
                updatePage(translations[playerlanguage[id]][29], translations[playerlanguage[id]][30], playerName)
            end
        end
    end
    
    -- SETTINGS
    if menupage[id] == "settings" and textAreaId == 13 then
        if eventName == "ToggleDummy" then
            if playerpreferences[id][1] == true then
                playerpreferences[id][1] = false
            else
                playerpreferences[id][1] = true
            end
        end
        if eventName == "ToggleDashPart" then
            if playerpreferences[id][2] == true then
                playerpreferences[id][2] = false
            else
                playerpreferences[id][2] = true
            end
        end
    
        if eventName == "ToggleTimePanels" then
            if playerpreferences[id][3] == true then
                playerpreferences[id][3] = false
                removeTextArea(5, playerName)
                removeTextArea(4, playerName)
            else
                -- REGENERATE PANELS
                playerpreferences[id][3] = true
                addTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerlanguage[id]][6]..": N/A", playerName, 10, 45, 200, 21, 0xffffff, 0x000000, 0, true)
                addTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerlanguage[id]][7]..": N/A", playerName, 10, 30, 200, 21, 0xffffff, 0x000000, 0, true)
                if playerfinished[id] == true then
                    ui.updateTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerlanguage[id]][6]..": "..(playerlasttime[id]/100).."s", playerName)
                    ui.updateTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerlanguage[id]][7]..": "..(playerbesttime[id]/100).."s", playerName)
                end
            end
        end
        updatePage(translations[playerlanguage[id]][28], remakeOptions(playerName), playerName)
    end

    if eventName == "CloseMenu" then
        closePage(playerName)
    end

    if eventName == "CloseWelcome" then
        if helpimgid[id] ~= 0 then 
            removeImage(helpimgid[id])
        end
        removeTextArea(10, playerName)
    end

    if eventName == "CloseHelp" then
        if helpopen[id] == true then
            removeTextArea(11, playerName)
            helpopen[id] = false
        end
    end
end

function remakeOptions(playerName)
    -- REMAKE OPTIONS TEXT (UPDATE YES - NO)
    local id = room.playerList[playerName].id
    toggles = {translations[playerlanguage[id]][12], translations[playerlanguage[id]][12], translations[playerlanguage[id]][12]}
    if playerpreferences[id][1] == false then
        toggles[1] = translations[playerlanguage[id]][13]
    end
    if playerpreferences[id][2] == false then
        toggles[2] = translations[playerlanguage[id]][13]
    end
    if playerpreferences[id][3] == false then
        toggles[3] = translations[playerlanguage[id]][13]
    end
    return " » <a href=\"event:ToggleDummy\">"..translations[playerlanguage[id]][14].."?</a> "..toggles[1].."\n » <a href=\"event:ToggleDashPart\">"..translations[playerlanguage[id]][15].."?</a> "..toggles[2].."\n » <a href=\"event:ToggleTimePanels\">"..translations[playerlanguage[id]][16].."?</a> "..toggles[3]
end

-- RESET ALL PLAYERS
function resetAll()
    local ostime = os.time()
    rewindpos = {}
    playerSortedBestTime = {}
    bestPlayers = {{"N/A", "N/A", "N/A"}, {"N/A", "N/A", "N/A"}, {"N/A", "N/A", "N/A"}}
    hasShownStats = false

    for index, value in pairs(playerbesttime) do
        playerbesttime[index] = 999999
        playerlasttime[index] = 999999
    end

    for playerName in pairs(room.playerList) do
        local id = room.playerList[playerName].id
        if id ~= 0 then
            print("Resetting stats for"..playerName)
            setPlayerScore(playerName, 0)
            lastrewindused[id] = 0
            canrewind[id] = false
            
            lastkeypressed[id] = 0
            lastkeypressedtime[id] = ostime - DASHCOOLDOWN
            lastkeypressedtimeleft[id] = 0
            lastkeypressedtimeright[id] = 0
            lastkeypressedtimejump[id] = 0
            lastdashusedtime[id] = 0
            lastjumpusedtime[id] = ostime - JUMPCOOLDOWN
            playerfinished[id] = false
            checkpointtime[id] = 0
            jumpstate[id] = true
            dashstate[id] = true


            rewindpos[id] = {0, 0, false}
            fastestplayer = -1
            besttime = 99999
            playerWon = 0
            setColor(playerName)
            -- REMOVE GRAFFITIS
            removeTextArea(id)
            lastgraffititime[id] = 0
            -- UPDATE THE TEXT
            if playerpreferences[id][3] == true then
                ui.updateTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerlanguage[id]][7]..": N/A", playerName)
                ui.updateTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerlanguage[id]][6]..": N/A", playerName)
            end
            
        else
            killPlayer(playerName)
        end
    end
    tfm.exec.setGameTime(MAPTIME, true)
end

-- DEBUGGING
function eventChatCommand(playerName, message)
    local ostime = os.time()
    local arg = {}
    for argument in message:gmatch("[^%s]+") do
        table.insert(arg, argument)
    end

    arg[1] = string.lower(arg[1])

    local isOp = false
    local isMod = false

    if checkMod(playerName) == true then
        isMod = true
        isOp = true
    end

    for index, name in pairs(oplist) do
        if name == playerName then
            isOp = true
        end
    end

    if admin == playerName and customroom == true then
        isOp = true
    end

    -- OP ONLY ABILITIES (INCLUDES MOD)
    if isOp == true then
        if arg[1] == "m" then
            if arg[2] ~= nil then
                tfm.exec.newGame(arg[2])
                tfm.exec.setAutoMapFlipMode(randomFlip())
                resetAll()
            end
        end

        if arg[1] == "n" then
            hasShownStats = false
            mapwasskipped = true
            bestPlayers = {{"N/A", "N/A", "N/A"}, {"N/A", "N/A", "N/A"}, {"N/A", "N/A", "N/A"}}
        end
    end

    -- MOD ONLY ABILITIES
    if isMod == true then
        if arg[1] == "mod" then
            if checkRoomMod(playerName) == false then
                table.insert(modroom, playerName)
                local message = "You are a mod!"
                print(message)
                chatMessage(message, playerName)
            else
                for index, name in pairs(modroom) do
                    if name == playerName then
                        table.remove(modroom, index)
                        local message = "You are no longer a mod!"
                        print(message)
                        chatMessage(message, playerName)
                        break
                    end
                end
            end
            setColor(playerName)
        end

        if arg[1] == "op" then
            if arg[2] ~= nil then
                local wasOp = false

                for index, name in pairs(oplist) do
                    if name == arg[2] then
                        table.remove(oplist, index)
                        local message = arg[2].." is no longer an operator."
                        print(arg[2].." is no longer an operator.")
                        chatMessage(message, playerName)
                        wasOp = true
                        break
                    end
                end

                if wasOp == false then
                    table.insert(oplist, arg[2])
                    local message = arg[2].." is an operator!"
                    print(arg[2].." is an operator!")
                    chatMessage(message, playerName)
                end
            end
        end

        if arg[1] == "a" then
            if arg[2] ~= nil then
                for i = 3, #arg do
                    arg[2] = arg[2].." "..arg[i]
                end
                local message = "<font color='#72b6ff'>#ninja Owner "..playerName..": "..arg[2].."</font>"
                print(message)
                chatMessage(message)
            end
        end
    end

    if arg[1] == "pw" and playerName == admin then
        if room.passwordProtected == false and arg[2] ~= nil then
            customroom = true
            tfm.exec.setRoomPassword(arg[2])
            chatMessage("Password: "..arg[2], playerName)
        else
            customroom = false
            tfm.exec.setRoomPassword("")
            chatMessage("Password: "..arg[2], playerName)
        end
    end

    if arg[1] == "p" or arg[1] == "profile" and arg[2] ~= nil then
        for name, value in pairs(room.playerList) do
            if name == arg[2] then
                if menupage[id] == 0 then
                    menupage[id] = "stats"
                    createPage(translations[playerlanguage[id]][26].." - "..arg[2], stats(arg[2], room.playerList[arg[2]].id, id), playerName, id)
                else
                    menupage[id] = "stats"
                    updatePage(translations[playerlanguage[id]][26].." - "..arg[2], stats(arg[2], room.playerList[arg[2]].id, id), playerName, id)
                end
                break
            end
        end
    end
end

