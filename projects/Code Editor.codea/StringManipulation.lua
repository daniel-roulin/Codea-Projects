function Editor:splitLines(str)
    local result, lastPos = {}, 1
    for part, pos in string.gmatch(str, "(.-)\n()") do
        table.insert(result, part)
        lastPos = pos
    end
    table.insert(result, string.sub(str, lastPos))
    return result
end


function Editor:splitSymbols(str)
    local result, lastPos = {}, 0
    local pat = "()([\"'%" .. table.concat(self.symbols, "%") .. "%s])"
    for i, j in string.gmatch(str, pat) do
        local s = string.sub(str, lastPos+1, i-1)
        if s ~= "" then
            table.insert(result, s)
        end
        table.insert(result, j)
        lastPos = i
    end
    table.insert(result, string.sub(str, lastPos+1))
    return result
end