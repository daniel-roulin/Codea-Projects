
    
function Editor:drawLine(y, i, l)
    fontSize(self.fontSize - 3)
    fill(self.colors["cm"])
    text(i, 0, y)
    
    fontSize(self.fontSize)
    local words = self:splitSymbols(l)
    local isString, isComment = false, false
    -- local x = self.x + self.barW
    for i, word in pairs(words) do
        
        if word == "-" and words[i+1] == "-" then
            isComment = true
        end
        
        if not isComment and (word == '"' or word == "'") then
            isString = not isString
        end
        
        if isComment then
            fill(self.colors["cm"])
        elseif isString or word == "'" or word == '"' then
            fill(self.colors["st"])
        else
            if tonumber(word) then
                fill(self.colors["nb"])
            else
                fill(self.syntaxTable[word] or self.colors["fg"])
            end
        end
        
        local leftText = table.concat(words, "", 1, i-1)
        local x, _ = textSize(leftText)
        if x > WIDTH then break end
        
        text(word, self.barW + x, y)
    end
end
