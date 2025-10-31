-- #Player

Player = class()

function Player:init(x,y)
    -- you can accept and set parameters here
    
    self.x = x
    self.y = y
    self.tx = self.x
    self.ty = self.y
    
end

function Player:draw()
    
    if self.x < WIDTH/3 then
        sprite(asset.builtin.Space_Art.Red_Ship_Bank_Left,self.x,self.y)
    elseif self.x < WIDTH/3*2 then
        sprite(asset.builtin.Space_Art.Red_Ship,self.x,self.y)
    else
        sprite(asset.builtin.Space_Art.Red_Ship_Bank_Right,self.x,self.y)
    end
end

function Player:update()
    if touch then
        if coolDown == 0 then
            table.insert(bullets, Bullet(self.x,self.y+40))
            sound(SOUND_SHOOT, 19785,sfxVol)
            coolDown = reloadTime
        end
        coolDown = coolDown - 1
    end
    self.x = lerp(self.x, self.tx, 0.25)
    self.y = lerp(self.y, self.ty + 40, 0.25)
end

function Player:touched(t)
    self.tx = t.x
    self.ty = t.y
    
    if t.state == BEGAN then touch = true end
    if t.state == ENDED or t.state == CANCELLED then touch = false end
end