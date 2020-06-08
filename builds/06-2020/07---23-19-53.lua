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

local languages = {"ro", "en", "fr"}
local translations = {}
--[[ Directory translations ]]--
--[[ File translations/en.lua ]]--
translations.en = {
    lastTime = "Your last time",
    lastBestTime = "Your best time",
    helpToolTip = "<p align='center'>Press <b>H</b> for help.</p>",
    optionsYes = "<font color='#53ba58'>Yes</font>",
    optionsNo = "<font color='#ba5353'>No</font>",
    graffitiSetting = "Enable graffitis",
    particlesSetting = "Enable dash/jump particles",
    timePanelsSetting = "Enable time panels",
    globalChatSetting = "Enable global chat",
    voteStart = " started a vote to skip the current map. Type !yes to vote positively.",
    newRecord = " finished the map in the fastest time!",
    devInfo = "<V>Want to submit a map? Check this link: https://atelier801.com/topic?f=6&t=888399</V>\n<font color='#CB546B'>This module is in development. Please report any bugs to Extremq#0000 or Railysse#0000.</font>",
    welcomeInfo = "Welcome to <font color='#E68D43'>#ninja</font>! Press <font color='#E68D43'>H</font> for help.",
    finishedInfo = "You finished the map! Time: ",
    helpBody = "You have to bring the cheese back to the hole as fast as you can.\n\n<b>Abilities</b>:\n» Dash - Press <b><font color='#CB546B'>Left</font></b> or <b><font color='#CB546B'>Right Arrows</font></b> twice. (1s cooldown)\n» Jump - Press <b><font color='#CB546B'>Up Arrow</font></b> twice. (3s cooldown)\n» Rewind - Press <b><font color='#CB546B'>Space</font></b> to leave a checkpoint. Press <b><font color='#CB546B'>Space</font></b> again within 3 seconds to teleport back to the checkpoint. (10s cooldown)\n\n<b>Other shortcuts</b>:\n» Kill the mouse - Press <b><font color='#CB546B'>X</font></b> or write /mort to kill the mouse.\n» Open menu - Press <b><font color='#CB546B'>M</font></b> or click in the left side of your screen to open/close the menu.\n» Place a graffiti - Press <b><font color='#CB546B'>C</font></b> to leave a graffiti. (60s cooldown)\n» Open help - Press <b><font color='#CB546B'>H</font></b> to open/close this screen.\n\n<b>Commands</b>:\n» !p Name#id - Check the stats of another player.\n» !pw Password - Place a password on the room. (the room must be made by you)\n» !m @code - Load any map you want. (the room must have a password)\n» !langue country - Change the language of the module. (only for you)\n\n<p align='center'><a href='event:CloseMenu'><b><font color='#CB546B'>Close</font></b></a></p>", --23
    Xbtn = "X",
    -- IF YOUR LANGUAGE HAS SEPCIAL CHARACTERS, PLEASE JUST LEAVE THESE AS DEFAULT
    shopTitle = "Collection",
    profileTitle = "Profile",
    leaderboardsTitle = "Leaderboards",
    settingsTitle = "Settings",
    aboutTitle = "About",
    -- END
    aboutBody = "Module coded by <font color='#FFD991'>Extremq#0000</font>.\nGamplay ideas, bug-testing and maps provided by <font color='#FFD991'>Railysse#0000</font>.\n\nThis module is fully supported by the mice fundation „Red Cheese” with the „Save Module” project. All funds that we will earn will be donated to mice which play #parkour so we can bribe them to play our module.\n\nWe're just kidding, thank you for trying our module! :D\n\n<p align='center'><font color='#EB1D51'>&lt;3</font></p>", -- 30
    playtime = "Playtime",
    firsts = "Firsts",
    finishedMaps = "Completed maps",
    firstRate = "First rate",
    holeEnters = "Times entered the hole",
    graffitiUses = "Graffiti uses",
    dashUses = "Times dashed",
    rewindUses = "Times rewinded",
    hardcoreMaps = "Hardcore maps completed",
    shopNotice = "The shop is in development.",
    leaderboardsNotice = "A leaderboard will be implemented when the module becomes official.",
    notValidCommand = "is not a valid command."
}
--[[ End of file translations/en.lua ]]--
--[[ File translations/fr.lua ]]--
translations.fr = {
    lastTime = "La dernière fois",
    lastBestTime = "Votre meilleur temps",
    helpToolTip = "<p align='center'>Appuyez sur <b>H</b> pour de l'aide.</p>",
    optionsYes = "<font color='#53ba58'>Oui</font>",
    optionsNo = "<font color='#ba5353'>Non</font>",
    graffitiSetting = "Activer les graffitis",
    particlesSetting = "Activer les particules de boost et de saut",
    timePanelsSetting = "Activer les panneaux de temps",
    globalChatSetting = "Activer la discussion global",
    voteStart = " a comencé un vote pour passer la carte actuelle. Ecrivez !yes pour voter positivement.",
    newRecord = " a fini la carte avec le meilleur temps!",
    devInfo = "<V>Vous voulez proposer une carte? Allez sur ce lien : https://atelier801.com/topic?f=6&t=888399</V>\n<font color='#CB546B'>Ce module est toujours en développement. Merci de signaler tous les bugs à Extremq#0000 ou Railysse#0000.</font>",
    welcomeInfo = "Bienvenue dans <font color='#E68D43'>#ninja</font>! Appuyez sur <font color='#E68D43'>H</font> pour de l'aide.",
    finishedInfo = "Vous avez fini la carte! Temps: ",
    helpBody = "Vous devez ramener le fromage dans le trou le plus rapidement possible.\n\n<b>Capacités </b>:\n» Boost - Appuyez deux fois sur <b><font color='#CB546B'>la flèche gauche</font></b> ou <b><font color='#CB546B'>la flèche droite</font></b>. (1s de rechargement)\n» Saut - Appuyez deux fois sur <b><font color='#CB546B'>la flèche du haut</font></b>. (3s de rechargement)\n» Retour - Appuyez sur <b><font color='#CB546B'>espace</font></b> pour laisser un point de sauvegarde. Appuyez sur <b><font color='#CB546B'></font></b> encore une fois dans les 3 secondes qui suivent pour vous téléporter sur ce point de sauvegarde. (10s de recharge)\n\n<b>Autres raccourcis</b>:\n» Se tuer - Appuyez sur <b><font color='#CB546B'>X</font></b> ou écrivez /mort pour tuer la souris.\n» Ouvrir le menu - Apuyez sur <b><font color='#CB546B'>M</font></b> ou cliquez sur la partie gauche de votre écran pour ouvrir/fermer le menu.\n» Placer un graffiti - Appuyez sur <b><font color='#CB546B'>C</font></b> pour afficher un graffiti. (60s de rechargement)\n» Ouvrir l'aide - Appuyez sur <b><font color='#CB546B'>H</font></b> pour ouvrir/fermer cette affichage.\n\n<b>Commands</b>:\n» !p Name#id - Affiche les statistiques d'un autre joueur.\n» !pw mot de passe - Ajoute un mot de passe au salon. (le salon doit être créé par vous)\n» !m @code - Charge n'importe quel carte que vous voulez. (le salon doit avoir un mot de passe)\n» !langue pays - Change la langue du module. (seulement pour toi)\n\n<p align='center'><a href='event:CloseMenu'><b><font color='#CB546B'>Fermer</font></b></a></p>", --23
    Xbtn = "X",
    -- IF YOUR LANGUAGE HAS SEPCIAL CHARACTERS, PLEASE JUST LEAVE THESE AS DEFAULT
    shopTitle = "Collection",
    profileTitle = "Profile",
    leaderboardsTitle = "Classement",
    settingsTitle = "Parametres",
    aboutTitle = "A propos",
    -- END
    aboutBody = "Module codé par <font color='#FFD991'>Extremq#0000</font>.\nIdée de jeu, test des bugs and cartes fournies par <font color='#FFD991'>Railysse#0000</font>.\n\nCe module est complétement soutenu par la fondation „Red Cheese” avec le projet „Save Module”. Tous les revenus que nous recevrons seront directement versées aux joueur qui jouent à #parkour comme ça on les supplie de jouer à notre module.\n\nC'est une blague! Merci d'avoir joué à notre module! :D\n\n<p align='center'><font color='#EB1D51'>&lt;3</font></p>", -- 30
    playtime = "Playtime",
    firsts = "Cartes complétées en premiere",
    finishedMaps = "Cartes complétées",
    firstRate = "Taux de cartes complétées en premiere",
    holeEnters = "Nombre de fois entrée dans le trou",
    graffitiUses = "Graffitis utilisés",
    dashUses = "Nombre de Boosts utilisés",
    rewindUses = "Nombre de Retour utilisés",
    hardcoreMaps = "Cartes compliquées complétées",
    shopNotice = "La boutique est en developpement.",
    leaderboardsNotice = "Un classement sera implenté quand le module deviendra officiel.",
    notValidCommand = "n'est pas une commande valide."
}
--[[ End of file translations/fr.lua ]]--
--[[ File translations/ro.lua ]]--
translations.ro = {
    lastTime = "Ultimul timp",
    lastBestTime = "Cel mai bun timp",
    helpToolTip = "<p align='center'>Apasă <b>H</b> pentru ajutor.</p>",
    optionsYes = "<font color='#53ba58'>Da</font>", -- 12
    optionsNo = "<font color='#ba5353'>Nu</font>",  -- 13
    graffitiSetting = "Activezi graffitiurile", -- 14
    particlesSetting = "Activezi particulele de dash", -- 15
    timePanelsSetting = "Activezi panourile de timp", -- 16
    globalChatSetting = "Activezi chatul global",
    voteStart = " a inițiat un vot pentru a trece la următoarea mapă. Scrie !yes pentru a vota pozitiv.", -- 18
    newRecord = " a terminat harta cel mai rapid!", --19
    devInfo = "<V>Vrei să faci o hartă pentru acest modul? Întră pe acest link: https://atelier801.com/topic?f=6&t=888399</V>\n<font color='#CB546B'>Acest modul este în curs de dezvoltare. Raportează orice problemă lui Extremq#0000 sau Railysse#0000.</font>", -- 20
    welcomeInfo = "Bine ai venit pe <font color='#E68D43'>#ninja</font>! Apasă <font color='#E68D43'>H</font> pentru ajutor.", -- 21
    finishedInfo = "Ai terminat harta! Timp: ", --22
    helpBody = "Trebuie să aduci brânza înapoi la gaură cât mai rapid posibil.\n\n<b>Abilități</b>:\n» Dash - Apasă <b><font color='#CB546B'>săgeată Stânga</font></b> sau <b><font color='#CB546B'>Dreapta</font></b> de două ori. (reîncărcare 1s)\n» Jump - Apasă <b><font color='#CB546B'>săgeată Sus</font></b> de două ori. (reîncărcare 3s)\n» Rewind - Apasă <b><font color='#CB546B'>Spațiu</font></b> pentru a lăsa un checkpoint. Apasă <b><font color='#CB546B'>Spațiu</font></b> din nou în maximum 3 secunde pentru a te teleporta înapoi la checkpoint. (reîncărcare 10s)\n\n<b>Alte scurtături</b>:\n» Deschide meniul - Apasă <b><font color='#CB546B'>M</font></b> sau dă click în partea stângă a ecranului pentru a închide/deschide meniul.\n» Pune un graffiti - Apasă <b><font color='#CB546B'>C</font></b> pentru a lăsa un graffiti. (reîncărcare 60s\n» Omoară șoricelul - Apasă <b><font color='#CB546B'>X</font></b> sau scrie /mort pentru a omorî șoarecele.\n» Deschide instrucțiunile - Apasă <b><font color='#CB546B'>H</font></b> pentru a deschide/închide acest ecran.\n\n<b>Comenzi</b>:\n» !p Nume#id - Verifică statisticile altui player.\n» !pw Parolă - Pune parolă pe sală. (sala trebuie făcută de tine)\n» !m @cod - Încarcă ce hartă vrei tu. (trebuie ca sala să aibă parolă)\n» !langue țară - Schimbă limba modulului. (doar pentru tine)\n\n<p align='center'><a href='event:CloseMenu'><b><font color='#CB546B'>Închide</font></b></a></p>", --23
    Xbtn = "X", -- 24
    shopTitle = "Colecție", -- 25
    profileTitle = "Profil", -- 26
    leaderboardsTitle = "Clasamente", -- 27
    settingsTitle = "Configurare", -- 28
    aboutTitle = "Despre", -- 29
    aboutBody = "Modul codat de <font color='#FFD991'>Extremq#0000</font>.\nIdei de joc, bug-testing și hărți asigurate de <font color='#FFD991'>Railysse#0000</font>.\n\nAcest modul este susținut în întregime de fundația șoricească „Brânza Roșie” în cadrul proiectului „Salvați Module”. Toate fondurile pe care le primim vor fi donate șoarecilor care stau pe #parkour cu scopul de a-i mitui să vină aici.\n\nGlumim, mulțumim că ne-ai încercat jocul! :D\n\n<p align='center'><font color='#EB1D51'>&lt;3</font></p>", -- 30
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
    notValidCommand = "nu este o comandă validă."
}
--[[ End of file translations/ro.lua ]]--
--[[ End of directory translations ]]--

-- Standard maps
stMapCodes = {{"@7725753", 3}, {"@7726015", 1}, {"@7726744", 2}, {"@7728063", 4}, {"@7731641", 2}, {"@7730637", 3}, {"@7732486", 2}, {"@6784223", 4}, {"@7734262", 3}, {"@7735744", 4}}
stMapsLeft = {{"@7725753", 3}, {"@7726015", 1}, {"@7726744", 2}, {"@7728063", 4}, {"@7731641", 2}, {"@7730637", 3}, {"@7732486", 2}, {"@6784223", 4}, {"@7734262", 3}, {"@7735744", 4}}

-- Hardcore maps
hcMapCodes = {{"@7733773", 6}, {"@7733777", 6}}
hcMapsLeft = {{"@7733773", 6}, {"@7733777", 6}}

modList = {['Extremq#0000'] = true, ['Railysse#0000'] = true}
modRoom = {}
opList = {}
lastMap = ""
mapWasSkipped = false
mapStartTime = 0
mapDiff = 0
mapCount = 1

VERSION = "1.5.3, 07.06.2020"

--CONSTANTS
MAPTIME = 4 * 60
BASETIME = MAPTIME -- after difficulty
STATSTIME = 10 * 1000
DASHCOOLDOWN = 1 * 1000
JUMPCOOLDOWN = 3 * 1000
REWINDCOOLDONW = 10 * 1000
GRAFFITICOOLDOWN = 15 * 1000
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
function randomMap(mapsLeft, mapCodes)
    -- DELETE THE CHOSEN MAP
    if #mapsLeft == 0 then
        for key, value in pairs(mapCodes) do
            table.insert(mapsLeft, value)
        end
    end
    local pos = random(1, #mapsLeft)
    local newMap = mapsLeft[pos]
    -- IF THE MAPS ARE THE SAME, PICK AGAIN
    if newMap[1] == lastMap then
        table.remove(mapsLeft, pos)
        pos = random(1, #mapsLeft)
        newMap = mapsLeft[pos]
        table.insert(mapsLeft, lastMap)
    end
    table.remove(mapsLeft, pos)
    lastMap = newMap[1]
    mapDiff = newMap[2]
    MAPTIME = BASETIME + (mapDiff - 1) * 30
    if mapDiff == 6 then
        MAPTIME = 5 * 60
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

tfm.exec.disableAutoTimeLeft(true)
tfm.exec.disableAutoScore(true)
tfm.exec.disableAutoShaman(true)
tfm.exec.disableAfkDeath(true)
tfm.exec.disableAutoNewGame(true)
tfm.exec.setAutoMapFlipMode(randomFlip())
tfm.exec.newGame(randomMap(stMapsLeft, stMapCodes))
tfm.exec.disablePhysicalConsumables(true)
system.disableChatCommandDisplay()
tfm.exec.setGameTime(MAPTIME, true)

keys = {0, 1, 2, 3, 32, 67, 71, 72, 77, 84, 88}
bestTime = 99999

function shopListing(values, imgId, tooltip, reqs)
    return {
        ['values'] = values,
        ['imgId'] = imgId,
        ['tooltip'] = tooltip,
        ['reqs'] = reqs
    }
end

shop = {
    dashAcc = {
        shopListing({3}, "1728b45b3eb.png", "This is the default particle.", "Free."),
        shopListing({3, 31}, "1728b44464b.png", "Add some hearts to your dash!", "Secret."),
        shopListing({3, 13}, "1728b442708.png", "Sleek. Just like you.", "Finish 1 map first.")
    },
    graffitiCol = {
        shopListing('#ffffff', '#ffffff', "This is the default graffiti color.", "Free."),
        shopListing('#000000', '#000000', "You're a dark person.", "Finish 10 maps."),
        shopListing('#8c0404', '#8c0404', "Where's this... blood from?", "Dash 100 times.")
    },
    graffitiImgs = {
        shopListing(nil, nil, "This is the default image (no image).", "Free."),
        shopListing("17290c497e1.png", "17290c497e1.png", "Say cheese!", "Finish 1 harcore map.")
    },
    graffitiFonts = {
        shopListing("Comic Sans MS", "Comic Sans MS", "This is the default font for graffitis.", "Free."),
        shopListing("Papyrus", "Papyrus", "You seem old.", "Spray a graffiti 20."),
        shopListing("Verdana", "Verdana", "A classic.", "Rewind 10 times.")
    }
}

-- We save ids so when a player leaves we still have their id (mostly to remove graffitis)
playerIds = {}

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
globalPlayerCount = 0
-- SCORE OF PLAYER
fastestplayer = -1
playerSortedBestTime = {}
-- TRUE/FALSE
playerCount = 0
playerWon = 0
mapfinished = false
admin = ""
customRoom = false
hasShownStats = false

-- RETURN PLAYER ID
function playerId(playerName)
    return playerIds[playerName]
end

function showDashParticles(types, direction, x, y)
    -- Only display particles to the players who haven't disabled the setting
    for name, data in pairs(room.playerList) do
        if room.playerList[name].id ~= 0 and playerVars[room.playerList[name].id].playerPreferences[2] == true then
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
        if room.playerList[name].id ~= 0 and playerVars[room.playerList[name].id].playerPreferences[2] == true then
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

    if id == 0 then
        return
    end

    local ostime = os.time()

    -- Everything here is for gameplay, so we only check them if the player isnt dead
    if room.playerList[playerName].isDead == false then
        --[[
            Because of the nature my dash works (both left and right keys share the same cooldown) I cannot shorten without checking for both
            doublepress and keypress. (though i can make the checker variable an array but it would look ugly.)
        ]]--
        if (keyCode == 0 or keyCode == 2) and ostime - cooldowns[id].lastDashTime > DASHCOOLDOWN then
            local dashUsed = false
            local direction = 1 -- assume its right

            if keyCode == 0 then
                direction = -1
            end
            -- we check wether its left or right and if we double-tapped or not (can't shorten this)
            if keyCode == 2 and ostime - cooldowns[id].lastRightPressTime < 200 then
                dashUsed = true;
            elseif
                keyCode == 0 and ostime - cooldowns[id].lastLeftPressTime < 200 then
                dashUsed = true;
            end

            -- When we succesfully double tap without being on cooldown, we execute this.
            if dashUsed == true then
                -- Update cooldowns
                cooldowns[id].lastDashTime = ostime
                states[id].dashState = false

                -- Update cd image
                removeImage(imgs[id].dashButtonId)
                imgs[id].dashButtonId = addImage(DASH_BTN_OFF, "&1", DASH_BTN_X, DASH_BTN_Y, playerName)

                -- Update stats
                playerStats[id].timesDashed = playerStats[id].timesDashed + 1

                -- Move the palyer
                movePlayer(playerName, 0, 0, true, 150 * direction, 0, false)

                -- Now, we can change the 3 with whatever the player has equipped in the shop!
                showDashParticles(shop.dashAcc[playerStats[id].equipment[1]].values, direction, xPlayerPosition, yPlayerPosition)
            end
        --[[
            We check for the key, then if its a double press, then the cooldown. (by the way, if it fails to check, for example,
            keyCode == 1 then it won't check the other conditions, so we put the most important conditions first then follow up with
            those who are most likely to happen when we actually want to jump - its more likely that the player double presses when he has
            the cooldown available instead of doublepressing when the cooldown is offline.)
        ]]--
        elseif keyCode == 1 and ostime - cooldowns[id].lastJumpPressTime < 200 and ostime - cooldowns[id].lastJumpTime > JUMPCOOLDOWN  then
            -- Update cooldowns (press is for doublepress and the other for cooldown)
            cooldowns[id].lastJumpTime = ostime
            states[id].jumpState = false

            -- Update jump cd image
            removeImage(imgs[id].jumpButtonId)
            imgs[id].jumpButtonId = addImage(JUMP_BTN_OFF, "&1", JUMP_BTN_X, JUMP_BTN_Y, playerName)

            -- Update stats
            playerStats[id].timesDashed = playerStats[id].timesDashed + 1

            -- Move player
            movePlayer(playerName, 0, 0, true, 0, -60, false)

            -- Display jump particles
            showJumpParticles(shop.dashAcc[playerStats[id].equipment[1]].values, xPlayerPosition, yPlayerPosition)
        --[[
            The rewind is a bit more complicated, since it has 3 states: available, in use, not available.
            My first check is if I can rewind (state 2), then if my cooldown is available (state 1).
            If state 1 is true, then next time we press space state 2 must be true. After we use state 2, we will be on cooldown.
            The only states that enter this states 1 and 2.
        ]]--
        elseif keyCode == 32 and ostime - cooldowns[id].lastRewindTime > REWINDCOOLDONW then
            if cooldowns[id].canRewind == true then
                -- Teleport the player to the checkpoint
                movePlayer(playerName, playerVars[id].rewindPos[1], playerVars[id].rewindPos[2], false, 0, 0, false)

                -- Update states & cooldowns
                cooldowns[id].lastRewindTime = ostime
                cooldowns[id].canRewind = false

                -- Update hourglass
                removeImage(imgs[id].rewindButtonId)
                imgs[id].rewindButtonId = addImage(REWIND_BTN_ACTIVE, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)

                -- Remove the mouse (the checkpoint)
                removeImage(imgs[id].mouseImgId)

                -- Show teleport particle
                displayParticle(36, xPlayerPosition, yPlayerPosition, 0, 0, 0, 0, nil)

                -- Show random particles (only time we use this are when we create the checkpoint and when the checkpoint dies (3 times in the code))
                showRewindParticles(2, playerName, xPlayerPosition, yPlayerPosition)

                -- If the player didn't have cheese when he created the checkpoint, we remove it
                if playerVars[id].rewindPos[3] == false then
                    tfm.exec.removeCheese(playerName)
                end

                -- Add to stats
                playerStats[id].timesRewinded = playerStats[id].timesRewinded + 1
            else
                -- Update cooldowns
                cooldowns[id].canRewind = true
                cooldowns[id].checkpointTime = ostime

                -- Save current player state (pos and cheese)
                playerVars[id].rewindPos = {xPlayerPosition, yPlayerPosition, room.playerList[playerName].hasCheese}

                -- Update hourglass
                imgs[id].mouseImgId = addImage(CHECKPOINT_MOUSE, "_100", xPlayerPosition - 59/2, yPlayerPosition - 73/2, playerName)
                removeImage(imgs[id].rewindButtonId)
                imgs[id].rewindButtonId = addImage(REWIND_BTN_OFF, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)

                -- Show particles where we teleport to
                showRewindParticles(2, playerName, playerVars[id].rewindPos[1], playerVars[id].rewindPos[2])
            end
            -- GRAFFITI (C)
        elseif keyCode == 67 and ostime - cooldowns[id].lastGraffitiTime > GRAFFITICOOLDOWN  then
            -- Update cooldowns
            cooldowns[id].lastGraffitiTime = ostime

            -- Update stats
            playerStats[id].graffitiSprays = playerStats[id].graffitiSprays + 1

            -- Create graffiti
            for player, data in pairs(room.playerList) do
                local _id = data.id
                removeTextArea(id, player)
                -- If the player has graffitis enabled, we display them
                if playerVars[_id].playerPreferences[1] == true then
                    addTextArea(id, "<p align='center'><font face='"..shop.graffitiFonts[playerStats[id].equipment[4]].imgId.."' size='16' color='"..shop.graffitiCol[playerStats[id].equipment[2]].imgId.."'>"..playerName.."</font></p>", player, xPlayerPosition - 300/2, yPlayerPosition - 25/2, 300, 25, 0x324650, 0x000000, 0, false)
                end
            end
        end
        -- This needs to be after dash/jump blocks.
        if keyCode == 0 then
            cooldowns[id].lastLeftPressTime = ostime
        elseif keyCode == 1 then
            cooldowns[id].lastJumpPressTime = ostime
        elseif keyCode == 2 then
            cooldowns[id].lastRightPressTime = ostime
        end
    end
    -- These keys are for various other purposes
    -- MORT (X) (mort is more likely to be called than the menu/help)
    if keyCode == 88 then
        killPlayer(playerName)
    -- MENU (M)
    elseif keyCode == 77 then
        -- If we don't have the menu open, then we dont have an image
        if imgs[id].menuImgId == -1 then
            addTextArea(12, "<font color='#E9E9E9' size='10'><a href='event:ShopOpen'>             "..translations[playerVars[id].playerLanguage].shopTitle.."</a>\n\n\n\n<a href='event:StatsOpen'>             "..translations[playerVars[id].playerLanguage].profileTitle.."</a>\n\n\n\n<a href='event:LeaderOpen'>             "..translations[playerVars[id].playerLanguage].leaderboardsTitle.."</a>\n\n\n\n<a href='event:SettingsOpen'>             "..translations[playerVars[id].playerLanguage].settingsTitle.."</a>\n\n\n\n<a href='event:AboutOpen'>             "..translations[playerVars[id].playerLanguage].aboutTitle.."</a>", playerName, 13, 103, 184, 220, 0x324650, 0x000000, 0, true)
            imgs[id].menuImgId = addImage(MENU_BUTTONS, ":10", MENU_BTN_X, MENU_BTN_Y, playerName)
        -- Else we had it already open, so we close the page
        else
            closePage(playerName)
            closeMenu(playerName)
        end
    -- OPEN GUIDE / HELP (H)
    elseif keyCode == 72 then
        -- Help system
        if playerVars[id].helpOpen == false then
            -- If we are on some page, we just update that textarea
            if playerVars[id].menuPage ~= 0 then
                updatePage("#ninja", translations[playerVars[id].playerLanguage].helpBody, playerName, "help")
            else
                createPage("#ninja", translations[playerVars[id].playerLanguage].helpBody, playerName, "help")
            end
            playerVars[id].helpOpen = true
        elseif playerVars[id].helpOpen == true then
            closePage(playerName)
            playerVars[id].helpOpen = false
        end
    end
end

function eventPlayerDied(playerName)
    local id = playerId(playerName)
    playerVars[id].rewindPos = {0, 0, false}
    -- Remove rewind Mouse
    if imgs[id].mouseImgId ~= nil then
        removeImage(imgs[id].mouseImgId)
    end
end

-- UPDATE MAP NAME (custom timer)
function updateMapName(timeRemaining)
    -- in case it hasn't loaded for some reason, we wait for 3 seconds
    if MAPTIME * 1000 - timeRemaining < 3000 then
        setMapName("Loading...<")
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
        difficultyMessage = "<R>HARDCORE</R>"
    end

    local name = currentmapauthor.." <G>-</G><N> "..currentmapcode.."</N> <G>-</G> Level: "..difficultyMessage.." <G>|<G> <N>Mice:</N> <J>"..playerCount.."</J> <G>|<G> <N>"..minutes..":"..seconds.."</N>"
    -- Append record
    if fastestplayer ~= -1 then
        local record = (bestTime / 100)
        name = name.." <G>|<G> <N2>Record: </N2><R>"..fastestplayer.." - "..record.."s</R>"
    end

    -- If the map is over, we show stats
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
    -- Init some empty array
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
    -- We open the stats for every player: if the player has a menu opened, we just update the text, otherwise create
    for name, value in pairs(room.playerList) do
        local _id = value.id
        if playerVars[_id].menuPage == 0 then
            createPage(translations[playerVars[_id].playerLanguage].leaderboardsTitle, message, name, "roomStats")
        else
            updatePage(translations[playerVars[_id].playerLanguage].leaderboardsTitle, message, name, "roomStats")
        end
    end
    -- If we had a best player, we update his firsts stat
    if bestPlayers[1][1] ~= "N/A" then
        playerStats[room.playerList[bestPlayers[1][1]].id].mapsFinishedFirst = playerStats[room.playerList[bestPlayers[1][1]].id].mapsFinishedFirst + 1
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
        if mapCount % 5 == 0 then -- I don't want to run this yet
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
            if id ~= 0 then
                if room.playerList[playerName].isDead == true then
                    -- RESPAWN PLAYER
                    tfm.exec.respawnPlayer(playerName)
                end
                -- UPDATE UI
                --[[
                    This is where i use states: i basically keep track if i changed an icon's cooldown indicator. Why?
                    For example, lets say i have my cooldown ready. Without a state, i have no idea if i just got it now
                    or i had it already, so i have to remove the image and make it available, even if it was available.
                    With states, i can do it once and then just check if the state was changed (basically if i used the ability).
                ]]--
                if states[id].jumpState == false and ostime - cooldowns[id].lastJumpTime > JUMPCOOLDOWN then
                    states[id].jumpState = true
                    removeImage(imgs[id].jumpButtonId)
                    imgs[id].jumpButtonId = addImage(JUMP_BTN_ON, "&1", JUMP_BTN_X, JUMP_BTN_Y, playerName)
                end
                if states[id].dashState == false and ostime - cooldowns[id].lastDashTime > DASHCOOLDOWN then
                    states[id].dashState = true
                    removeImage(imgs[id].dashButtonId)
                    imgs[id].dashButtonId = addImage(DASH_BTN_ON, "&1", DASH_BTN_X, DASH_BTN_Y, playerName)
                end

                -- Don't forget i have 3 states for rewind, this happens if we are in state 2 (can rewind) but passed the time we had.
                if cooldowns[id].canRewind == true and ostime - cooldowns[id].checkpointTime > 3000 then
                    cooldowns[id].canRewind = false
                    cooldowns[id].lastRewindTime = ostime
                    removeImage(imgs[id].mouseImgId)
                    showRewindParticles(2, playerName, playerVars[id].rewindPos[1], playerVars[id].rewindPos[2])
                end

                if cooldowns[id].canRewind == true and states[id].rewindState ~= 2 then
                    states[id].rewindState = 2
                    removeImage(imgs[id].rewindButtonId)
                    imgs[id].rewindButtonId = addImage(REWIND_BTN_ACTIVE, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)
                elseif cooldowns[id].canRewind == false and states[id].rewindState ~= 1 and ostime - cooldowns[id].lastRewindTime > REWINDCOOLDONW then
                    states[id].rewindState = 1
                    removeImage(imgs[id].rewindButtonId)
                    imgs[id].rewindButtonId = addImage(REWIND_BTN_ON, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)
                elseif states[id].rewindState ~= 3 and ostime - cooldowns[id].lastRewindTime <= REWINDCOOLDONW then
                    states[id].rewindState = 3
                    removeImage(imgs[id].rewindButtonId)
                    imgs[id].rewindButtonId = addImage(REWIND_BTN_OFF, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)
                end
            end
        end
    end
end

-- PLAYER COLOR SETTER
function eventPlayerRespawn(playerName)
    local ostime = os.time()
    id = playerId(playerName)
    -- We kill souris
    if id == 0 then
        killPlayer(playerName)
        return
    end
    setColor(playerName)

    -- UPDATE COOLDOWNS
    cooldowns[id].lastJumpTime = ostime - JUMPCOOLDOWN
    cooldowns[id].lastDashTime = ostime - DASHCOOLDOWN
    cooldowns[id].lastRewindTime = ostime - 6000
    cooldowns[id].checkpointTime = 0
    cooldowns[id].canRewind = false
    -- WHEN RESPAWNED, MAKE THE ABILITIES GREEN
    removeImage(imgs[id].jumpButtonId)
    imgs[id].jumpButtonId = addImage(JUMP_BTN_ON, "&1", JUMP_BTN_X, JUMP_BTN_Y, playerName)

    removeImage(imgs[id].dashButtonId)
    imgs[id].dashButtonId = addImage(DASH_BTN_ON, "&1", DASH_BTN_X, DASH_BTN_Y, playerName)
end

function setColor(playerName)
    id = playerId(playerName)
    local color = 0x40a594
    -- IF BEST TIME
    if playerName == fastestplayer then
        color = 0xEB1D51
    -- ELSEIF FINISHED
    elseif playerVars[id].playerFinished == true then
        color = 0xBABD2F
    end

    if modRoom[playerName] == true then
        color = 0x2E72CB
    end

    setNameColor(playerName, color)
end

-- PLAYER WIN
function eventPlayerWon(playerName, timeElapsed, timeElapsedSinceRespawn)
    local id = playerId(playerName)

    if imgs[id].mouseImgId ~= nil then
        removeImage(imgs[id].mouseImgId)
    end

    -- If we're a mod, then we don't count the win
    if modRoom[playerName] == true or opList[playerName] == true then
        return
    end

    playerStats[id].timesEnteredInHole = playerStats[id].timesEnteredInHole + 1

    -- SEND CHAT MESSAGE FOR PLAYER
    chatMessage(translations[playerVars[id].playerLanguage].finishedInfo.."(<V>"..(timeElapsedSinceRespawn/100).."s</V>)", playerName)

    if playerVars[id].playerFinished == false then
        playerStats[id].mapsFinished = playerStats[id].mapsFinished + 1
        if mapDiff == 6 then
            playerStats[id].hardcoreMaps = playerStats[id].hardcoreMaps + 1
        end
        playerWon = playerWon + 1
    end

    setPlayerScore(playerName, 1, true)
    -- RESET TIMERS
    playerVars[id].playerLastTime = timeElapsedSinceRespawn
    playerVars[id].playerFinished = true
    playerVars[id].playerBestTime = math.min(playerVars[id].playerBestTime, timeElapsedSinceRespawn)

    --[[
        If the player decides to leave and come back, we need to have his best time saved in a separate array.
        This array will be used for stats at the end of the round, so it must work even if the player left,
        came back, and had worse best time.
    ]]--
    local foundvalue = false
    for i = 1, #playerSortedBestTime do
        if playerSortedBestTime[i][1] == playerName then
            playerSortedBestTime[i][2] = math.min(playerVars[id].playerBestTime, playerSortedBestTime[i][2])
            foundvalue = true
        end
    end
    -- If this is the first time the player finishes the map, we take it as a best time.
    if foundvalue == false then
        table.insert(playerSortedBestTime, {playerName, playerVars[id].playerBestTime})
    end

    -- UPDATE "YOUR TIME"
    ui.updateTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[id].playerLanguage].lastTime..": "..(timeElapsedSinceRespawn/100).."s", playerName)
    ui.updateTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[id].playerLanguage].lastBestTime..": "..(playerVars[id].playerBestTime/100).."s", playerName)

    -- bestTime is a global variable for record
    if timeElapsedSinceRespawn <= bestTime then
        bestTime = timeElapsedSinceRespawn

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
            local message = "<font color='#CB546B'>"..fastestplayer..translations[playerVars[_id].playerLanguage].newRecord.." ("..(bestTime/100).."s)</font>"
            chatMessage(message, index)
            --print(message)
        end
    end
end

function eventPlayerLeft(playerName)
    -- Throws an error if i retrieve playerId from room
    local id = playerIds[playerName]
    for player, data in pairs(room.playerList) do
        removeTextArea(id, player)
    end

    -- We don't count souris
    if string.find(playerName, '*') then
        return
    end
    playerCount = playerCount - 1
end

-- CALL THIS WHEN A PLAYER FIRST JOINS A ROOM
function initPlayer(playerName)
    -- ID USED FOR PLAYER OBJECTS
    local id = room.playerList[playerName].id

    -- IGNORE SOURIS
    if id == 0 then
        killPlayer(playerName)
        return
    end

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
    playerCount = playerCount + 1

    -- RESET SCORE
    setPlayerScore(playerName, 0)

    -- INIT PLAYER OBJECTS
    cooldowns[id] = {
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

    playerVars[id] = {
        playerBestTime = 999999,
        playerLastTime = 999999,
        playerPreferences = {true, true, false, false},
        playerLanguage = "en",
        playerFinished = false,
        rewindPos = {0, 0},
        menuPage = 0,
        helpOpen = false,
        joinTime = os.time()
    }

    -- If the player finished
    for key, value in pairs(playerSortedBestTime) do
        if key == playerName then
            playerVars[id].playerFinished = true
        end
    end

    playerStats[id] = {
        playtime = 0,
        mapsFinished = 0,
        mapsFinishedFirst = 0,
        timesEnteredInHole = 0,
        graffitiSprays = 0,
        timesDashed = 0,
        timesRewinded = 0,
        hardcoreMaps = 0,
        equipment = {2, 3, 1, 3}
    }
    if playerName ~= "Extremq#0000" then
        playerStats[id].equipment = {1, 1, 1, 1}
    end
 
    states[id] = {
        jumpState = true,
        dashState = true,
        rewindState = 1
    }

    local jmpid = addImage(JUMP_BTN_ON, "&1", JUMP_BTN_X, JUMP_BTN_Y, playerName)
    local dshid = addImage(DASH_BTN_ON, "&1", DASH_BTN_X, DASH_BTN_Y, playerName)
    local rwdid = addImage(REWIND_BTN_ON, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)
    local hlpid = addImage(HELP_IMG, ":100", 114, 23, playerName)
    addTextArea(10, "<a href='event:CloseWelcome'><font color='transparent'>\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n <font></a>", playerName, 129, 29, 541, 342, 0x324650, 0x000000, 0, true)

    imgs[id] = {
        jumpButtonId = jmpid,
        dashButtonId = dshid,
        rewindButtonId = rwdid,
        helpImgId = hlpid,
        helpImgId = hlpid,
        mouseImgId = nil,
        menuImgId = -1,
        shopWelcomeDash = nil,
        shopWelcomeGraffiti = nil,
        graffitiImg = nil
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
end

function generateHud(playerName)
    local id = playerId(playerName)

    removeTextArea(6, playerName)
    -- GENERATE UI
    addTextArea(6, translations[playerVars[id].playerLanguage].helpToolTip, playerName, 267, 382, 265, 18, 0x324650, 0x000000, 0, true)

    -- SEND HELP message
    chatMessage(translations[playerVars[id].playerLanguage].welcomeInfo.."\n"..translations[playerVars[id].playerLanguage].devInfo, playerName)
end

function chooselang(playerName)
    local id = playerId(playerName)
    local community = room.playerList[playerName].community
    -- FOR NOW, ONLY RO AND FR HAVE TRANSLATIONS
    if community == "ro" then
        playerVars[id].playerLanguage = "ro"
    elseif community == "fr" then
        playerVars[id].playerLanguage = "fr"
    else
        playerVars[id].playerLanguage = "en"
    end

    --print(translations[playerVars[id].playerLanguage].welcomeInfo)
    --print(translations[playerVars[id].playerLanguage].devInfo)
end

-- WHEN SOMEBODY JOINS, INIT THE PLAYER
function eventNewPlayer(playerName)
    initPlayer(playerName)
end

-- INIT ALL EXISTING PLAYERS
for playerName in pairs(room.playerList) do
    initPlayer(playerName)
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
            if imgs[id].menuImgId == -1 then
                addTextArea(12, "<font color='#E9E9E9' size='10'><a href='event:ShopOpen'>             "..translations[playerVars[id].playerLanguage].shopTitle.."</a>\n\n\n\n<a href='event:StatsOpen'>             "..translations[playerVars[id].playerLanguage].profileTitle.."</a>\n\n\n\n<a href='event:LeaderOpen'>             "..translations[playerVars[id].playerLanguage].leaderboardsTitle.."</a>\n\n\n\n<a href='event:SettingsOpen'>             "..translations[playerVars[id].playerLanguage].settingsTitle.."</a>\n\n\n\n<a href='event:AboutOpen'>             "..translations[playerVars[id].playerLanguage].aboutTitle.."</a>", playerName, 13, 103, 184, 220, 0x324650, 0x000000, 0, true)
                imgs[id].menuImgId = addImage(MENU_BUTTONS, ":10", MENU_BTN_X, MENU_BTN_Y, playerName)
            else
                closePage(playerName)
            end
        end
    end
end

--[[
    The way i manage UI in this module is basically this:
    Every page of the UI is the same textarea.
    When i open something for the first time, i use createPage.
    When i open something and already have some ui active, i use updatePage.
    This way i have standard UI and never have conflicts.
]]--
function pageOperation(title, body, playerName, pageId)
    local id = playerId(playerName)
    if playerVars[id].menuPage ~= "help" then
        playerVars[id].helpOpen = false
    end
    local closebtn = "<p align='center'><font color='#CB546B'><a href='event:CloseMenu'>"..translations[playerVars[id].playerLanguage].Xbtn.."</a></font></p>"

    local spaceLength = 40 - #translations[playerVars[id].playerLanguage].Xbtn - #title
    local padding = ""
    for i = 1, spaceLength do
        padding = padding.." "
    end
    local pageTitle = "<font size='16' face='Lucida Console'>"..title.."<textformat>"..padding.."</textformat>"..closebtn.."</font>\n"
    local pageBody = body
    playerVars[id].menuPage = pageId
    return pageTitle..pageBody
end

function createPage(title, body, playerName, pageId)
    ui.addTextArea(13, pageOperation(title, body, playerName, pageId), playerName, 198, 50, 405, 300, 0x241f13, 0xbfa26d, 1, true)
end

function updatePage(title, body, playerName, pageId)
    ui.updateTextArea(13, pageOperation(title, body, playerName, pageId), playerName)
end

function closePage(playerName)
    local id = playerId(playerName)
    removeTextArea(13, playerName)
    removeTextArea(12, playerName)
    removeImage(imgs[id].menuImgId)
    playerVars[id].menuPage = 0
    playerVars[id].helpOpen = false
    imgs[id].menuImgId = -1
end

--This returns the body of the profile screen, generating the stats of the selected player's profile.
function stats(playerName, playerId, creatorId)
    local body = "\n"

    local seconds = math.floor((os.time() - playerVars[playerId].joinTime) / 1000)

    body = body.." » "..translations[playerVars[creatorId].playerLanguage].playtime..": <R>"..math.floor(seconds/3600).."</R>h <R>"..math.floor(seconds%3600/60).."</R>m <R>"..(seconds%3600%60).."</R>s\n"
    body = body.." » "..translations[playerVars[creatorId].playerLanguage].firsts..": <R>"..playerStats[playerId].mapsFinishedFirst.."</R>\n"
    body = body.." » "..translations[playerVars[creatorId].playerLanguage].finishedMaps..": <R>"..playerStats[playerId].mapsFinished.."</R>\n"
    local firstrate = "0%"
    if playerStats[playerId].mapsFinishedFirst > 0 then
        firstrate = (math.floor(playerStats[playerId].mapsFinishedFirst/playerStats[playerId].mapsFinished * 10000) / 100).."%"
    end
    body = body.." » "..translations[playerVars[creatorId].playerLanguage].firstRate..": <R>"..firstrate.."</R>\n"
    body = body.." » "..translations[playerVars[creatorId].playerLanguage].holeEnters..": <R>"..playerStats[playerId].timesEnteredInHole.."</R>\n"
    body = body.." » "..translations[playerVars[creatorId].playerLanguage].graffitiUses..": <R>"..playerStats[playerId].graffitiSprays.."</R>\n"
    body = body.." » "..translations[playerVars[creatorId].playerLanguage].dashUses..": <R>"..playerStats[playerId].timesDashed.."</R>\n"
    body = body.." » "..translations[playerVars[creatorId].playerLanguage].rewindUses..": <R>"..playerStats[playerId].timesRewinded.."</R>\n"
    body = body.." » "..translations[playerVars[creatorId].playerLanguage].hardcoreMaps..": <R>"..playerStats[playerId].hardcoreMaps.."</R>\n"

    return body
end

-- This generates the settings body
function remakeOptions(playerName)
    -- REMAKE OPTIONS TEXT (UPDATE YES - NO)
    local id = playerId(playerName)


    toggles = {}
    for i = 1, #playerVars[id].playerPreferences do
        if playerVars[id].playerPreferences[i] == true then
            toggles[i] = translations[playerVars[id].playerLanguage].optionsYes
        else
            toggles[i] = translations[playerVars[id].playerLanguage].optionsNo
        end
    end

    local body = " » <a href=\"event:ToggleGraffiti\">"..translations[playerVars[id].playerLanguage].graffitiSetting.."?</a> "..toggles[1].."\n » <a href=\"event:ToggleDashPart\">"..translations[playerVars[id].playerLanguage].particlesSetting.."?</a> "..toggles[2].."\n » <a href=\"event:ToggleTimePanels\">"..translations[playerVars[id].playerLanguage].timePanelsSetting.."?</a> "..toggles[3]
    body = body.."\n » <a href=\"event:ToggleGlobalChat\">"..translations[playerVars[id].playerLanguage].globalChatSetting.."?</a> "..toggles[4].."\n"
    return body
end

-- This only is the welcome screen :D
function generateShopWelcome(playerName)
    local id = playerId(playerName)
    local dashX, dashY = 255, 150

    imgs[id].shopWelcomeDash = addImage(shop.dashAcc[playerStats[id].equipment[1]].imgId, "&2", dashX, dashY, playerName)

    local body = "\n\n\n\n<font face='Lucida Console' size='16'><p align='center'><CS>Your loadout!</CS></p></font>\n\n\n\n\n\n\n\n\n<font face='Lucida Console' size='16'><textformat>       <textformat><a href='event:ChangePart'>[change]</a><textformat>         <textformat><a href='event:ChangeGraffiti'>[change]</a></font>\n\n\n"
    return body
end

function closeMenu(playerName)
    local id = playerId(playerName)
    removeImage(imgs[id].shopWelcomeDash, playerName)
    local graffitiTextOffset = 1000000000
    removeTextArea(id + graffitiTextOffset, playerName)
end

function eventTextAreaCallback(textAreaId, playerName, eventName)
    local id = playerId(playerName)
    if id == 0 then
        return
    end

    -- 12 is the id for the menu buttons
    if textAreaId == 12 then
        if eventName == "ShopOpen" then
            if playerVars[id].menuPage == 0 then
                createPage(translations[playerVars[id].playerLanguage].shopTitle, generateShopWelcome(playerName), playerName, "shop")
            else
                updatePage(translations[playerVars[id].playerLanguage].shopTitle, generateShopWelcome(playerName), playerName, "shop")
            end
            local graffitiTextX, graffitiTextY, graffitiTextOffset = 365, 185, 1000000000
            ui.addTextArea(id + graffitiTextOffset, "<p align='center'><font face='"..shop.graffitiFonts[playerStats[id].equipment[4]].imgId.."' size='16' color='"..shop.graffitiCol[playerStats[id].equipment[2]].imgId.."'>"..playerName.."</font></p>", playerName, graffitiTextX, graffitiTextY, 230, 25, 0x324650, 0x000000, 0, true)
        end
        if eventName == "StatsOpen" then
            if playerVars[id].menuPage == 0 then
                createPage(translations[playerVars[id].playerLanguage].profileTitle.." - "..playerName, stats(playerName, id, id), playerName, "profile")
            else
                updatePage(translations[playerVars[id].playerLanguage].profileTitle.." - "..playerName, stats(playerName, id, id), playerName, "profile")
            end
        end
        if eventName == "LeaderOpen" then
            if playerVars[id].menuPage == 0 then
                createPage(translations[playerVars[id].playerLanguage].leaderboardsTitle, translations[playerVars[id].playerLanguage].leaderboardsNotice, playerName, "leaderboards")
            else
                updatePage(translations[playerVars[id].playerLanguage].leaderboardsTitle, translations[playerVars[id].playerLanguage].leaderboardsNotice, playerName, "leaderboards")
            end
        end
        if eventName == "SettingsOpen" then
            if playerVars[id].menuPage == 0 then
                createPage(translations[playerVars[id].playerLanguage].settingsTitle, remakeOptions(playerName), playerName, "settings")
            else
                updatePage(translations[playerVars[id].playerLanguage].settingsTitle, remakeOptions(playerName), playerName, "settings")
            end
        end
        if eventName == "AboutOpen" then
            if playerVars[id].menuPage == 0 then
                createPage(translations[playerVars[id].playerLanguage].aboutTitle, translations[playerVars[id].playerLanguage].aboutBody.."\n\n\n\n\n\n<p align='right'><G>version: "..VERSION.."</G></p>", playerName, "about")
            else
                updatePage(translations[playerVars[id].playerLanguage].aboutTitle, translations[playerVars[id].playerLanguage].aboutBody.."\n\n\n\n\n\n<p align='right'><G>version: "..VERSION.."</G></p>", playerName, "about")
            end
        end
    end

    -- SETTINGS PAGE
    if playerVars[id].menuPage == "settings" and textAreaId == 13 then
        if eventName == "ToggleGraffiti" then
            if playerVars[id].playerPreferences[1] == true then
                playerVars[id].playerPreferences[1] = false
                -- Remove graffitis
                for player, data in pairs(room.playerList) do
                    removeTextArea(data.id, player)
                end
            else
                playerVars[id].playerPreferences[1] = true
            end
        elseif eventName == "ToggleDashPart" then
            if playerVars[id].playerPreferences[2] == true then
                playerVars[id].playerPreferences[2] = false
            else
                playerVars[id].playerPreferences[2] = true
            end
        elseif eventName == "ToggleTimePanels" then
            if playerVars[id].playerPreferences[3] == true then
                playerVars[id].playerPreferences[3] = false
                removeTextArea(5, playerName)
                removeTextArea(4, playerName)
            else
                -- REGENERATE PANELS
                playerVars[id].playerPreferences[3] = true
                addTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[id].playerLanguage].lastTime..": N/A", playerName, 10, 45, 200, 21, 0xffffff, 0x000000, 0, true)
                addTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[id].playerLanguage].lastBestTime..": N/A", playerName, 10, 30, 200, 21, 0xffffff, 0x000000, 0, true)
                if playerVars[id].playerFinished == true then
                    ui.updateTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[id].playerLanguage].lastTime..": "..(playerVars[id].playerLastTime/100).."s", playerName)
                    ui.updateTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[id].playerLanguage].lastBestTime..": "..(playerVars[id].playerBestTime/100).."s", playerName)
                end
            end
        elseif eventName == "ToggleGlobalChat" then
            if playerVars[id].playerPreferences[4] == true then
                playerVars[id].playerPreferences[4] = false
            else
                playerVars[id].playerPreferences[4] = true
            end
        end
        updatePage(translations[playerVars[id].playerLanguage].settingsTitle, remakeOptions(playerName), playerName, "settings")
    end

    if eventName == "CloseMenu" then
        closePage(playerName)
        closeMenu(playerName)
    end

    if eventName == "CloseWelcome" then
        if imgs[id].helpImgId ~= 0 then
            removeImage(imgs[id].helpImgId)
        end
        removeTextArea(10, playerName)
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
    ]]--
    for index, value in pairs(playerVars) do
        playerVars[index].playerBestTime = 999999
        playerVars[index].playerBestTime = 999999
    end

    -- Close stats if they have it opened
    for name, value in pairs(room.playerList) do
        local _id = value.id
        if playerVars[_id].menuPage == "roomStats" then
            closePage(name)
        end
    end

    for playerName in pairs(room.playerList) do
        local id = playerId(playerName)
        if id ~= 0 then
            --print("Resetting stats for"..playerName)
            setPlayerScore(playerName, 0)
            cooldowns[id].lastLeftPressTime = 0
            cooldowns[id].lastRightPressTime = 0
            cooldowns[id].lastJumpPressTime = 0
            playerVars[id].playerFinished = false
            playerVars[id].rewindPos = {0, 0, false}
            setColor(playerName)
            -- REMOVE GRAFFITIS
            removeTextArea(id)
            removeImage(imgs[id].graffitiImg)
            cooldowns[id].lastGraffitiTime = 0
            -- UPDATE THE TEXT
            if playerVars[id].playerPreferences[3] == true then
                ui.updateTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[id].playerLanguage].lastBestTime..": N/A", playerName)
                ui.updateTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..translations[playerVars[id].playerLanguage].lastTime..": N/A", playerName)
            end
        else
            killPlayer(playerName)
        end
    end
    tfm.exec.setGameTime(MAPTIME, true)
end

function eventChatMessage(playerName, msg)
    if room.community ~= "en" then
        return
    end

    local id = playerId(playerName)
    local data = room.playerList[playerName]

    if playerVars[id].playerPreferences[4] == true then
        for name, playerData in pairs(room.playerList) do 
            if playerVars[playerData.id].playerPreferences[4] == true and playerName ~= name and playerData.community ~= data.community then
                print("<V>["..playerData.community.."] ["..playerName.."]</V> <font color='#C2C2DA'>"..msg.."</font>")
                chatMessage("<V>["..playerData.community.."] ["..playerName.."]</V> <font color='#C2C2DA'>"..msg.."</font>", name)
            end
        end
    end
end

-- Chat commands
function eventChatCommand(playerName, message)
    local id = playerId(playerName)
    local ostime = os.time()
    local arg = {}
    for argument in message:gmatch("[^%s]+") do
        table.insert(arg, argument)
    end

    arg[1] = string.lower(arg[1])

    local isValid = false
    local isOp = false
    local isMod = false

    if modList[playerName] == true then
        isMod = true
        isOp = true
    end

    if opList[playerName] == true then
        isOp = true
    end

    if admin == playerName and customRoom == true then
        isOp = true
    end

    -- OP ONLY ABILITIES (INCLUDES MOD)
    if isOp == true then
        if arg[1] == "m" then
            if arg[2] ~= nil then
                isValid = true
                tfm.exec.newGame(arg[2])
                tfm.exec.setAutoMapFlipMode(randomFlip())
                mapDiff = "Custom"
                MAPTIME = 10 * 60
                resetAll()
            end
        end

        if arg[1] == "n" then
            isValid = true
            hasShownStats = false
            mapWasSkipped = true
            bestPlayers = {{"N/A", "N/A", "N/A"}, {"N/A", "N/A", "N/A"}, {"N/A", "N/A", "N/A"}}
        end
    end

    -- MOD ONLY ABILITIES
    if isMod == true then
        if arg[1] == "mod" then
            isValid = true
            if modRoom[playerName] == false then
                modRoom[playerName] = true
                local message = "You are a mod!"
                --print(message)
                chatMessage(message, playerName)
            else
                modRoom[playerName] = false
                local message = "You are no longer a mod!"
                --print(message)
                chatMessage(message, playerName)
            end
            setColor(playerName)
        end

        if arg[1] == "op" then
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
        end

        if arg[1] == "a" then
            isValid = true
            if arg[2] ~= nil then
                for i = 3, #arg do
                    arg[2] = arg[2].." "..arg[i]
                end
                local message = "<font color='#72b6ff'>#ninja Owner "..playerName..": "..arg[2].."</font>"
                --print(message)
                chatMessage(message)
            end
        end
    end

    if arg[1] == "pw" and playerName == admin then
        isValid = true
        if arg[2] ~= nil then
            customRoom = true
            tfm.exec.setRoomPassword(arg[2])
            chatMessage("Password: "..arg[2], playerName)
        else
            customRoom = false
            tfm.exec.setRoomPassword("")
            chatMessage("Password removed.", playerName)
        end
    end

    if arg[1] == "p" or arg[1] == "profile" and arg[2] ~= nil then
        isValid = true
        for name, value in pairs(room.playerList) do
            if name == arg[2] then
                if playerVars[id].menuPage == 0 then
                    createPage(translations[playerVars[id].playerLanguage].profileTitle.." - "..arg[2], stats(arg[2], room.playerList[arg[2]].id, id), playerName, id, "profile")
                else
                    updatePage(translations[playerVars[id].playerLanguage].profileTitle.." - "..arg[2], stats(arg[2], room.playerList[arg[2]].id, id), playerName, id, "profile")
                end
                break
            end
        end
    end

    if arg[1] == "langue" and arg[2] ~= nil then
        for i = 1, #languages do
            if arg[2] == languages[i] then
                playerVars[id].playerLanguage = arg[2]
                generateHud(playerName)
                return
            end
        end
        chatMessage(arg[2].."doesn't exist yet.")
    end

    if isValid == false then
        chatMessage(arg[1].." "..translations[playerVars[id].playerLanguage].notValidCommand, playerName)
    end
end