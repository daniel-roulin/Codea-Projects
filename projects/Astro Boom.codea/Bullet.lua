-- #Bullet

Bullet = class()

function Bullet:init(x,y)
    -- you can accept and set parameters here
    self.x = x
    self.y = y
    self.w = 10
    self.h = 30
end

function Bullet:update()
    self.y = self.y + bulletSpeed
end

function Bullet:draw()
    tint(231, 159, 87, 255)
    sprite(asset.builtin.Space_Art.Red_Bullet,self.x,self.y,self.w,self.h)
    noTint()
end
