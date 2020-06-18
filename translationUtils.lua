--[[
    name: translationUtils.lua
    description: Contains translate() which formats strings and checks for available language
]]--

do
    function translate(playerName, what, ...)
        -- if we don't have this string translated, use english
        local language
        if playerName == nil then
            language = translations.en
        elseif string.sub(playerName, 1, 1) ~= "*" and string.find(playerName, "#") == nil then
            language = translations.playerName or translations.en
        else
            language = playerVars[playerName].playerLanguage or translations.en
        end
        local translated = language[what] or translations.en[what]
        
        assert(translated, "'"..what.."' is an invalid argument.")
        
        if select("#", ...) > 0 then
            return string.format(translated, ...)
        end
        return translated
    end
end