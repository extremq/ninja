local secureWrapper
do
  local function playerChecker(player)
    if loaded[player] == true and inRoom[player] == true then
        return true
    else
        return false
    end
  end

  function secureWrapper(fnc, first)
    if first then 
        return function(a, b, c, d, e)
        if playerChecker(a) then
          return fnc(a, b, c, d, e)
        end
      end
    else
      return function(a, b, c, d, e)
        if playerChecker(b) then
          return fnc(a, b, c, d, e)
        end
      end
    end
  end
end