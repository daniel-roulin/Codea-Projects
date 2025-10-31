-- #Emitter

Emitter = class()

function Emitter:init()
    self.explosions = {}
end

function Emitter:draw()
    for ind,exp in pairs(self.explosions) do
        exp:draw()
    end
end

function Emitter:addEx(x,y,numpart,duration, size, col)
    table.insert(self.explosions, Explosion(x,y,numpart, duration, size, col))
end



Explosion = class()

function Explosion:init(x,y,numPart,duration, size, col)
    
    self.x = x
    self.y = y
    self.numPart = numPart
    self.duration = duration
    self.acc = size
    self.size = size
    self.col = col
    
    self.particules = {}
    
    for i = 1,self.numPart do
        table.insert(self.particules, Particule(vec2(self.x,self.y),vec2(math.random(-self.acc,self.acc)/100,math.random(-self.acc,self.acc)/100),math.random(self.duration-10, self.duration), math.random(math.floor(self.size/100), math.floor(self.size/50)), self.col))
    end
end

function Explosion:draw()
    for ind,part in pairs(self.particules) do
        if part.life <= 0 then
            table.remove(self.particules,ind)
        end
        part:draw()
    end
end


Particule = class()

function Particule:init(pos,acc,life,size,col)
    self.pos = pos
    self.acc = acc
    self.life = life 
    self.size = size
    self.col = col
end

function Particule:draw()
    
    self.pos = self.pos + self.acc
    self.life = self.life - 1
    
    fill(self.col)
    noStroke()
    
    ellipse(self.pos.x, self.pos.y, self.size)
end