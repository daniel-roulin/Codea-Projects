Rectangle = class(UIElement)

function Rectangle:init(c)
    UIElement.init(self)
    self.color = c or color(0, 0)
end

function Rectangle:setColor(c)
    self.color = c
    return self
end

function Rectangle:draw()
    fill(self.color)
    rect(0, 0, self.w, self.h)
end

