

function Editor:updateScrolling()
    self.inertialVelocity = self.inertialVelocity * self.inertialAcceleration
    self.yOffset = self.yOffset + self.inertialVelocity
    self.lineOffset = clamp(math.floor(self.yOffset/self.lineHeight), 0, #self.lines)
    
    if self.yOffset < 0 then
        self.yOffset = self.yOffset * self.scrollSpringForce
    elseif self.yOffset > self.maxYOffset then
        self.yOffset = self.maxYOffset - (self.maxYOffset - self.yOffset) * self.scrollSpringForce
    end
end

function Editor:computeInertia()
    local prevTouchDist = math.abs(self.lastTouches[1].y - self.lastTouches[2].y)
    if prevTouchDist < 3 then
        return
    end
    
    local totalDistance = 0
    for i, t in pairs(self.lastTouches) do
        totalDistance = totalDistance + t.delta.y
    end
    
    local totalTime = self.lastTouches[1].timestamp - self.lastTouches[#self.lastTouches].timestamp
    self.inertialVelocity = (totalDistance / totalTime) / viewer.preferredFPS
    print(self.inertialVelocity)
end

function Editor:scroll(t)
    self.inertialVelocity = 0
    self.yOffset = self.yOffset + t.delta.y
    self.lineOffset = math.max(math.floor(self.yOffset/self.lineHeight), 0)
end

