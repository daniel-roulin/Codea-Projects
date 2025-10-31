Image = class(UIElement)

function Image:init(source)
    UIElement.init(self)
    self:setSource(source)
end

function Image:setSource(source)
    self.source = source
    TODO: Set default size here
    + find a way to integrate aspect ratio somewhere
    return self
end

function Image:draw()
    sprite(self.source, self.w, self.h)
end