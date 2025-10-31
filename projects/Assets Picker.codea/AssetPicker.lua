AssetPicker = class()

function AssetPicker:init(callback)
    -- self.assetViewer = AssetViewer()
    
    self.openAsset = callback
    
    self.current = Item({
    Item(asset),
    Item(asset.documents),
    Item(asset.builtin),
    Item(asset.downloaded)
    })
    
    self.current.name = "Content"
    self.current.type = "folder"
    
    for k,v in pairs(self.current.content) do
        v.icon = v:generateIcon()
    end
      
    self.topY = HEIGHT - 95
    self.topH = 95
    self.rRad = 20
    self.itemsH = #self.current.content*60
    
    self.offset = 0
    self.momentum = 0
    self.sensitivity = 1
    
    self.transItems = Item({})
    self.transItemsH = 0
    self.transOffset = 0
    
    self.x = 0
    self.y = -HEIGHT
end

function AssetPicker:draw()
    if self.y <= -HEIGHT then
        return
    end
    
    self.offset = self.offset + self.momentum * DeltaTime
    self.momentum = self.momentum * 0.9
    
    if self.offset < 0 then
        self.offset = lerp(self.offset, 0, 0.1)
    elseif self.offset > math.max(self.itemsH - self.topY, 0) then
        self.offset = lerp(self.offset, math.max(self.itemsH - self.topY, 0), 0.1)
    end
    
    pushMatrix()
    translate(0, self.y)
    
    fill(100)
    rRect(0, HEIGHT-self.topH-self.rRad, WIDTH, 80, self.rRad)
    
    textMode(CENTER)
    fontSize(20)
    
    font("SourceSansPro-Bold")
    fill(255)
    text(self.current.name, WIDTH/2, HEIGHT-70)
    
    font("SourceSansPro-Light")
    fill(0, 174, 255)
    text("Done", WIDTH-42, HEIGHT-70)
    
    if self.current.parent then
        textMode(CORNER)
        text("< "..self.current.parent.name, 10, HEIGHT-83)
    end
    
    fill(200)
    rect(0,0, WIDTH, self.topY)
    
    clip(0, self.y, WIDTH, self.topY)
    
    pushMatrix()
    translate(self.x, self.offset)
    for index, item in pairs(self.current.content) do
        pushMatrix()
        translate(0, self.topY-index*60)
        item:draw()
        popMatrix()
    end
    popMatrix()
    
    pushMatrix()
    translate(self.x + WIDTH, self.transOffset)
    for index, item in pairs(self.transItems.content) do
        pushMatrix()
        translate(0, self.topY - index*60)
        item:draw()
        popMatrix()
    end
    popMatrix()
    
    local l = (self.topY/self.itemsH)*self.topY
    local y = map(self.itemsH - self.topY - self.offset, 0, self.itemsH - self.topY, l/2+2, self.topY-l/2-2)
    
    strokeWidth(4)
    stroke(100)
    line(WIDTH-2, math.min(y+l/2, HEIGHT-97), WIDTH-2, math.max(y-l/2,2))
    
    clip()
    popMatrix()
end

function AssetPicker:open(item)
    if item.type ~= "folder" and item.type ~= "project" then
        return self.openAsset(item.content)
    end
    
    local parent = self.current
    
    for k,v in pairs(item.content) do
        if not v.icon then
            v.icon = v:generateIcon()
        end
    end
    
    self.transItems = item
    self.transItemsH = #self.transItems.content*60
    self.transOffset = 0
    
    tween(0.4, self, {x = -WIDTH}, tween.easing.quadInOut, function()
        self.current = self.transItems
        self.itemsH = self.transItemsH
        self.offset = self.transOffset
        self.x = 0
        self.transItems = Item({})
        self.current.parent = parent
    end)
end

function AssetPicker:back()
    if self.current.parent then
        self.transItems = self.current
        self.transItemsH = self.itemsH
        self.transOffset = self.offset
        
        self.current = self.current.parent
        self.itemsH = #self.current.content*60
        self.offset = 0
        
        self.x = -WIDTH
        tween(0.4, self, {x = 0}, tween.easing.quadInOut, function()
            self.x = 0
            self.transItems = Item({})
        end)
    end
end

function AssetPicker:close()
    tween(0.3, self, {y = -HEIGHT}, tween.easing.quadOut)
end

function AssetPicker:show()
    if self.y <= -HEIGHT then
        tween(0.3, self, {y = 0}, tween.easing.quadOut)
    end
end

function AssetPicker:isActive()
    return self.y == 0
end

function AssetPicker:touched(t)
    if self.y < 0 then
        return
    end
    
    if t.state == BEGAN then
        self.at = t
    end
    
    if self.at.y > self.topY then
        if t.state == ENDED then
            if self.at.x < WIDTH/2 then
                self:back()
            else
                self:close()
            end
        end
        return
    end
    
    if t.state == CHANGED then
        self.offset = self.offset + t.delta.y
    else
        self.momentum = t.delta.y / DeltaTime * self.sensitivity
        if math.abs(self.momentum) < 70 then
            self.momentum = 0
        end
    end
    
    for index, item in pairs(self.current.content) do
        if t.y > (self.topY - index*60) + self.offset and t.y < (self.topY - (index-1)*60) + self.offset then
            if t.pos:dist(self.at.pos) < 5 then
                item.isTouch = true
            else
                item.isTouch = false
            end
            if item.isTouch and t.state == ENDED then
                item.isTouch = false
                self:open(item)
            end
        end
    end
end

function rRect(x,y,w,h,r)
    pushMatrix()
    translate(x,y)
    
    strokeWidth(0)
    
    ellipse(r/2,h-r/2,r) 
    ellipse(w-r/2,h-r/2,r)
    ellipse(r/2,r/2,r) 
    ellipse(w-r/2,r/2,r)
    
    rect(0,r/2,w,h-r) 
    rect(r/2,0,w-r,h)
    popMatrix()
end

function lerp(pos1, pos2, perc)
    return (1-perc)*pos1 + perc*pos2
end

function map( value, start1, stop1, start2, stop2 )
    local norm = (value - start1) / (stop1 - start1)
    norm = norm * (stop2 - start2) + start2
    return norm
end



