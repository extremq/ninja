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

keys = {0, 1, 2, 3, 9, 27, 32, 67, 71, 72, 77, 80, 84, 88}

shop = {
    dashAcc = {
        shopListing({3}, "1730a4ad53e.png", "particleDef", {"free", nil}, nil),
        shopListing({3, 31}, "1730a950dc4.png", "particleHearts", {"finishMaps", 10}, {"mapsFinished", 10}),
        shopListing({3, 13}, "1730a952a0d.png", "particleSleek", {"finishMapsFirst", 1}, {"mapsFinishedFirst", 1}),
        shopListing({31, 32, 31}, "1730a94d7af.png", "particleLikeNinja", {"finishMaps", 50}, {"mapsFinished", 50}),
        shopListing({9, 14}, "1730a94f62a.png", "particleYouPro", {"finishHardcoreMaps", 1}, {"hardcoreMaps", 1}),
        shopListing({2, 24, 11}, "1730a9544bd.png", "particleToSky", {"doubleJumps", 100}, {"doubleJumps", 100})
    },
    graffitiCol = {
        shopListing(0xffffff, '#ffffff', "graffitiColDef", {"free", nil}, nil),
        shopListing(0x000001, '#000001', "graffitiColBlack", {"finishMaps", 25}, {"mapsFinished", 25}),
        shopListing(0x8c0404, '#8c0404', "graffitiColDarkRed", {"dashTimes", 100}, {"timesDashed", 100})
    },
    graffitiImgs = {
        shopListing(nil, nil, "This is the default image (no image).", "Free.", nil),
        shopListing("17290c497e1.png", "17290c497e1.png", "Say cheese!", "Finish 1 harcore map.", {"hardcoreMaps", 1})
    },
    graffitiFonts = {
        shopListing("Comic Sans MS", "Comic Sans MS", "graffitiFontDef", {"free", nil}, nil),
        shopListing("Papyrus", "Papyrus", "graffitiFontPapyrus", {"sprayGraffiti", 50}, {"graffitiSprays", 50}),
        shopListing("Verdana", "Verdana", "graffitiFontVerdana", {"doubleJumps", 200}, {"doubleJumps", 200}),
        shopListing("Century Gothic", "Century Gothic", "graffitiFontCenturyGothic", {"dashTimes", 50}, {"timesDashed", 50})
    }
}

-- We save ids so when a player leaves we still have their id (mostly to remove graffitis)
playerIds = {}
loaded = {}
inRoom = {}

queue = {

}

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
    if customRoom == true then return end

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