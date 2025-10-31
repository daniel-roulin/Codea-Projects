-- A simple class to demo the ScrollContainers library
ScrollObject = class()

function ScrollObject:init(n, w, h)
    self:newColor()
    self.n = n
    self.width = w
    self.height = h
end

function ScrollObject:newColor()
    self.color = color(math.random(100, 255), math.random(100, 255), math.random(100, 255))
end

function ScrollObject:draw()
    fill(self.color) 
    noStroke()
    rect(0, 2, self.width-4, self.height-4)
    fill(255)
    text(self.n, self.width/2, self.height/2)
end

function ScrollObject:touched(touch)
    print(self.n)
    self:newColor()
end