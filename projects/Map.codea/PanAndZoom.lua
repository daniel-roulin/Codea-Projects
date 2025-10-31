-- Simple Gesture Class
-- by dadarourou
-- Inspired by:
-- Programming Panning & Zooming by javidx9: https://youtu.be/ZQ8qtAizis4
-- A pan, zoom, and rotate gesture model for touch devices: https://mortoray.com/2016/03/16/a-pan-zoom-and-rotate-gesture-model-for-touch-devices/

PanAndZoom = class()

function PanAndZoom:init(minZoom, maxZoom)
    self.touches = {}
    
    self.minZoom = minZoom or 0.2
    self.maxZoom = maxZoom or 5
    self.zoom = 1
    
    self.offset = vec2(0,0)
end

function PanAndZoom:update()
    if self.touches[1] and self.touches[2] then
        self.currentCenter = self:center()
        self.offset = self.offset - (self.currentCenter-self.startCenter)/self.zoom
        self.startCenter = self.currentCenter
        
        self.currentDist = self:dist()
        self:updateZoom(self.currentDist/self.startDist, self.currentCenter)
        self.startDist = self.currentDist
        
        if self.zoom < self.minZoom then
            self.zoom = self.minZoom
        elseif self.zoom > self.maxZoom then
            self.zoom = self.maxZoom
        end
    elseif self.touches[1] then
        self.currentPos = self.touches[1].pos
        self.offset = self.offset - (self.currentPos-self.startPos)/self.zoom
        self.startPos = self.currentPos
    end
end

function PanAndZoom:updateZoom(zoom, scrnPos)
    scrnPos = scrnPos or vec2(WIDTH/2, HEIGHT/2)
    self.centerBeforeZoom = self:scrnToWrld(scrnPos)
    self.zoom = self.zoom * zoom
    self.centerAfterZoom = self:scrnToWrld(scrnPos)
    self.offset = self.offset + (self.centerBeforeZoom-self.centerAfterZoom)
end

function PanAndZoom:touched(touch)
    if touch.state == ENDED or touch.state == CANCELLED then
        for k,t in pairs(self.touches) do
            if t.id == touch.id then
                self.touches[k] = nil
            end
        end        
        if not self.touches[1] then
            self.touches[1] = self.touches[2]
            self.touches[2] = nil
        end
        if self.touches[1] then
            self.startPos = self.touches[1].pos
        end
    elseif touch.state == BEGAN then
        table.insert(self.touches, touch)
        if self.touches[1] and self.touches[2] then
            self.startDist = self:dist()
            self.startCenter = self:center()
        elseif self.touches[1] then
            self.startPos = self.touches[1].pos
        end
    else
        for k,t in pairs(self.touches) do
            if t.id == touch.id then
                self.touches[k] = touch
            end
        end
    end
end

function PanAndZoom:wrldToScrn(wrld)
    return (wrld - self.offset) * self.zoom
end

function PanAndZoom:scrnToWrld(scrn)
    return (scrn / self.zoom) + self.offset
end

function PanAndZoom:center()
    return (self.touches[1].pos-self.touches[2].pos)/2 + self.touches[2].pos
end

function PanAndZoom:dist()
    return self.touches[1].pos:dist(self.touches[2].pos)
end

