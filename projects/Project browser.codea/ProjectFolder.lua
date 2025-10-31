
local OPENNING = 0
local OPEN = 1
local CLOSING = 2
local CLOSE = 3

ProjectFolder = class()

function ProjectFolder:init(name, objects)
    self.name = name
    self.objects = objects
    self.minSpacing = 10
    self.textH = 34
    self:layout()

    self.anim = nil
    self.state = OPEN
    if self.state == OPEN then
        self.arrowRotation = -45
        self.transparency = 255
        self.height = self.openHeight
    else
        self.arrowRotation = -45-90
        self.transparency = 0
        self.height = self.closeHeight
    end
end

function ProjectFolder:draw(boxY, boxH)
    -- It's easier to start drawing from the bottom of the text/top of the projects
    self.projectsTop = self.height - self.textH - self.minSpacing
    translate(self.spacing*2, self.projectsTop)
    
    -- Folder name
    fill(255)
    font("Arial-BoldMT")
    fontSize(30)
    textMode(CORNER)
    textWrapWidth(WIDTH-self.spacing*2-self.textH)
    text(self.displayText, 0, 0)
    
    -- Arrow
    pushMatrix()
    translate(-self.spacing*4 + WIDTH - self.textH/2, self.textH/2)
    rotate(self.arrowRotation)
    stroke(255)
    strokeWidth(4)
    line(-7, -7, 7, -7)
    line(7, -7, 7, 7)
    popMatrix()
    
    -- Projects
    if self.state == CLOSE then return end
    pushStyle()
    for i, object in pairs(self.objects) do
        y = -math.ceil(i / self.objectsPerRow) * (self.spacing + self.objH)
        x = ((i - 1) % self.objectsPerRow) * (self.spacing + self.objW)
        if self.projectsTop + y < boxY - self.objH then
            break
        elseif self.projectsTop + y < boxY + boxH then
            pushMatrix()
            translate(x, y) 
            stroke(255, self.transparency)
            fill(255, self.transparency)
            tint(255, self.transparency)
            object:draw(self.transparency) 
            popMatrix()
        end
    end  
    popStyle()
end

function ProjectFolder:open()
    if self.anim then
        tween.stop(self.anim)
    end
    self.state = OPENNING
    self.anim = tween(0.3, self, {
        arrowRotation = -45,
        transparency = 255,
        height = self.openHeight,
    }, {}, function()
        self.state = OPEN
    end)
end

function ProjectFolder:close()
    if self.anim then
        tween.stop(self.anim)
    end
    self.state = CLOSING
    self.anim = tween(0.3, self, {
        arrowRotation = -45 - 90,
        transparency = 0,
        height = self.closeHeight,
    }, {}, function()
        self.state = CLOSE
    end)
end

function ProjectFolder:touched(t)
    if not (t.x >= self.spacing*2 and t.x <= WIDTH-self.spacing*2) then return end
    if t.y >= self.height - self.textH then
        if self.state == OPEN or self.state == OPENNING then
            self:close()
        else
            self:open()
        end
    else
        local x = nil
        for i = 0, self.objectsPerRow-1 do
            if t.x >= self.spacing*2 + (self.spacing+self.objW)*i and t.x <= self.spacing*2 + self.objW + (self.spacing+self.objW)*i then
                x = i
                break
            end
        end 
        local y = nil
        for i = 0, self.rows-1 do
            if t.y >= (self.spacing+self.objH)*i and t.y <= self.objH + (self.spacing+self.objH)*i then
                y = i
                break
            end
        end
        if x and y then
            local i = (self.rows-y-1)*self.objectsPerRow + x + 1
            if self.objects[i] then
                self.objects[i]:touched(t)
            end
        end
    end
end

function ProjectFolder:layout()
    self.objW = self.objects[1].width
    self.objH = self.objects[1].height
    self.objectsPerRow = math.floor((WIDTH - 3*self.minSpacing)/(self.objW + self.minSpacing))
    self.rows = math.ceil(#self.objects / self.objectsPerRow)
    self.spacing = (WIDTH-(self.objW*self.objectsPerRow)) / (self.objectsPerRow + 3)
    self.openHeight = self.textH + (self.objH + self.spacing)*self.rows + self.spacing + self.minSpacing
    self.closeHeight = self.textH + self.spacing + self.minSpacing
    font("Arial-BoldMT")
    fontSize(30)
    textWrapWidth(WIDTH-self.spacing*2-self.textH)
    self.displayText = cropText(self.name, self.textH)
end
