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

--[[ Directory translations ]]--
--[[ File translations/en.lua ]]--
translations.en = {
    name = "en",
    lastTime = "Your last time",
    lastBestTime = "Your best time",
    helpToolTip = "<p align='center'>Press <b>H</b> for help.</p>",
    optionsYes = "<font color='#53ba58'>Yes</font>",
    optionsNo = "<font color='#f73625'>No</font>",
    graffitiSetting = "Enable graffitis",
    particlesSetting = "Enable dash/jump particles",
    timePanelsSetting = "Enable time panels",
    globalChatSetting = "Enable global chat",
    voteStart = " started a vote to skip the current map. Type !yes to vote positively.",
    newRecord = " finished the map in the fastest time!",
    devInfo = "<V>Want to submit a map? Check this link: https://atelier801.com/topic?f=6&t=888399</V>\n<font color='#CB546B'>This module is in development. Please report any bugs to Extremq#0000 or Railysse#0000.</font>",
    discordInfo = "<BV>Join our discord! https://discord.gg/WawZVaq</BV>",
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
    aboutBody = "Module coded by <font color='#FFD991'>Extremq#0000</font>.\nGameplay ideas, bug-testing and maps provided by <font color='#FFD991'>Railysse#0000</font>.\n\nThis module is fully supported by the mice fundation „Red Cheese” with the „Save Module” project. All funds that we will earn will be donated to mice which play #parkour so we can bribe them to play our module.\n\nWe're just kidding, thank you for trying our module! :D\n\n<p align='center'><font color='#f73625'>&lt;3</font></p>", -- 30
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
    notValidCommand = "is not a valid command.",
    cantSetPass = "Cannot set a password in this room.",
    translator = "Translated by Extremq#0000."
}
--[[ End of file translations/en.lua ]]--
--[[ File translations/es.lua ]]--
translations.es = {
    name = "es",
    lastTime = "Tu último tiempo",
    lastBestTime = "Tu record",
    helpToolTip = "<p align='center'>Presiona <b>H</b> para obtener ayuda.</p>",
    optionsYes = "<font color='#53ba58'>Sí</font>",
    optionsNo = "<font color='#f73625'>No</font>",
    graffitiSetting = "Activar graffitis",
    particlesSetting = "Activar partículas de impulso/salto",
    timePanelsSetting = "Activar paneles de tiempos",
    globalChatSetting = "Activar chat global",
    voteStart = " empezó a votar para saltar el mapa. Escribe !yes para votar.",
    newRecord = " finalizó el mapa con el tiempo más rápido!",
    devInfo = "<V>¿Quieres enviar un mapa? Usa este enlace: https://atelier801.com/topic?f=6&t=888399</V>\n<font color='#CB546B'>El módulo está en desarrollo. Por favor reporta cualquier bug a Extremq#0000 o Railysse#0000.</font>",
    discordInfo = "<BV>¡Únete a nuestro discord! https://discord.gg/WawZVaq</BV>",
    welcomeInfo = "¡Bienvenido a <font color='#E68D43'>#ninja</font>! Presiona <font color='#E68D43'>H</font> para obtener ayuda.",
    finishedInfo = "¡Finalizaste el mapa! Tiempo: ",
    helpBody = "Tienes que traer el queso de vuelta al agujero tan rápido como puedas.\n\n<b>Habilidades</b>:\n» Impulso - Presiona <b><font color='#CB546B'>Izquierda</font></b> o <b><font color='#CB546B'>Derecha</font></b> dos veces. (espera de 1s)\n» Salto - Presiona <b><font color='#CB546B'>Arriba</font></b> dos veces. (espera de 3s)\n» Rebobinar - Presiona <b><font color='#CB546B'>Espacio</font></b> para dejar un checkpoint. Presiona <b><font color='#CB546B'>Espacio</font></b> de nuevo dentro de 3 segundos para teletransportarte al checkpoint. (espera de 10s)\n\n<b>Otros atajos</b>:\n» Matar tu ratón - Presiona <b><font color='#CB546B'>X</font></b> o escribe /mort para matar a tu ratón.\n» Abrir menú - Presionar <b><font color='#CB546B'>M</font></b> o clickea en el lado izquierdo de tu pantalla para abrir/cerrar el menú.\n» Colocar un graffiti - Presiona <b><font color='#CB546B'>C</font></b> para dejar un graffiti. (espera de 60s)\n» Abrir ayuda - Presiona <b><font color='#CB546B'>H</font></b> para abrir/cerrar esta ventana.\n\n<b>Comandos</b>:\n» !p Nombre#id - Ver las estadísticas de otro jugador.\n» !pw Contraseña - Cambiar la contraseña de la sala. (debe ser creada por tí)\n» !m @code - Cargar cualquier mapa que quieras. (la sala debe tener una contraseña)\n» !langue país - Cambiar el lenguaje del módulo. (sólo para tí)\n\n<p align='center'><a href='event:CloseMenu'><b><font color='#CB546B'>Cerrar</font></b></a></p>", --23
    Xbtn = "X",
    -- IF YOUR LANGUAGE HAS SEPCIAL CHARACTERS, PLEASE JUST LEAVE THESE AS DEFAULT
    shopTitle = "Tienda",
    profileTitle = "Perfil",
    leaderboardsTitle = "Rankings",
    settingsTitle = "Configuracion",
    aboutTitle = "Acerca",
    -- END
    aboutBody = "Módulo programado por <font color='#FFD991'>Extremq#0000</font>.\nIdeas de juego, testeo de errores y mapas por <font color='#FFD991'>Railysse#0000</font>.\n\nEste módulo está totalmente respaldado por la fundación de ratones „Red Cheese” con el proyecto „Save Module”. Todas las donaciones que ganemos serán donadas a los ratones que juegan #parkour para sobornarlos y que vengan a jugar nuestro módulo.\n\nSólo estamos bromeando, ¡gracias por jugar nuestro módulo! :D\n\n<p align='center'><font color='#f73625'>&lt;3</font></p>", -- 30
    playtime = "Tiempo de juego",
    firsts = "Firsts",
    finishedMaps = "Mapas completados",
    firstRate = "Porcentaje de firsts",
    holeEnters = "Veces que entró al agujero",
    graffitiUses = "Usos del graffiti",
    dashUses = "Veces que usó un impulso",
    rewindUses = "Veces que rebobinó",
    hardcoreMaps = "Mapas difíciles completados",
    shopNotice = "La tienda está en desarrollo.",
    leaderboardsNotice = "Una tabla de clasificación será implementada cuando el módulo se vuelva oficial.",
    notValidCommand = "no es un comando válido.",
    cantSetPass = "No se puede cambiar la contraseña de esta sala.",
    translator = "Traducido por Tocutoeltuco#0000."
}
--[[ End of file translations/es.lua ]]--
--[[ File translations/fr.lua ]]--
translations.fr = {
    name = "fr",
    lastTime = "La dernière fois",
    lastBestTime = "Votre meilleur temps",
    helpToolTip = "<p align='center'>Appuyez sur <b>H</b> pour de l'aide.</p>",
    optionsYes = "<font color='#53ba58'>Oui</font>",
    optionsNo = "<font color='#f73625'>Non</font>",
    graffitiSetting = "Activer les graffitis",
    particlesSetting = "Activer les particules de boost et de saut",
    timePanelsSetting = "Activer les panneaux de temps",
    globalChatSetting = "Activer la discussion global",
    voteStart = " a comencé un vote pour passer la carte actuelle. Ecrivez !yes pour voter positivement.",
    newRecord = " a fini la carte avec le meilleur temps!",
    devInfo = "<V>Vous voulez proposer une carte? Allez sur ce lien : https://atelier801.com/topic?f=6&t=888399</V>\n<font color='#CB546B'>Ce module est toujours en développement. Merci de signaler tous les bugs à Extremq#0000 ou Railysse#0000.</font>",
    discordInfo = "<BV>Rejoignez le discord! https://discord.gg/WawZVaq</BV>",
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
    aboutBody = "Module codé par <font color='#FFD991'>Extremq#0000</font>.\nIdée de jeu, test des bugs and cartes fournies par <font color='#FFD991'>Railysse#0000</font>.\n\nCe module est complétement soutenu par la fondation „Red Cheese” avec le projet „Save Module”. Tous les revenus que nous recevrons seront directement versées aux joueur qui jouent à #parkour comme ça on les supplie de jouer à notre module.\n\nC'est une blague! Merci d'avoir joué à notre module! :D\n\n<p align='center'><font color='#f73625'>&lt;3</font></p>", -- 30
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
    notValidCommand = "n'est pas une commande valide.",
    cantSetPass = "Impossible d'instaurer un mot de passe dans ce salon.",
    translator = "Traduit par Jaker#9310."
}
--[[ End of file translations/fr.lua ]]--
--[[ File translations/lv.lua ]]--
translations.lv = {
    name = "lv",
    lastTime = "Tavs pēdējais laiks",
    lastBestTime = "Tavs labākais laiks",
    helpToolTip = "<p align='center'>Spied <b>H</b>, lai atvērtu palīdzību.</p>",
    optionsYes = "<font color='#53ba58'>Jā</font>",
    optionsNo = "<font color='#f73625'>Nē</font>",
    graffitiSetting = "Iespējot grafiti",
    particlesSetting = "Iespējot paātrināšanas/lēkšanas efektus",
    timePanelsSetting = "Iespējot laika paneļus",
    globalChatSetting = "Iespējot globālo čatu",
    voteStart = " sāka balsojumu esošās mapes izlaišanai. Raksti !yes, lai balsotu par.",
    newRecord = " pabeidza mapi visīsākajā laikā!",
    devInfo = "<V>Vēlies iesniegt mapi? Skaties šeit: https://atelier801.com/topic?f=6&t=888399</V>\n<font color='#CB546B'>Šis modulis ir izveides procesā. Lūdzu, ziņo par jebkādām kļūdām Extremq#0000 vai Railysse#0000.</font>",
    discordInfo = "<BV>Pievienojies mūsu Discord! https://discord.gg/WawZVaq</BV>",
    welcomeInfo = "Esi sveicināts <font color='#E68D43'>#ninja</font>! Spied <font color='#E68D43'>H</font>, lai atvērtu palīdzību.",
    finishedInfo = "Tu pabeidzi mapi! Laiks: ",
    helpBody = "Tev ir jānogādā siers atpakaļ uz alu, cik vien ātri spēj.\n\n<b>Spējas</b>:\n» Paātrināšana - Nospied <b><font color='#CB546B'>kreiso</font></b> vai <b><font color='#CB546B'>labo bultiņu</font></b> divreiz. (1s noildze)\n» Lēkšana - Nospied <b><font color='#CB546B'>augšējo bultiņu</font></b> divreiz. (3s noildze)\n» Attīt - Nospied <b><font color='#CB546B'>atstarpi</font></b>, lai izveidotu atskaites punktu. Nospied <b><font color='#CB546B'>atstarpi</font></b> vēlreiz 3 sekunžu laikā, lai teleportētos atpakaļ uz to. (10s noildze)\n\n<b>Citi īsceļi</b>:\n» Peles nogalināšana - Nospied <b><font color='#CB546B'>X</font></b> vai ieraksti /mort, lai nogalinātu peli.\n» Atvērt izvēlni - Nospied <b><font color='#CB546B'>M</font></b> vai klikšķini ekrāna kreisajā pusē, lai  atvērtu/aizvērtu izvēlni.\n» Atstāt grafiti - Nospied <b><font color='#CB546B'>C</font></b>, lai atstātu grafiti. (60s noildze)\n» Atvērt palīdzību - Nospied <b><font color='#CB546B'>H</font></b>, lai atvērtu/aizvērtu šo logu.\n\n<b>Komandas</b>:\n» !p Vārds#id - Pārbauda cita spēlētāja statistiku.\n» !pw Parole - Iestata paroli istabai. (istabai ir jābūt tevis veidotai)\n» !m @kods - Ielādē jebkuru mapi, kuru vēlies. (istabai ir jābūt parolei)\n» !langue valsts - Maina moduļa valodu. (tikai tev)\n\n<p align='center'><a href='event:CloseMenu'><b><font color='#CB546B'>Aizvērt</font></b></a></p>", --23
    Xbtn = "X",
    -- IF YOUR LANGUAGE HAS SEPCIAL CHARACTERS, PLEASE JUST LEAVE THESE AS DEFAULT
    shopTitle = "Kolekcija",
    profileTitle = "Profils",
    leaderboardsTitle = "Tablo",
    settingsTitle = "Opcijas",
    aboutTitle = "Par",
    -- END
    aboutBody = "Moduli kodēja <font color='#FFD991'>Extremq#0000</font>.\nIdejas spēlei, kļūdu testēšanu un mapes nodrošināja <font color='#FFD991'>Railysse#0000</font>.\n\nŠo moduli pilnībā atbalsta peļu organizācija „Red Cheese” ar „Save Module” projektu. Visas iegūtās finanses tiks ziedotas pelēm, kuras spēlē #parkour, lai varam piekukuļot viņas spēlēt mūsu moduli.\n\nMēs tikai jokojam, paldies, ka izmēģinājāt mūsu moduli! :D\n\n<p align='center'><font color='#f73625'>&lt;3</font></p>", -- 30
    playtime = "Playtime",
    firsts = "Pirmās vietas",
    finishedMaps = "Pabeigtās mapes",
    firstRate = "Pirmo vietu attiecība",
    holeEnters = "Reizes, cik ieiets alā",
    graffitiUses = "Reizes, cik lietots grafiti",
    dashUses = "Reizes, cik lietota paātrināšana",
    rewindUses = "Reizes, cik lietota attīšana",
    hardcoreMaps = "Pabeigtās „Hardcore” mapes",
    shopNotice = "Veikals ir izveides procesā.",
    leaderboardsNotice = "Rezultātu tablo tiks ieviests, kad modulis kļūs oficiāls.",
    notValidCommand = "nav derīga komanda.",
    cantSetPass = "Nevar iestatīt paroli šajā istabā.",
    translator = "Tulkoja Syrius#8114."
}
--[[ End of file translations/lv.lua ]]--
--[[ File translations/ro.lua ]]--
translations.ro = {
    name = "ro",
    lastTime = "Ultimul timp",
    lastBestTime = "Cel mai bun timp",
    helpToolTip = "<p align='center'>Apasă <b>H</b> pentru ajutor.</p>",
    optionsYes = "<font color='#53ba58'>Da</font>", -- 12
    optionsNo = "<font color='#f73625'>Nu</font>",  -- 13
    graffitiSetting = "Activezi graffitiurile", -- 14
    particlesSetting = "Activezi particulele de dash", -- 15
    timePanelsSetting = "Activezi panourile de timp", -- 16
    globalChatSetting = "Activezi chatul global",
    voteStart = " a inițiat un vot pentru a trece la următoarea mapă. Scrie !yes pentru a vota pozitiv.", -- 18
    newRecord = " a terminat harta cel mai rapid!", --19
    devInfo = "<V>Vrei să faci o hartă pentru acest modul? Întră pe acest link: https://atelier801.com/topic?f=6&t=888399</V>\n<font color='#CB546B'>Acest modul este în curs de dezvoltare. Raportează orice problemă lui Extremq#0000 sau Railysse#0000.</font>", -- 20
    discordInfo = "<BV>Alătură-te discordului nostru! https://discord.gg/WawZVaq</BV>",
    welcomeInfo = "Bine ai venit pe <font color='#E68D43'>#ninja</font>! Apasă <font color='#E68D43'>H</font> pentru ajutor.", -- 21
    finishedInfo = "Ai terminat harta! Timp: ", --22
    helpBody = "Trebuie să aduci brânza înapoi la gaură cât mai rapid posibil.\n\n<b>Abilități</b>:\n» Dash - Apasă <b><font color='#CB546B'>săgeată Stânga</font></b> sau <b><font color='#CB546B'>Dreapta</font></b> de două ori. (reîncărcare 1s)\n» Jump - Apasă <b><font color='#CB546B'>săgeată Sus</font></b> de două ori. (reîncărcare 3s)\n» Rewind - Apasă <b><font color='#CB546B'>Spațiu</font></b> pentru a lăsa un checkpoint. Apasă <b><font color='#CB546B'>Spațiu</font></b> din nou în maximum 3 secunde pentru a te teleporta înapoi la checkpoint. (reîncărcare 10s)\n\n<b>Alte scurtături</b>:\n» Deschide meniul - Apasă <b><font color='#CB546B'>M</font></b> sau dă click în partea stângă a ecranului pentru a închide/deschide meniul.\n» Pune un graffiti - Apasă <b><font color='#CB546B'>C</font></b> pentru a lăsa un graffiti. (reîncărcare 60s\n» Omoară șoricelul - Apasă <b><font color='#CB546B'>X</font></b> sau scrie /mort pentru a omorî șoarecele.\n» Deschide instrucțiunile - Apasă <b><font color='#CB546B'>H</font></b> pentru a deschide/închide acest ecran.\n\n<b>Comenzi</b>:\n» !p Nume#id - Verifică statisticile altui player.\n» !pw Parolă - Pune parolă pe sală. (sala trebuie făcută de tine)\n» !m @cod - Încarcă ce hartă vrei tu. (trebuie ca sala să aibă parolă)\n» !langue țară - Schimbă limba modulului. (doar pentru tine)\n\n<p align='center'><a href='event:CloseMenu'><b><font color='#CB546B'>Închide</font></b></a></p>", --23
    Xbtn = "X", -- 24
    shopTitle = "Colectie", -- 25
    profileTitle = "Profil", -- 26
    leaderboardsTitle = "Clasamente", -- 27
    settingsTitle = "Configurare", -- 28
    aboutTitle = "Despre", -- 29
    aboutBody = "Modul codat de <font color='#FFD991'>Extremq#0000</font>.\nIdei de joc, bug-testing și hărți asigurate de <font color='#FFD991'>Railysse#0000</font>.\n\nAcest modul este susținut în întregime de fundația șoricească „Brânza Roșie” în cadrul proiectului „Salvați Module”. Toate fondurile pe care le primim vor fi donate șoarecilor care stau pe #parkour cu scopul de a-i mitui să vină aici.\n\nGlumim, mulțumim că ne-ai încercat jocul! :D\n\n<p align='center'><font color='#f73625'>&lt;3</font></p>", -- 30
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
    notValidCommand = "nu este o comandă validă.",
    cantSetPass = "Nu se poate seta o parolă pe această sală.",
    translator = "Tradus de Extremq#0000."
}
--[[ End of file translations/ro.lua ]]--
--[[ End of directory translations ]]--

--[[ File maps.lua ]]--
--[[
    name: maps.lua
    description: Contains the maps.
]]--


-- Standard maps
stMapCodes = {{"@7725753", 3}, {"@7726015", 1}, {"@7726744", 2}, {"@7728063", 4}, {"@7731641", 2}, {"@7730637", 3}, {"@7732486", 2}, {"@6784223", 4}, {"@7734262", 3}, {"@7735744", 3}, {"@7735771", 3}}
stMapsLeft = {{"@7725753", 3}, {"@7726015", 1}, {"@7726744", 2}, {"@7728063", 4}, {"@7731641", 2}, {"@7730637", 3}, {"@7732486", 2}, {"@6784223", 4}, {"@7734262", 3}, {"@7735744", 3}, {"@7735771", 3}}

-- Hardcore maps
hcMapCodes = {{"@7733773", 6}, {"@7733777", 6}, {"@7734451", 6}}
hcMapsLeft = {{"@7733773", 6}, {"@7733777", 6}, {"@7734451", 6}}
--[[ End of file maps.lua ]]--

--[[ File mapUtils.lua ]]--
--[[
    name: mapUtils.lua
    description: Contains functions that help with the map picker algorithm and title setter.
]]--

MAPTIME = 4 * 60 + 3
BASETIME = MAPTIME -- after difficulty

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
--[[ End of file mapUtils.lua ]]--

--[[ File vars.lua ]]--
--[[
    name: vars.lua
    description: contains all player and map variables (shop, player structures and map vars)
]]--


function shopListing(values, imgId, tooltip, reqs)
    return {
        ['values'] = values,
        ['imgId'] = imgId,
        ['tooltip'] = tooltip,
        ['reqs'] = reqs
    }
end

modList = {['Extremq#0000'] = true, ['Railysse#0000'] = true}
modRoom = {}
opList = {}
lastMap = ""
mapWasSkipped = false
mapStartTime = 0
mapDiff = 0
mapCount = 1
globalPlayerCount = 0
fastestplayer = -1
playerSortedBestTime = {}
playerCount = 0
playerWon = 0
mapfinished = false
admin = ""
customRoom = false
hasShownStats = false
bestTime = 99999

keys = {0, 1, 2, 3, 32, 67, 71, 72, 77, 84, 88}

shop = {
    dashAcc = {
        shopListing({3}, "172a424f181.png", "This is the default particle.", "Free."),
        shopListing({3, 31}, "172a424da0e.png", "Add some hearts to your dash!", "Secret."),
        shopListing({3, 13}, "172a42508f4.png", "Sleek. Just like you.", "Finish 1 map first.")
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
loaded = {}
inRoom = {}

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
--[[ End of file vars.lua ]]--

--[[ File abilities.lua ]]--
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
        if imgs[playerName].menuImgId == nil then
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
            if imgs[playerName].menuImgId == nil then
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
            if inRoom[playerName] ~= nil and loaded[playerName] ~= nil then 
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
end
--[[ End of file abilities.lua ]]--

--[[ File events.lua ]]--
--[[
    name: events.lua
    description: Contains playerRespawn, playerDied, playerWon, playerLeft and playerJoined
]]--


-- PLAYER COLOR SETTER
function eventPlayerRespawn(playerName)
    local ostime = os.time()
    id = playerId(playerName)
    setColor(playerName)

    -- UPDATE COOLDOWNS
    cooldowns[playerName].lastJumpTime = ostime - JUMPCOOLDOWN
    cooldowns[playerName].lastDashTime = ostime - DASHCOOLDOWN
    cooldowns[playerName].lastRewindTime = ostime - 6000
    cooldowns[playerName].checkpointTime = 0
    cooldowns[playerName].canRewind = false
    -- WHEN RESPAWNED, MAKE THE ABILITIES GREEN
    removeImage(imgs[playerName].jumpButtonId)
    imgs[playerName].jumpButtonId = addImage(JUMP_BTN_ON, "&1", JUMP_BTN_X, JUMP_BTN_Y, playerName)

    removeImage(imgs[playerName].dashButtonId)
    imgs[playerName].dashButtonId = addImage(DASH_BTN_ON, "&1", DASH_BTN_X, DASH_BTN_Y, playerName)
end

function eventPlayerDied(playerName)
    local id = playerId(playerName)
    playerVars[playerName].rewindPos = {0, 0, false}
    -- Remove rewind Mouse
    if imgs[playerName].mouseImgId ~= nil then
        removeImage(imgs[playerName].mouseImgId)
    end
end

-- PLAYER WIN
function eventPlayerWon(playerName, timeElapsed, timeElapsedSinceRespawn)
    local id = playerId(playerName)

    if imgs[playerName].mouseImgId ~= nil then
        removeImage(imgs[playerName].mouseImgId)
    end

    -- If we're a mod, then we don't count the win
    if modRoom[playerName] == true or opList[playerName] == true then
        return
    end

    playerStats[playerName].timesEnteredInHole = playerStats[playerName].timesEnteredInHole + 1

    -- SEND CHAT MESSAGE FOR PLAYER
    chatMessage(playerVars[playerName].playerLanguage.finishedInfo.."(<V>"..(timeElapsedSinceRespawn/100).."s</V>)", playerName)

    if playerVars[playerName].playerFinished == false then
        playerStats[playerName].mapsFinished = playerStats[playerName].mapsFinished + 1
        if mapDiff == 6 then
            playerStats[playerName].hardcoreMaps = playerStats[playerName].hardcoreMaps + 1
        end
        playerWon = playerWon + 1
    end

    setPlayerScore(playerName, 1, true)
    -- RESET TIMERS
    playerVars[playerName].playerLastTime = timeElapsedSinceRespawn
    playerVars[playerName].playerFinished = true
    playerVars[playerName].playerBestTime = math.min(playerVars[playerName].playerBestTime, timeElapsedSinceRespawn)

    --[[
        If the player decides to leave and come back, we need to have his best time saved in a separate array.
        This array will be used for stats at the end of the round, so it must work even if the player left,
        came back, and had worse best time.
    ]]--
    local foundvalue = false
    for i = 1, #playerSortedBestTime do
        if playerSortedBestTime[i][1] == playerName then
            playerSortedBestTime[i][2] = math.min(playerVars[playerName].playerBestTime, playerSortedBestTime[i][2])
            foundvalue = true
        end
    end
    -- If this is the first time the player finishes the map, we take it as a best time.
    if foundvalue == false then
        table.insert(playerSortedBestTime, {playerName, playerVars[playerName].playerBestTime})
    end

    -- UPDATE "YOUR TIME"
    ui.updateTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..playerVars[playerName].playerLanguage.lastTime..": "..(timeElapsedSinceRespawn/100).."s", playerName)
    ui.updateTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..playerVars[playerName].playerLanguage.lastBestTime..": "..(playerVars[playerName].playerBestTime/100).."s", playerName)

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
            local message = "<font color='#CB546B'>"..fastestplayer..playerVars[index].playerLanguage.newRecord.." ("..(bestTime/100).."s)</font>"
            chatMessage(message, index)
            --print(message)
        end
    end
end

function eventPlayerLeft(playerName)
    inRoom[playerName] = nil
    loaded[playerName] = nil
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

-- WHEN SOMEBODY JOINS, INIT THE PLAYER
function eventNewPlayer(playerName)
    inRoom[playerName] = true
    loaded[playerName] = nil
    initPlayer(playerName)
end
--[[ End of file events.lua ]]--

--[[ File initialization.lua ]]--
--[[
    name: initialization.lua
    description: Inits player variables, color, hud, language
]]--

function setColor(playerName)
    id = playerId(playerName)
    local color = 0x40a594
    -- IF BEST TIME
    if playerName == fastestplayer then
        color = 0xEB1D51
    -- ELSEIF FINISHED
    elseif playerVars[playerName].playerFinished == true then
        color = 0xBABD2F
    end

    if modRoom[playerName] == true then
        color = 0x2E72CB
    end

    setNameColor(playerName, color)
end

-- CALL THIS WHEN A PLAYER FIRST JOINS A ROOM
function initPlayer(playerName)
    -- ID USED FOR PLAYER OBJECTS
    local id = room.playerList[playerName].id

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
    cooldowns[playerName] = {
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

    playerVars[playerName] = {
        playerBestTime = 999999,
        playerLastTime = 999999,
        playerPreferences = {true, true, false, true},
        playerLanguage = "en",
        playerFinished = false,
        rewindPos = {0, 0},
        menuPage = 0,
        helpOpen = false,
        joinTime = os.time()
    }

    -- If the player finished
    for key, value in pairs(playerSortedBestTime) do
        if value[1] == playerName then
            playerVars[playerName].playerFinished = true
        end
    end

    playerStats[playerName] = {
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
        playerStats[playerName].equipment = {1, 1, 1, 1}
    end
 
    states[playerName] = {
        jumpState = true,
        dashState = true,
        rewindState = 1
    }

    local jmpid = addImage(JUMP_BTN_ON, "&1", JUMP_BTN_X, JUMP_BTN_Y, playerName)
    local dshid = addImage(DASH_BTN_ON, "&1", DASH_BTN_X, DASH_BTN_Y, playerName)
    local rwdid = addImage(REWIND_BTN_ON, "&1", REWIND_BTN_X, REWIND_BTN_Y, playerName)
    local hlpid = addImage(HELP_IMG, ":100", 114, 23, playerName)
    addTextArea(10, "<a href='event:CloseWelcome'><font color='transparent'>\n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n <font></a>", playerName, 129, 29, 541, 342, 0x324650, 0x000000, 0, true)

    imgs[playerName] = {
        jumpButtonId = jmpid,
        dashButtonId = dshid,
        rewindButtonId = rwdid,
        helpImgId = hlpid,
        helpImgId = hlpid,
        mouseImgId = nil,
        menuImgId = nil,
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
    loaded[playerName] = true
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
        if playerVars[name].menuPage == "roomStats" then
            closePage(name)
        end
    end

    for playerName in pairs(room.playerList) do
        local id = playerId(playerName)
        --print("Resetting stats for"..playerName)
        setPlayerScore(playerName, 0)
        cooldowns[playerName].lastLeftPressTime = 0
        cooldowns[playerName].lastRightPressTime = 0
        cooldowns[playerName].lastJumpPressTime = 0
        playerVars[playerName].playerFinished = false
        playerVars[playerName].rewindPos = {0, 0, false}
        setColor(playerName)
        -- REMOVE GRAFFITIS
        if id ~= 0 then
            removeTextArea(id)
            cooldowns[playerName].lastGraffitiTime = 0
        end 
        -- UPDATE THE TEXT
        if playerVars[playerName].playerPreferences[3] == true then
            ui.updateTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..playerVars[playerName].playerLanguage.lastBestTime..": N/A", playerName)
            ui.updateTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..playerVars[playerName].playerLanguage.lastTime..": N/A", playerName)
        end
    end
    tfm.exec.setGameTime(MAPTIME, true)
end

function chooselang(playerName)
    local id = playerId(playerName)
    local community = room.playerList[playerName].community
    
    if translations[community] ~= nil then
        playerVars[playerName].playerLanguage = translations[community]
    else
        playerVars[playerName].playerLanguage = translations["en"]
    end
end

function generateHud(playerName)
    local id = playerId(playerName)

    removeTextArea(6, playerName)
    -- GENERATE UI
    addTextArea(6, playerVars[playerName].playerLanguage.helpToolTip, playerName, 267, 382, 265, 18, 0x324650, 0x000000, 0, true)

    -- SEND HELP message
    chatMessage(playerVars[playerName].playerLanguage.welcomeInfo.."\n"..playerVars[playerName].playerLanguage.devInfo.."\n"..playerVars[playerName].playerLanguage.discordInfo, playerName)   
end
--[[ End of file initialization.lua ]]--

--[[ File ui.lua ]]--
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
HIDDEN_DASH = "172a4a7795e.png"

--[[
    The way i manage UI in this module is basically this:
    Every page of the UI is the same textarea.
    I just call openPage and it will update/create on demand.
    This way i have standard UI and never have conflicts.
]]--
function pageOperation(title, body, playerName, pageId)
    clear(playerName)
    local id = playerId(playerName)
    local closebtn = "<font color='#CB546B'><a href='event:CloseMenu'>"..playerVars[playerName].playerLanguage.Xbtn.."</a></font>"

    local spaceLength = 40 - #playerVars[playerName].playerLanguage.Xbtn - #title
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
        ui.addTextArea(13, pageOperation(title, body, playerName, pageId), playerName, 198, 50, 406, 300, 0x122529, 0x7B5A35, 1, true)
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
    imgs[playerName].menuImgId = nil
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
        openPage(playerVars[name].playerLanguage.leaderboardsTitle, message, name, "roomStats")
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

    body = body.." » "..playerVars[creatorName].playerLanguage.playtime..": <font color='#f73625'>"..math.floor(seconds/3600).."</font>h <font color='#f73625'>"..math.floor(seconds%3600/60).."</font>m <font color='#f73625'>"..(seconds%3600%60).."</font>s\n"
    body = body.." » "..playerVars[creatorName].playerLanguage.firsts..": <font color='#f73625'>"..playerStats[playerName].mapsFinishedFirst.."</font>\n"
    body = body.." » "..playerVars[creatorName].playerLanguage.finishedMaps..": <font color='#f73625'>"..playerStats[playerName].mapsFinished.."</font>\n"
    local firstrate = "0%"
    if playerStats[playerName].mapsFinishedFirst > 0 then
        firstrate = (math.floor(playerStats[playerName].mapsFinishedFirst/playerStats[playerName].mapsFinished * 10000) / 100).."%"
    end
    body = body.." » "..playerVars[creatorName].playerLanguage.firstRate..": <font color='#f73625'>"..firstrate.."</font>\n"
    body = body.." » "..playerVars[creatorName].playerLanguage.holeEnters..": <font color='#f73625'>"..playerStats[playerName].timesEnteredInHole.."</font>\n"
    body = body.." » "..playerVars[creatorName].playerLanguage.graffitiUses..": <font color='#f73625'>"..playerStats[playerName].graffitiSprays.."</font>\n"
    body = body.." » "..playerVars[creatorName].playerLanguage.dashUses..": <font color='#f73625'>"..playerStats[playerName].timesDashed.."</font>\n"
    body = body.." » "..playerVars[creatorName].playerLanguage.rewindUses..": <font color='#f73625'>"..playerStats[playerName].timesRewinded.."</font>\n"
    body = body.." » "..playerVars[creatorName].playerLanguage.hardcoreMaps..": <font color='#f73625'>"..playerStats[playerName].hardcoreMaps.."</font>\n"

    return "<font face='Verdana' size='11'>"..body.."</font>"
end

-- This generates the settings body
function remakeOptions(playerName)
    -- REMAKE OPTIONS TEXT (UPDATE YES - NO)
    local id = playerId(playerName)

    toggles = {}
    for i = 1, #playerVars[playerName].playerPreferences do
        if playerVars[playerName].playerPreferences[i] == true then
            toggles[i] = playerVars[playerName].playerLanguage.optionsYes
        else
            toggles[i] = playerVars[playerName].playerLanguage.optionsNo
        end
    end

    local body = " » <a href=\"event:ToggleGraffiti\">"..playerVars[playerName].playerLanguage.graffitiSetting.."?</a> "..toggles[1].."\n » <a href=\"event:ToggleDashPart\">"..playerVars[playerName].playerLanguage.particlesSetting.."?</a> "..toggles[2].."\n » <a href=\"event:ToggleTimePanels\">"..playerVars[playerName].playerLanguage.timePanelsSetting.."?</a> "..toggles[3]
    body = body.."\n » <a href=\"event:ToggleGlobalChat\">"..playerVars[playerName].playerLanguage.globalChatSetting.."?</a> "..toggles[4].."\n"
    return "\n<font face='Verdana' size='11'>"..body.."</font>"
end

function clear(playerName)
    local page = playerVars[playerName].menuPage
    if page == "shop" then
        clearWelcomeImages(playerName)
    end
end

-- Clears welcomeScreen images
function clearWelcomeImages(playerName)
    local id = playerId(playerName)
    removeImage(imgs[playerName].shopWelcomeDash, playerName)
    imgs[playerName].shopWelcomeDash = nil
    local graffitiTextOffset = 1000000000
    removeTextArea(id + graffitiTextOffset, playerName)
end

-- This only is the welcome screen :D
function generateShopWelcome(playerName)
    local body = "\n\n\n\n<font face='Lucida Console' size='16'><p align='center'><CS>Your loadout!</CS></p>\n\n\n\n\n\n\n<textformat>       <textformat><a href='event:ChangePart'>[change]</a><textformat>         <textformat><a href='event:ChangeGraffiti'>[change]</a></font>\n\n\n"
    return body
end

function generateShopImgs(playerName)
    local id = playerId(playerName)
    local dashX, dashY = 255, 150

    if playerVars[playerName].menuPage == "shop" then
        clearWelcomeImages(playerName)
    end

    imgs[playerName].shopWelcomeDash = addImage(shop.dashAcc[playerStats[playerName].equipment[1]].imgId, "&2", dashX, dashY, playerName)

    local graffitiTextX, graffitiTextY, graffitiTextOffset = 365, 185, 1000000000
    addTextArea(id + graffitiTextOffset, "<p align='center'><font face='"..shop.graffitiFonts[playerStats[playerName].equipment[4]].imgId.."' size='16' color='"..shop.graffitiCol[playerStats[playerName].equipment[2]].imgId.."'>"..playerName.."</font></p>", playerName, graffitiTextX, graffitiTextY, 230, 25, 0x324650, 0x000000, 0, true)
end


function eventTextAreaCallback(textAreaId, playerName, eventName)
    local id = playerId(playerName)

    -- 12 is the id for the menu buttons
    if textAreaId == 12 then
        if eventName == "ShopOpen" then
            openPage(playerVars[playerName].playerLanguage.shopTitle, generateShopWelcome(playerName), playerName, "shop")
            generateShopImgs(playerName)
        end
        if eventName == "StatsOpen" then
            openPage(playerVars[playerName].playerLanguage.profileTitle.." - "..playerName, stats(playerName, playerName), playerName, "profile")
        end
        if eventName == "LeaderOpen" then
            openPage(playerVars[playerName].playerLanguage.leaderboardsTitle, "\n<font face='Verdana' size='11'>"..playerVars[playerName].playerLanguage.leaderboardsNotice.."</font>", playerName, "leaderboards")
        end
        if eventName == "SettingsOpen" then
            openPage(playerVars[playerName].playerLanguage.settingsTitle, remakeOptions(playerName), playerName, "settings")
        end
        if eventName == "AboutOpen" then
            openPage(playerVars[playerName].playerLanguage.aboutTitle, "\n<font face='Verdana' size='11'>"..playerVars[playerName].playerLanguage.aboutBody.."\n\n\n\n\n\n<p align='right'><CS>"..playerVars[playerName].playerLanguage.translator.."\n</CS><V>version: "..VERSION.."</V></p></font>", playerName, "about")
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
                addTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..playerVars[playerName].playerLanguage.lastTime..": N/A", playerName, 10, 45, 200, 21, 0xffffff, 0x000000, 0, true)
                addTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..playerVars[playerName].playerLanguage.lastBestTime..": N/A", playerName, 10, 30, 200, 21, 0xffffff, 0x000000, 0, true)
                if playerVars[playerName].playerFinished == true then
                    ui.updateTextArea(5, "<p align='center'><font face='Lucida console' color='#ffffff'>"..playerVars[playerName].playerLanguage.lastTime..": "..(playerVars[playerName].playerLastTime/100).."s", playerName)
                    ui.updateTextArea(4, "<p align='center'><font face='Lucida console' color='#ffffff'>"..playerVars[playerName].playerLanguage.lastBestTime..": "..(playerVars[playerName].playerBestTime/100).."s", playerName)
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
            openPage(playerVars[playerName].playerLanguage.settingsTitle, remakeOptions(playerName), playerName, "settings")
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
--[[ End of file ui.lua ]]--

--[[ File chatUtils.lua ]]--
--[[
    name: chatUtils.lua
    description: Contains eventChatMessage and eventChatCommand. Handles chat operations.
]]--

function eventChatMessage(playerName, msg)
    if room.community ~= "en" or string.sub(msg, 1, 1) == "!" then
        return
    end

    local id = playerId(playerName)
    local data = room.playerList[playerName]

    if playerVars[playerName].playerPreferences[4] == true then
        for name, playerData in pairs(room.playerList) do 
            if playerVars[name].playerPreferences[4] == true and playerName ~= name and playerData.community ~= data.community then
                print("<V>["..data.community.."] ["..playerName.."]</V> <font color='#C2C2DA'>"..msg.."</font>")
                chatMessage("<V>["..data.community.."] ["..playerName.."]</V> <font color='#C2C2DA'>"..msg.."</font>", name)
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

        if string.find(room.name, "^[a-z][a-z2]%-#ninja%d*$") then
            return chatMessage(playerVars[playerName].playerLanguage.cantSetPass, player)
        end

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

    if arg[1] == "p" or arg[1] == "profile" then
        isValid = true
        if arg[2] == nil then
            openPage(playerVars[playerName].playerLanguage.profileTitle.." - "..playerName, stats(playerName, playerName), playerName, id, "profile")
            return
        end

        for name, value in pairs(room.playerList) do
            if name == arg[2] then
                openPage(playerVars[playerName].playerLanguage.profileTitle.." - "..arg[2], stats(arg[2], playerName), playerName, id, "profile")
                break
            end
        end
    end

    if arg[1] == "langue" and arg[2] ~= nil then
        if translations[arg[2]] ~= nil then
            playerVars[playerName].playerLanguage = translations[arg[2]]
            generateHud(playerName)
            return
        end
        chatMessage(arg[2].." doesn't exist yet.", playerName)
    end

    if isValid == false then
        chatMessage(arg[1].." "..playerVars[playerName].playerLanguage.notValidCommand, playerName)
    end
end
--[[ End of file chatUtils.lua ]]--

--[[ File startFuncs.lua ]]--
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
system.disableChatCommandDisplay()
tfm.exec.setGameTime(MAPTIME, true)

-- INIT ALL EXISTING PLAYERS
for playerName in pairs(room.playerList) do
    inRoom[playerName] = true
    initPlayer(playerName)
end
--[[ End of file startFuncs.lua ]]--