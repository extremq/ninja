--[[
    name: vars.lua
    description: contains all player and map variables (shop, player structures and map vars)
]]--


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

keys = {0, 1, 2, 3, 32, 67, 71, 72, 77, 84, 88}

shop = {
    dashAcc = {
        shopListing({3}, "172a562c334.png", "This is the default particle.", "Free.", nil),
        shopListing({3, 31}, "172a5639431.png", "Add some hearts to your dash!", "Finish 10 maps.", {"mapsFinished", 1}),
        shopListing({3, 13}, "172a5629c24.png", "Sleek. Just like you.", "Finish 1 map first.", {"mapsFinishedFirst", 1})
    },
    graffitiCol = {
        shopListing('#ffffff', '#ffffff', "This is the default graffiti color.", "Free.", nil),
        shopListing('#000000', '#000000', "You're a dark person.", "Finish 50 maps.", {"mapsFinished", 50}),
        shopListing('#8c0404', '#8c0404', "Where's this... blood from?", "Dash 100 times.", {"timesDashed", 100})
    },
    graffitiImgs = {
        shopListing(nil, nil, "This is the default image (no image).", "Free.", nil),
        shopListing("17290c497e1.png", "17290c497e1.png", "Say cheese!", "Finish 1 harcore map.", {"hardcoreMaps", 1})
    },
    graffitiFonts = {
        shopListing("Comic Sans MS", "Comic Sans MS", "This is the default font for graffitis.", "Free.", nil),
        shopListing("Papyrus", "Papyrus", "You seem old.", "Spray a graffiti 50 times.", {"graffitiSprays", 50}),
        shopListing("Verdana", "Verdana", "A classic.", "Rewind 10 times.", {"timesRewinded", 10}),
        shopListing("CenturyGothic", "Verdana", "Wow, you're so modern.", "Dash 50 times.", {"timesDashed", 10})
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

unlocks = {
    -- same struct as shop
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