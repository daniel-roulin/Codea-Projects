Editor = class()

function Editor:init()
    -- Parameters
    self.fontSize = 15
    self.font = "HelveticaNeue"
    self.barW = 30
    self.text = readProjectTab("Other:Astro Boom:Main")
    -- self.text = string.rep(string.rep(" AA", 15).."\n"..string.rep(" BB", 10).."\n", 50)
    
    self.lines = self:splitLines(self.text)
    
    -- Touch
    self.lastTouches = {}
    
    -- Size
    font(self.font)
    fontSize(self.fontSize)
    _, self.lineHeight = textSize("A")
    
    self.lineOffset = 0
    self.yOffset = 0
    self.nVisibleLines = math.ceil(HEIGHT/self.lineHeight)
    self.maxYOffset = #self.lines * self.lineHeight - HEIGHT
    
    -- Scrolling
    self.inertialVelocity = 0
    self.inertialAcceleration = 0.95
    self.scrollSpringForce = 0.8
    
    -- Cursor
    self.cursorCol = 0
    self.cursorLine = 1
    self.cursorTime = 0
    
    -- Syntax
    self:setConstants()
    
    -- Keyboard
    self.keyboardHeight = HEIGHT/3-7
    self:initKeyboardButtons()
end

function Editor:draw()
    background(self.colors["bg"])
    
    -- Left Bar
    self:drawLeftBar()
    
    -- Lines
    for i = 1 + self.lineOffset, self.nVisibleLines + self.lineOffset do
        if i > #self.lines then break end
        self:drawLine(HEIGHT - i*self.lineHeight + self.yOffset, i, self.lines[i])
    end
    
    -- Cursor
    self:drawCursor()
    
    -- Keyboard Bar
    if isKeyboardShowing() then
        self.nVisibleLines = math.ceil((HEIGHT - self.keyboardHeight - 50)/self.lineHeight)
        self.maxYOffset = #self.lines * self.lineHeight - (HEIGHT - self.keyboardHeight - 50)
        self:drawKeyboardBar()
    else
        self.nVisibleLines = math.ceil(HEIGHT/self.lineHeight)
        self.maxYOffset = #self.lines * self.lineHeight - HEIGHT
    end
    
    -- Scrolling
    self:updateScrolling()
    
    -- Touch Debug
    noStroke()
    fill(255, 14, 0)
    -- ellipse(CurrentTouch.x, CurrentTouch.y, 5)
end

function Editor:touched(t)
    if self:keyboardBarTouched(t) then
        return
    end
    
    if t.state == ENDED then
        if #self.lastTouches < 2 then
            -- Clicked
            self:moveCursor(t)
            showKeyboard()
        else
            -- Scrolled
            self:computeInertia()
        end
        self.lastTouches = {}
    else
        table.insert(self.lastTouches, 1, t)
        if #self.lastTouches > 10 then
            table.remove(self.lastTouches)
        end
        
        self:scroll(t)
    end
end

function Editor:keyboard(k)
    self.cursorTime = 0
    local line_ = self.lines[self.cursorLine]
    if k == BACKSPACE then
        self.lines[self.cursorLine] = string.sub(line_, 0, self.cursorCol-1)..string.sub(line_, self.cursorCol+1, #line_)
        self.cursorCol = self.cursorCol - 1
    elseif k == RETURN then
        self.lines[self.cursorLine] = string.sub(line_, 0, self.cursorCol)
        table.insert(self.lines, self.cursorCol, string.sub(line_, self.cursorCol+1, #line_))
        for k,v in pairs(self.lines) do
            print(v)
        end
    else
        self.lines[self.cursorLine] = string.sub(line_, 0, self.cursorCol)..k..string.sub(line_, self.cursorCol+1, #line_)
        self.cursorCol = self.cursorCol + 1
    end
end

function clamp(x, max, min)
    return math.max(math.min(x, min), max)
end

function lerp(pos1, pos2, perc)
    return (1-perc)*pos1 + perc*pos2
end

