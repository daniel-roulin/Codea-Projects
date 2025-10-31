Map = class()

function Map:init(x)
    self.tileW = 256
    self.maxZoomPwr = 19
    
    self.trl = PanAndZoom(1, 2^self.maxZoomPwr)
    self.trl.offset = vec2(-(WIDTH/2-self.tileW/2), -(HEIGHT/2-self.tileW/2))
    
    self.baseUrl = "https://tile.openstreetmap.org/%d/%d/%d.png"
    self.askedTiles = {}
    self.tiles = {}
    
    self.zoom = math.ceil(log2(self.trl.zoom))
    self.maxTiles = 2^self.zoom
end

function Map:draw()
    self.zoom = math.ceil(log2(self.trl.zoom))
    self.maxTiles = 2^self.zoom
    
    self.size = self.tileW/self.maxTiles
    
    self.nx = math.ceil(WIDTH/(self.size*self.trl.zoom))
    self.ny = math.ceil(HEIGHT/(self.size*self.trl.zoom))
    
    self.offsetX = math.floor((self.trl.offset.x/self.tileW)*self.maxTiles)
    self.offsetY = math.floor((self.trl.offset.y/self.tileW)*self.maxTiles)
    
    for x = self.offsetX, self.offsetX + self.nx do
        for y = self.offsetY, self.offsetY + self.ny do
            local pos = self.trl:wrldToScrn(vec2(x, y)*self.size)
            
            -- Inverting the y coordinates since OpenStreetMap tiles have their origin in the top left corner
            local mapX = x 
            local mapY = (self.maxTiles-1)-y
            
            local tile = self:getTile(self.tiles, self.zoom, mapX, mapY)
            if tile then
                spriteMode(CORNER)
                sprite(tile, pos.x, pos.y, self.size*self.trl.zoom)
            else
                self:fetchTile(mapX, mapY, self.zoom)
            end
        end
    end
    
    -- More info here:
    -- www.openstreetmap.org/copyright 
    local cc = "© OpenStreetMap contributors"
    local w, h = textSize(cc)
    fill(127)
    textMode(CORNER)
    text(cc, WIDTH-w, 0)
    
    self.trl:update()
end

-- converts longitude from degrees (0 (Greenwich) to 360) and latitude (-90 to 90 with 0° = Equator) to x/y position (0 to 256) 
-- https://en.wikipedia.org/wiki/Web_Mercator_projection#
function Map:coordsToPos(lat, lon)
    local scl = 256/(2*math.pi)
    local lon, lat = math.rad(lon), math.rad(lat)
    local x = scl*(lon+math.pi)
    local y = scl*(math.pi-math.log(math.tan((math.pi/4)+(lat/2))))
    return vec2(x, y)
end

-- Inverse of the previous function
function Map:posToCoords(x, y)
    local scl = 256/(2*math.pi) 
    local lon = (x/scl)-math.pi
    local lat = (math.atan(math.exp(-((y/scl)-math.pi)))-(math.pi/4))*2
    return vec2(math.deg(lat), math.deg(lon))
end

function Map:fetchTile(x,y,z)
    -- print("Fetching tile: "..x.." "..y.." "..z)
    if self:getTile(self.askedTiles, z, x, y) then
        return
    end
    
    if z < 0 or z > 19 then
        return
    end
    if x >= 2^z or x < 0 then
        return
    end
    if y >= 2^z or y < 0 then
        return
    end
    
    url = string.format(self.baseUrl, z, x, y)
    http.request(url, function(data)
        self:didfetchTile(data, x, y ,z)
    end, function(error)
        self:didNotfetchTile(error, x, y ,z)
    end)
    
    self:addTile(self.askedTiles, z, x, y, true)
end

function Map:didfetchTile(tile, x, y, z)
    -- print("Got tile: ", z, x, y)
    self:addTile(self.tiles, z, x, y, tile)
end

function Map:didNotfetchTile(error, x, y, z)
    print("Did not get tile: ", z, x, y)
    print("Error: ", error)
end

function Map:addTile(array, z, x, y, tile)
    if not array[z] then
        array[z] = {}
    end
    if not array[z][x] then
        array[z][x] = {}
    end
    array[z][x][y] = tile
end

function Map:getTile(array, z, x, y)
    if not array[z] then
        return nil
    end
    if not array[z][x] then
        return nil
    end
    if not array[z][x][y] then
        return nil
    end
    return array[z][x][y]
end


function Map:touched(t)
    self.trl:touched(t)
end

function log2(n)
    return math.log(n)/math.log(2)
end
