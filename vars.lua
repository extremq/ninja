--[[
    name: vars.lua
    description: contains all player and map variables (shop, player structures and map vars)
]]--

unlocks = {
    -- same struct as shop
}

function shopListing(values, imgId, tooltip, reqs, fncArgs)
    return {
        ['values'] = values,
        ['imgId'] = imgId,
        ['tooltip'] = tooltip,
        ['reqs'] = reqs,
        ['fnc'] = function(playerName)
            if fncArgs == nil then 
                return true 
            elseif playerStats[playerName][fncArgs[1]] >= fncArgs[2] then
                return true
            else
                return false
            end
        end
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

keys = {0, 1, 2, 3, 27, 32, 67, 71, 72, 77, 80, 84, 88}

shop = {
    dashAcc = {
        shopListing({3}, "172a562c334.png", "particleDef", {"free", nil}, nil),
        shopListing({3, 31}, "172a5639431.png", "particleHearts", {"finishMaps", 10}, {"mapsFinished", 1}),
        shopListing({3, 13}, "172a5629c24.png", "particleSleek", {"finishMapsFirst", 1}, {"mapsFinishedFirst", 1}),
        shopListing({31, 32, 31}, "172a5629c24.png", "particleLikeNinja", {"finishMaps", 50}, {"mapsFinished", 3}),
        shopListing({9, 14}, "172a5629c24.png", "particleYouPro", {"finishHardcoreMaps", 50}, {"hardcoreMaps", 1}),
        shopListing({2, 24, 11}, "172a5629c24.png", "particleToSky", {"doubleJumps", 50}, {"doubleJumps", 25})
    },
    graffitiCol = {
        shopListing('#ffffff', '#ffffff', "graffitiColDef", {"free", nil}, nil),
        shopListing('#000000', '#000000', "graffitiColBlack", {"finishMaps", 25}, {"mapsFinished", 2}),
        shopListing('#8c0404', '#8c0404', "graffitiColDarkRed", {"dashTimes", 100}, {"timesDashed", 50})
    },
    graffitiImgs = {
        shopListing(nil, nil, "This is the default image (no image).", "Free.", nil),
        shopListing("17290c497e1.png", "17290c497e1.png", "Say cheese!", "Finish 1 harcore map.", {"hardcoreMaps", 1})
    },
    graffitiFonts = {
        shopListing("Comic Sans MS", "Comic Sans MS", "graffitiFontDef", {"free", nil}, nil),
        shopListing("Papyrus", "Papyrus", "graffitiFontPapyrus", {"sprayGraffiti", 50}, {"graffitiSprays", 10}),
        shopListing("Verdana", "Verdana", "graffitiFontVerdana", {"rewindTimes", 10}, {"timesRewinded", 1}),
        shopListing("Century Gothic", "Century Gothic", "graffitiFontCenturyGothic", {"dashTimes", 50}, {"timesDashed", 1})
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

function checkUnlock(playerName, what, index, message, ...)
    if unlocks[playerName][what][index] == false and shop[what][index].fnc(playerName) == true then
        chatMessage(translate(playerName, message, ...), playerName)
        unlocks[playerName][what][index] = true
    end
end


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