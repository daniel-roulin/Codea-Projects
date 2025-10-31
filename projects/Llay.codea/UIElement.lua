UIElement = class()

-- Sizing modes
FIT = 0
GROW = 1
FIXED = 2
PERC = 3

-- Alignment modes
LEFT = 0
RIGHT = 1
CENTER = 2
TOP = 3
BOTTOM = 4

-- Layout directions
LEFT_TO_RIGHT = 0
RIGHT_TO_LEFT = 1
TOP_TO_BOTTOM = 2
BOTTOM_TO_TOP = 3

function UIElement:init()
    -- Position
    self.x = 0
    self.y = 0
    
    -- Dimensions
    self.w = 0
    self.h = 0
    self.widthSizing = FIT
    self.heightSizing = FIT
    self.wPerc = 0
    self.hPerc = 0
    
    -- Padding
    self.pt = 10 -- top
    self.pb = 10 -- bottom
    self.pl = 10 -- left
    self.pr = 10 -- right
    
    -- Gap between children elements
    self.gap = 10
    
    -- Child elements
    self.children = {}
    
    -- Child alignment
    self.alignmentX = LEFT
    self.alignmentY = TOP
    
    -- Layout direction
    -- Default direction is LEFT_TO_RIGHT
    self.isHorizontal = true
    self.isReversed = false   -- Reversed is considered with respect to the coordonate system, so top to bottom is actually reversed
end

-- Only has effect on the root element
function UIElement:setPosition(x, y)
    self.x = x
    self.y = y
    return self
end

function UIElement:setWidth(mode, width)
    self.widthSizing = mode
    if mode == FIXED and width ~= nil then
        self.w = width
    elseif mode == PERC and width ~= nil then
        self.wPerc = width
    end
    return self
end

function UIElement:setHeight(mode, height)
    self.heightSizing = mode
    if mode == FIXED and height ~= nil then
        self.h = height
    elseif mode == PERC and height ~=nil then
        self.hPerc = height
    end
    return self
end

function UIElement:setGap(gap)
    self.gap = gap
    return self
end

function UIElement:setChildren(children)
    self.children = children
    return self
end

-- Arguments work like css padding
function UIElement:setPadding(...)
    local args = {...}
    if #args == 1 then
        self.pt = args[1]
        self.pb = args[1]
        self.pl = args[1]
        self.pr = args[1]
    elseif #args == 2 then
        self.pt = args[1]
        self.pb = args[1]
        self.pl = args[2]
        self.pr = args[2]
    elseif #args == 3 then
        self.pt = args[1]
        self.pl = args[2]
        self.pr = args[2]
        self.pb = args[3]
    elseif #args == 4 then
        self.pt = args[1]
        self.pr = args[2]
        self.pb = args[3]
        self.pl = args[4]
    end
    return self
end

function UIElement:setAlignmentX(mode)
    self.alignmentX = mode
    return self
end

function UIElement:setAlignmentY(mode)
    self.alignmentY = mode
    return self
end

function UIElement:setDirection(direction)
    self.isHorizontal = direction == LEFT_TO_RIGHT or direction == RIGHT_TO_LEFT
    self.isReversed = direction == RIGHT_TO_LEFT or direction == TOP_TO_BOTTOM
    return self
end

function UIElement:fitSizing(onXAxis, parent)
    -- Fit sizing is done depth first
    for i, child in pairs(self.children) do
        child:fitSizing(onXAxis, self)
    end
    
    -- This is done by every parent to correct for padding and child gap
    if #self.children > 0 then
        local childGaps = (#self.children - 1) * self.gap
        if onXAxis and self.isHorizontal and self.widthSizing == FIT then
            self.w = self.w + self.pl + self.pr + childGaps
        elseif not onXAxis and not self.isHorizontal and self.heightSizing == FIT then
            self.h = self.h + self.pb + self.pt + childGaps
        end
    end
    
    -- This is done by every children to make their parent fit their size
    if not parent then return end
    if onXAxis and parent.widthSizing == FIT then
        if parent.isHorizontal then
            parent.w = parent.w + self.w
        else
            parent.w = math.max(parent.w, self.w + parent.pl + parent.pr) 
        end
    elseif not onXAxis and parent.heightSizing == FIT then
        if parent.isHorizontal then
            parent.h = math.max(parent.h, self.h + parent.pb + parent.pt)
        else
            parent.h = parent.h + self.h
        end
    end
end

-- Remaining space left in the element, with the on axis direction corrected for the size of its children
function UIElement:remainingSize()
    local remainingWidth = self.w
    local remainingHeight = self.h
    remainingWidth = remainingWidth - self.pl - self.pr
    remainingHeight = remainingHeight - self.pt - self.pb
    
    local childGap = (#self.children - 1) * self.gap
    if self.isHorizontal then
        for i, child in pairs(self.children) do
            remainingWidth = remainingWidth - child.w
        end
        remainingWidth = remainingWidth - childGap
    else
        for i, child in pairs(self.children) do
            remainingHeight = remainingHeight - child.h
        end
        remainingHeight = remainingHeight - childGap
    end
    
    return remainingWidth, remainingHeight
end

function UIElement:growPercSizing(onXAxis)
    -- Percentage sizing
    local innerSpaceW = self.w - self.pl - self.pr
    local innerSpaceH = self.h - self.pt - self.pb
    local childGaps = (#self.children - 1) * self.gap
    if self.isHorizontal then
        innerSpaceW = innerSpaceW - childGaps
    else
        innerSpaceH = innerSpaceH - childGaps
    end
    for i, child in pairs(self.children) do
        if child.widthSizing == PERC and onXAxis then
            child.w = child.wPerc * innerSpaceW
        end
        if child.heightSizing == PERC and not onXAxis then
            child.h = child.hPerc * innerSpaceH
        end
    end
    
    -- Grow sizing
    local remainingWidth, remainingHeight = self:remainingSize()
    local growingChildren = 0
    if self.isHorizontal then
        for i, child in pairs(self.children) do
            if child.widthSizing == GROW then
                growingChildren = growingChildren + 1 
            end
        end
        for i, child in pairs(self.children) do
            if child.widthSizing == GROW and onXAxis then
                child.w = child.w + remainingWidth/growingChildren
            end
            if child.heightSizing == GROW and not onXAxis then
                child.h = remainingHeight
            end
        end
    else
        for i, child in pairs(self.children) do
            if child.heightSizing == GROW then
                growingChildren = growingChildren + 1 
            end
        end
        for i, child in pairs(self.children) do
            if child.heightSizing == GROW and not onXAxis then
                child.h = child.h + remainingHeight/growingChildren
            end
            if child.widthSizing == GROW and onXAxis then
                child.w = remainingWidth
            end
        end
    end
    
    -- Grow and perc sizing is done breadth first
    for i, child in pairs(self.children) do
        child:growPercSizing(onXAxis)
    end
end

function UIElement:positionChildren()
    local remainingWidth, remainingHeight = self:remainingSize()
    
    if self.isHorizontal and not self.isReversed then
        local leftOffset = self.pl
        if self.alignmentX == CENTER then
            leftOffset = leftOffset + remainingWidth/2
        elseif self.alignmentX == RIGHT then
            leftOffset = leftOffset + remainingWidth 
        end
        
        for i, child in pairs(self.children) do
            child.y = self.pb
            if self.alignmentY == CENTER then
                child.y = child.y + (remainingHeight - child.h)/2
            elseif self.alignmentY == TOP then
                child.y = child.y + remainingHeight - child.h
            end
            
            child.x = leftOffset
            leftOffset = leftOffset + child.w + self.gap
            child:positionChildren()
        end
    elseif self.isHorizontal and self.isReversed then
        local rigthOffset = self.w - self.pr
        if self.alignmentX == CENTER then
            rigthOffset = rigthOffset - remainingWidth/2
        elseif self.alignmentX == LEFT then
            rigthOffset = rigthOffset - remainingWidth 
        end
        
        for i, child in pairs(self.children) do
            child.y = self.pb
            if self.alignmentY == CENTER then
                child.y = child.y + (remainingHeight - child.h)/2
            elseif self.alignmentY == TOP then
                child.y = child.y + remainingHeight - child.h
            end
            
            child.x = rigthOffset - child.w
            rigthOffset = rigthOffset - child.w - self.gap
            child:positionChildren()
        end
    elseif not self.isHorizontal and not self.isReversed then
        local bottomOffset = self.pb
        if self.alignmentY == CENTER then
            bottomOffset = bottomOffset + remainingHeight/2
        elseif self.alignmentY == TOP then
            bottomOffset = bottomOffset + remainingHeight 
        end
        for i, child in pairs(self.children) do
            child.x = self.pl
            if self.alignmentX == CENTER then
                child.x = child.x + (remainingWidth - child.w)/2
            elseif self.alignmentX == RIGHT then
                child.x = child.x + remainingWidth - child.w
            end
            
            child.y = bottomOffset
            bottomOffset = bottomOffset + child.h + self.gap
            child:positionChildren()
        end
    else
        local topOffset = self.h - self.pt
        if self.alignmentY == CENTER then
            topOffset = topOffset - remainingHeight/2
        elseif self.alignmentY == BOTTOM then
            topOffset = topOffset - remainingHeight 
        end
        for i, child in pairs(self.children) do
            child.x = self.pl
            if self.alignmentX == CENTER then
                child.x = child.x + (remainingWidth - child.w)/2
            elseif self.alignmentX == RIGHT then
                child.x = child.x + remainingWidth - child.w
            end
            
            child.y = topOffset - child.h
            topOffset = topOffset - child.h - self.gap
            child:positionChildren()
        end
    end
end

-- Positions and sizes all of the children of this element
function UIElement:layout()
    -- Width sizing
    ui:fitSizing(true)
    ui:growPercSizing(true)
    
    -- Height sizing
    ui:fitSizing(false)
    ui:growPercSizing(false)
    
    -- Positioning
    ui:positionChildren()
end

function UIElement:render()
    translate(self.x, self.y)
    
    pushStyle()
    resetStyle()
    pushMatrix()
    self:draw()
    popMatrix()
    popStyle()
    
    for i, child in pairs(self.children) do
        pushStyle()
        resetStyle()
        pushMatrix()
        child:render()
        popMatrix()
        popStyle()
    end
end
