-- #Asteroide

Asteroide = class()

function Asteroide:init(x,y)
    
    -- math.randomseed(math.floor(ElapsedTime*DeltaTime*100))
    
    self.pos = vec2(x,y)
    self.acc = vec2(math.random(-10,10)/10,astAcc)
    self.rspeed = math.random(-4,4)
    self.size = math.random(40,60)
    
end

function Asteroide:draw()
    
    self.pos = self.pos + self.acc
    
    if self.pos.x - self.size/2 <= 0 then
        self.acc = vec2(-self.acc.x, self.acc.y)
    end
    
    if self.pos.x + self.size/2 >= WIDTH then
        self.acc = vec2(-self.acc.x, self.acc.y)
    end
    
    pushMatrix()
    
    translate(self.pos.x, self.pos.y)
    rotate(ElapsedTime*100*self.rspeed)
    sprite(asset.builtin.Space_Art.Asteroid_Small,0,0,self.size,self.size)
    
    popMatrix()
end