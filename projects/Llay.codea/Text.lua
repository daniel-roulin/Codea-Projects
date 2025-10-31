Text = class(UIElement)

function Text:init(t)
    UIElement.init(self)
    self.text = t
    self.color = color(255)
    self.font = "Helvetica"
    self.fontSize = 17
end

function Text:setText(t)
    self.text = t
    return self
end

function Text:setColor(c)
    self.color = c
    return self
end

function Text:setFont(f)
    self.font = f
    return self
end

function Text:setFontSize(size)
    self.fontSize = size
    return self
end

function Text:setChildren(children)
    assert(false, "Text elements can't have children")
end

function Text:applyStyle()
    fill(self.color)
    font(self.font)
    fontSize(self.fontSize)
    textWrapWidth(self.w)
end

function Text:fitSizing(onXAxis, parent)
    if onXAxis and self.widthSizing == FIT then
        pushStyle()
        self:applyStyle()
        textWrapWidth(0)  -- If widthSizing is set to FIT, the text will not wrap
        local w, h = textSize(self.text)
        popStyle()
        self.w = w
    elseif not onXAxis and self.heightSizing == FIT then
        pushStyle()
        self:applyStyle()
        local w, h = textSize(self.text)
        popStyle()
        self.h = h
    end
        
    UIElement.fitSizing(self, onXAxis, parent)
end

function Text:draw()
    self:applyStyle()
    local textW, textH = textSize(self.text)
    local remainingWidth = self.w - textW
    local remainingHeight = self.h - textH
    
    local x, y = 0, 0
    if self.alignmentX == CENTER then
        x = x + remainingWidth/2
    elseif self.alignmentX == RIGHT then
        x = x + remainingWidth 
    end
    if self.alignmentY == CENTER then
        y = y + remainingHeight/2
    elseif self.alignmentY == TOP then
        y = y + remainingHeight 
    end
    
    textAlign(self.alignmentX)
    textMode(CORNER)
    text(self.text, x, y)
end


