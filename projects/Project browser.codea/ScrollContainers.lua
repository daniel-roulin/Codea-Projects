-----------------------------------------
-- Scroll Containers
-----------------------------------------
-- Description:
-- A simple library for scrollable content

-- Define a new Vertical or Horinzontal container with a list of objects and (optionaly) dimensions
-- Each object must have a height or width property (depending on the type of container) and
-- a method touched(touch), which is called when the object is clicked.
-- The container is positionned with its lower-left corner at x, y and sized at w, h
-- Default dimensions are fullscreen.
-- scrollbar is a bool and sets whether or not a scrollbar is displayed. Default is true
-----------------------------------------

VerticalScrollContainer = class()

function VerticalScrollContainer:init(objects, x, y, w, h, dynamic, scrollbar) 
    self.x = x or 0
    self.y = y or 0
    self.w = w or WIDTH
    self.h = h or HEIGHT
    
    self.objects = objects
    
    self.active = true
    self.scrollbar = (scrollbar ~= false)
    self.dynamic = dynamic
    
    self.scrollbarA = 255
    self.anim = tween(0.1, self, {scrollbarA = 255})
    
    self.maxOffset = 0
    for i = 1, #self.objects do
        self.maxOffset = self.maxOffset + self.objects[i].height
    end
    self.maxOffset = math.max(self.maxOffset-self.h, 0)
    
    -- Always positive, 0 is the top of the list
    self.offset = 0
    
    self.lastTouches = {}
    self.inertialVelocity = 0
    self.inertialAcceleration = 0.95
    self.scrollSpringForce = 0.8
    
    if viewer.preferredFPS == 0 then
        viewer.preferredFPS = 60
    end
    
    touches.addHandler(self, 0, true)
end

function VerticalScrollContainer:draw()
    if not self.active then return end
    
    if self.dynamic then
        self.maxOffset = 0
        for i = 1, #self.objects do
            self.maxOffset = self.maxOffset + self.objects[i].height
        end
        self.maxOffset = math.max(self.maxOffset-self.h, 0)
    end
    
    clip(self.x, self.y, self.w, self.h)
    local y = self.h + self.y + self.offset
    for i = 1, #self.objects do
        y = y - self.objects[i].height
        if y < self.y - self.objects[i].height then
            break
        elseif y < self.y + self.h then
            pushMatrix()
            translate(self.x, y)
            self.objects[i]:draw(-y, self.h)
            popMatrix()
        end
    end
    clip()
    
    if #self.lastTouches == 0 then
        self:updateScrolling()
    end
    
    if not self.scrollbar then return end
    pushStyle()
    strokeWidth(4)
    stroke(200, self.scrollbarA)
    local l = math.min((self.h/(self.maxOffset + self.h))*self.h, self.h)
    local y = map(self.offset, math.max(self.maxOffset, self.h), 0, l/2 + 4, self.h - l/2 - 4) + self.y
    line(self.x + self.w - 2, math.min(y + l/2, self.y + self.h - 4), self.x + self.w - 2, math.max(y - l/2, self.y + 4))
    popStyle()
    if l == self.h then  
        tween.stop(self.anim)
        self.anim = tween(0.1, self, {scrollbarA = 0})
    else
        tween.stop(self.anim)
        self.anim = tween(0.1, self, {scrollbarA = 255})
    end
end

function VerticalScrollContainer:checkTouch(t)
    return t.x >= self.x and t.x < self.x + self.w and t.y >= self.y and t.y < self.y + self.h
end

function VerticalScrollContainer:touched(t)
    if not self.active then return end
    if not self:checkTouch(t) and t.state == BEGAN then
        return false
    end
    if t.state == ENDED or t.state == CANCELLED then
        if #self.lastTouches < 3 then
            local y = self.h + self.y + self.offset
            for i = 1, #self.objects do
                y = y - self.objects[i].height
                if t.y > y then
                    local t = {x = t.x, y = t.y - y}
                    self.objects[i]:touched(t)
                    break
                end
            end
        else
            self:computeInertia()
        end
        self.lastTouches = {}
    else
        table.insert(self.lastTouches, 1, t)
        if #self.lastTouches > 10 then
            table.remove(self.lastTouches)
        end
        self:scroll(t)
    end
    return true
end

function VerticalScrollContainer:updateScrolling()
    self.inertialVelocity = self.inertialVelocity * self.inertialAcceleration
    self.offset = self.offset + self.inertialVelocity
    
    if self.offset < 0 then
        self.offset = self.offset * self.scrollSpringForce
    elseif self.offset > self.maxOffset then
        self.offset = self.maxOffset + (self.offset - self.maxOffset) * self.scrollSpringForce
    end
end

function VerticalScrollContainer:computeInertia()
    local prevTouchDist = math.abs(self.lastTouches[1].y - self.lastTouches[2].y)
    if prevTouchDist < 3 then
        return
    end
    
    local totalDistance = 0
    for i, t in pairs(self.lastTouches) do
        totalDistance = totalDistance + t.delta.y
    end
    
    local totalTime = self.lastTouches[1].timestamp - self.lastTouches[#self.lastTouches].timestamp
    self.inertialVelocity = clamp((totalDistance / totalTime) / viewer.preferredFPS, -200, 200)
end

function VerticalScrollContainer:scroll(t)
    self.inertialVelocity = 0
    if self.offset < 0 or self.offset > self.maxOffset then
        self.offset = self.offset + t.delta.y/2
    else
        self.offset = self.offset + t.delta.y
    end
end


HorizontalScrollContainer = class()

function HorizontalScrollContainer:init(objects, x, y, w, h, scrollbar) 
    self.x = x or 0
    self.y = y or 0
    self.w = w or WIDTH
    self.h = h or HEIGHT
    
    self.objects = objects
    
    self.active = true
    self.scrollbar = (scrollbar ~= false)
    
    self.maxOffset = 0
    for i = 1, #self.objects do
        self.maxOffset = self.maxOffset + self.objects[i].width
    end
    self.maxOffset = math.max(self.maxOffset-self.w, 0)
    
    self.offset = 0
    
    self.lastTouches = {}
    self.inertialVelocity = 0
    self.inertialAcceleration = 0.95
    self.scrollSpringForce = 0.85
    
    touches.addHandler(self, 0, true)
end

function HorizontalScrollContainer:draw()
    if not self.active then return end
    
    clip(self.x, self.y, self.w, self.h)
    local x = self.x - self.offset
    for i = 1, #self.objects do
        if x > self.x + self.w then
            break
        elseif x > self.x - self.objects[i].width then
            pushMatrix()
            translate(x, self.y)
            self.objects[i]:draw()
            popMatrix()
        end
        x = x + self.objects[i].width
    end
    clip()
    
    if #self.lastTouches == 0 then
        self:updateScrolling()
    end
    
    if not self.scrollbar then return end
    pushStyle()
    strokeWidth(4)
    stroke(200)
    local l = math.min((self.w/(self.maxOffset + self.w))*self.w, self.w)
    local x = map(self.offset, 0, math.max(self.maxOffset, self.w), l/2 + 4, self.w - l/2 - 4) + self.x
    line(math.min(x + l/2, self.x + self.w - 4), self.y + 2, math.max(x - l/2, self.x + 4), self.y + 2)
    popStyle()
end

function HorizontalScrollContainer:checkTouch(t)
    return t.x >= self.x and t.x < self.x + self.w and t.y >= self.y and t.y < self.y + self.h
end

function HorizontalScrollContainer:touched(t)
    if not self.active then return end
    if not self:checkTouch(t) and t.state == BEGAN then
        return false
    end
    if t.state == ENDED or t.state == CANCELLED then
        if #self.lastTouches < 2 then      
            local x = self.x - self.offset
            for i = 1, #self.objects do
                x = x + self.objects[i].width
                if t.x < x then
                    local t = {x = t.x - x, y = t.y}
                    self.objects[i]:touched(t)
                    break
                end
            end
        else
            self:computeInertia()
        end
        self.lastTouches = {}
    else
        table.insert(self.lastTouches, 1, t)
        if #self.lastTouches > 10 then
            table.remove(self.lastTouches)
        end
        self:scroll(t)
    end
    return true
end

function HorizontalScrollContainer:updateScrolling()
    self.inertialVelocity = self.inertialVelocity * self.inertialAcceleration
    self.offset = self.offset + self.inertialVelocity
    
    if self.offset < 0 then
        self.offset = self.offset * self.scrollSpringForce
    elseif self.offset > self.maxOffset then
        self.offset = self.maxOffset + (self.offset - self.maxOffset) * self.scrollSpringForce
    end
end

function HorizontalScrollContainer:computeInertia()
    local prevTouchDist = math.abs(self.lastTouches[1].x - self.lastTouches[2].x)
    if prevTouchDist < 3 then
        return
    end
    
    local totalDistance = 0
    for i, t in pairs(self.lastTouches) do
        totalDistance = totalDistance + t.delta.x
    end
    
    local totalTime = self.lastTouches[1].timestamp - self.lastTouches[#self.lastTouches].timestamp
    self.inertialVelocity = -clamp((totalDistance / totalTime) / viewer.preferredFPS, -200, 200)
end

function HorizontalScrollContainer:scroll(t)
    self.inertialVelocity = 0
    if self.offset < 0 or self.offset > self.maxOffset then
        self.offset = self.offset - t.delta.x/2
    else
        self.offset = self.offset - t.delta.x
    end
end


