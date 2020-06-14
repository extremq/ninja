--[[
    name: string.utf8.lua
    description: Utf8 string handler - credits to Bolodefchoco#0000
]]--

do
	-- Based on Luvit's ustring
	local charLength = function(byte)
		if bit32.rshift(byte, 7) == 0x00 then
			return 1
		elseif bit32.rshift(byte, 5) == 0x06 then
			return 2
		elseif bit32.rshift(byte, 4) == 0x0E then
			return 3
		elseif bit32.rshift(byte, 3) == 0x1E then
			return 4
		end
		return 0
	end

	local sub, byte = string.sub, string.byte
	string.utf8 = function(str)
		local utf8str = { }
		local index, append = 1, 0

		local charLen

		for i = 1, #str do
			repeat
				local char = sub(str, i, i)
				local byte = byte(char)
				if append ~= 0 then
					utf8str[index] = utf8str[index] .. char
					append = append - 1

					if append == 0 then
						index = index + 1
					end
					break
				end

				charLen = charLength(byte)
				utf8str[index] = char
				if charLen == 1 then
					index = index + 1
				end
				append = append + charLen - 1
			until true
		end

		return utf8str
	end
end