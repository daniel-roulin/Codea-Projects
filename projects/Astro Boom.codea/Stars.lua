-- #Stars

Stars = class()

function Stars:init() 
    self.stars = {}
    self.numberOfStar = 45
    
    while #self.stars < self.numberOfStar do
        pos = vec2(math.random(15, WIDTH-15), math.random(15, HEIGHT-15))
        for ind,star in pairs(self.stars) do
            if star.pos:dist(pos) < 50 then
                bad = true
            end
        end
        if bad == false then
            table.insert(self.stars,{["pos"] = pos, ["r"] = math.random(0,100000000000)})
        end
        bad = false
    end
end

function Stars:draw()
    background(39, 39, 50, 64)  
    tint(127, 127, 127, 255)
    for ind,star in pairs(self.stars) do
        math.randomseed(star.r)
        sprite(asset.builtin.Space_Art.Star,star.pos.x,star.pos.y,math.random(5,20),math.random(5,20))
    end
    noTint()
end