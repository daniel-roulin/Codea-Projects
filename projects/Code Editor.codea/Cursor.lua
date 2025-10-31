

function Editor:drawCursor()
    self.cursorTime = self.cursorTime + DeltaTime
    if math.floor(self.cursorTime*2)%2 == 0 then
        strokeWidth(2)
        stroke(0, 174, 255)
        
        local w = textSize(string.sub(self.lines[self.cursorLine], 0, self.cursorCol))
        local x = self.barW + w
        local y = (HEIGHT - self.cursorLine * self.lineHeight) + self.yOffset - 1
        line(x, y, x, y + self.lineHeight)
    end
end

function Editor:moveCursor(t)
    local absPos = (HEIGHT - t.y) + self.yOffset
    self.cursorLine = math.ceil(absPos / self.lineHeight)
    
    local line_ = self.lines[self.cursorLine]
    for i = 0, #line_ do
        local leftText = string.sub(line_, 1, i)
        local w,_ = textSize(leftText)
        if t.x < w + self.barW then
            self.cursorCol = i
            break
        end
        self.cursorCol = #line_
    end
    
    self.cursorTime = 0
end


