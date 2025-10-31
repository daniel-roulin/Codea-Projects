Button = class()

function Button:init(x, y, w, h, mode)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    
    self.isTouched = false
    self.isActive = true
    self.mode = mode or CENTER
end

function Button:hitTest(t)
    if self.mode == CORNER then
        return t.x >= self.x and t.x <= self.x + self.w and
        t.y >= self.y and t.y <= self.y + self.h
    elseif self.mode == CENTER then
        return t.x >= self.x - self.w/2 and t.x <= self.x + self.w/2 and
        t.y >= self.y - self.h/2 and t.y <= self.y + self.h/2
    end
end

function Button:touched(t)
    if not self.isActive then
        return
    end
    if t.state == BEGAN and self:hitTest(t) then
        self.isTouched = true
    elseif t.state == CHANGED and not self:hitTest(t) then
        self.isTouched = false
    elseif (t.state == ENDED or t.state == CANCELLED) and self.isTouched then
        self.isTouched = false
        self:clicked()
    end
end


HideKeyboardButton = class(Button)

function HideKeyboardButton:init(x, y)
    Button.init(self, x, y-5, 50, 50, CENTER)
end

function HideKeyboardButton:draw()
    pushMatrix()
    translate(self.x, self.y)
    
    stroke(127)
    strokeWidth(3)
    
    rotate(45)
    line(10, 0,0,0)
    rotate(90)
    line(10, 0,0,0)
    popMatrix()
end

function HideKeyboardButton:clicked()
    if isKeyboardShowing() then
        hideKeyboard()
    end
end

