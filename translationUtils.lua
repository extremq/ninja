--[[
    name: translationUtils.lua
    description: Contains translate() which formats strings and checks for available language
]]--

do
    function translate(playerName, what, ...)
        -- if we don't have this string translated, use english
        local language = playerVars[playerName].playerLanguage or translations.en
        local translated = language[what] or translations.en[what]
        
        assert(translated, "'"..what.."' is an invalid argument.")
        
        if select("#", ...) > 0 then
            return string.format(translated, ...)
        end
        return translated
    end
end