

function cropText(str, maxHeight)
    local w, h = textSize(str)
    if h > maxHeight then
        while h > maxHeight do
            str = string.sub(str, 1, #str-1)
            w, h = textSize(str)
        end
        str = string.sub(str, 1, #str-3).."..."
    end
    return str
end

function clamp(x, max, min)
    return math.max(math.min(x, min), max)
end

function map(value, start1, stop1, start2, stop2)
    local norm = (value - start1) / (stop1 - start1)
    norm = norm * (stop2 - start2) + start2
    return norm
end

function split(str, char, n)
    local n = n or math.maxinteger
    local result, lastPos = {}, 1
    for part, pos in string.gmatch(str, "(.-)"..char.."()") do
        if n == 0 then break end
        table.insert(result, part)
        lastPos = pos
        n = n - 1
    end
    table.insert(result, string.sub(str, lastPos))
    return result
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function rRect(x,y,w,h,r)
    pushMatrix()
    translate(x, y)
    rect(0, 0, w, h-r)
    rect(0, 0, w-r, h)
    ellipse(w/2-r/2, h/2-r/2, r)
    ellipse(w/2-r/2, -h/2+r/2, r)
    ellipse(-w/2+r/2, h/2-r/2, r)
    ellipse(-w/2+r/2, -h/2+r/2, r)
    popMatrix()
end


