-- #Brick

Brick = class()

function Brick:init(x,y,w,h)
    
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.life = brickLife
    
    self.g = 100
    self.r = math.random(0,100000000)
    
end

function Brick:update()
    self.y = self.y - brickSpeed
end

function Brick:draw()
    strokeWidth(3.5)
    stroke(224, 224, 224, 255)
    
    math.randomseed(self.r)
    fill(colorList[self.life].r+math.random(-self.g, self.g),colorList[self.life].g+math.random(-self.g, self.g),colorList[self.life].b+math.random(-self.g, self.g))
    
    rect(self.x, self.y, self.w, self.h)
    noTint()
end
