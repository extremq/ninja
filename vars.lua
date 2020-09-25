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
slowestplayer = -1
playerSortedBestTime = {}
playerCount = 0
playerWon = 0
mapfinished = false
admin = ""
customRoom = false
hasShownStats = false
bestTime = 99999
worstTime = 0

keys = {0, 1, 2, 3, 9, 27, 32, 67, 71, 72, 77, 80, 84, 88}

shop = {
    dashAcc = {
        shopListing({3}, "1730a4ad53e.png", "particleDef", {"free", nil}, nil),
        shopListing({3, 31}, "1730a950dc4.png", "particleHearts", {"finishMaps", 25}, {"mapsFinished", 25}),
        shopListing({31, 32, 31}, "1730a94d7af.png", "particleLikeNinja", {"finishMaps", 50}, {"mapsFinished", 50}),
        shopListing({3, 13}, "1730a952a0d.png", "particleSleek", {"finishMapsFirst", 10}, {"mapsFinishedFirst", 10}),
        shopListing({9, 14}, "1730a94f62a.png", "particleYouPro", {"finishHardcoreMaps", 1}, {"hardcoreMaps", 1}),
        shopListing({2, 24, 11}, "1730a9544bd.png", "particleToSky", {"doubleJumps", 7500}, {"doubleJumps", 7500})
    },
    graffitiCol = {
        shopListing(0xffffff, '#ffffff', "graffitiColDef", {"free", nil}, nil),
        shopListing(0x1D6110, '#1D6110', "graffitiColDarkGreen", {"finishMaps", 15}, {"mapsFinished", 15}),
        shopListing(0x000001, '#000001', "graffitiColBlack", {"finishMaps", 25}, {"mapsFinished", 25}),
        shopListing(0x45B7FA, '#45B7FA', "graffitiColSkyBlue", {"finishMaps", 50}, {"mapsFinished", 50}),
        shopListing(0x004269, '#004269', "graffitiColDarkBlue", {"finishMapsFirst", 15}, {"mapsFinishedFirst", 15}),
        shopListing(0x83018A, '#83018A', "graffitiColDarkViolet", {"finishMapsFirst", 30}, {"mapsFinishedFirst", 30}),
        shopListing(0xAB3172, '#AB3172', "graffitiColPink", {"finishMapsFirst", 100}, {"mapsFinishedFirst", 100}),
        shopListing(0xE67738, '#E67738', "graffitiColOrange", {"finishHardcoreMaps", 20}, {"hardcoreMaps", 20}),
        shopListing(0x3F48CC, '#3F48CC', "graffitiColAlgae", {"finishHardcoreMaps", 40}, {"hardcoreMaps", 40}),
        shopListing(0x8c0404, '#8c0404', "graffitiColDarkRed", {"dashTimes", 300}, {"timesDashed", 300}),
        shopListing(0x002B17, '#002B17', "graffitiColLeafGreen", {"dashTimes", 750}, {"timesDashed", 750}),
        shopListing(0xF0D210, '#F0D210', "graffitiColYellowRed", {"doubleJumps", 10000}, {"doubleJumps", 10000}),
        shopListing(0x4BE62C, '#4BE62C', "graffitiColToxicGreen", {"doubleJumps", 20000}, {"doubleJumps", 20000})
    },
    graffitiImgs = {
        shopListing(nil, nil, "This is the default image (no image).", "Free.", nil)
    },
    graffitiFonts = {
        shopListing("Comic Sans MS", "Comic Sans MS", "graffitiFontDef", {"free", nil}, nil),
        shopListing("Tahoma", "Tahoma", "graffitiFontTahoma", {"sprayGraffiti", 25}, {"graffitiSprays", 25}),
        shopListing("Papyrus", "Papyrus", "graffitiFontPapyrus", {"sprayGraffiti", 50}, {"graffitiSprays", 50}),
        shopListing("Kristen ITC", "Kristen ITC", "graffitiFontKristenITC", {"sprayGraffiti", 100}, {"graffitiSprays", 100}),
        shopListing("Verdana", "Verdana", "graffitiFontVerdana", {"doubleJumps", 2000}, {"doubleJumps", 2000}),
        shopListing("Courier", "Courier", "graffitiFontCourier", {"doubleJumps", 5000}, {"doubleJumps", 5000}),
        shopListing("Century Gothic", "Century Gothic", "graffitiFontCenturyGothic", {"dashTimes", 500}, {"timesDashed", 500}),
        shopListing("Bahnschrift SemiBold", "Bahnschrift SemiBold", "graffitiFontBahnschriftSemiBold", {"dashTimes", 10000}, {"timesDashed", 10000}),
        shopListing("Book Antiqua", "Book Antiqua", "graffitiFontBookAntiqua", {"finishHardcoreMaps", 5}, {"hardcoreMaps", 5}),
        shopListing("FixedSys", "FixedSys", "graffitiFontFixedSys", {"finishMapsFirst", 5}, {"mapsFinishedFirst", 5}),
        shopListing("Impact", "Impact", "graffitiFontImpact", {"finishMaps", 100}, {"mapsFinished", 100})
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