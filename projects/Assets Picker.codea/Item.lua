Item = class()

function Item:init(content)
    self.name = content.name
    self.type = content.type
    self.isTouch = false
    
    if self.type == "folder" or self.type == "project" then
        self.content = {}
        for k,item in pairs(content.all) do
            table.insert(self.content, Item(item))
        end
    else
        self.content = content
    end
end

function Item:draw() 
    textMode(CORNER)
    spriteMode(CORNER)
    textWrapWidth(1000)
    
    if self.isTouch then
        fill(150)
        rect(0,0, WIDTH, 60)
    end
    
    stroke(100)
    strokeWidth(1)
    line(0, 0, WIDTH, 0)
    
    font("SourceSansPro-Bold")
    fontSize(25)
    fill(47, 72, 131)
    text(self.name, 75, 25)
    
    font("SourceSansPro-Light")
    fontSize(20)
    fill(100)
    text(self.type, 75, 5)
    if self.icon then
        sprite(self.icon, 10, 5, 50, 50)
    end
end

function Item:generateIcon()
    if self.type == "folder" or self.type == "project" then
        for k,v in pairs(self.content) do
            if (string.sub(v.name, 1, 5)  == "Icon." or string.sub(v.name, 1, 5)  == "Icon@") and v.type == "sprites" then
                return v.content
            end
        end
        if self.type == "folder" then 
          return asset.FolderIcon
        end
        local icon = image(50,50)
        setContext(icon)
        spriteMode(CENTER)
        sprite(asset.documents.icon,25,25,50,50)
        
        textMode(CENTER)
        font("Vegur-Light")
        fontSize(45)
        
        fill(255)
        text(string.sub(self.name, 0, 2), 30, 25)
        setContext()
        return icon
    elseif self.type == "sprites" then
        local w,h = spriteSize(self.content)
        local s = math.max(w,h)
        local icon = image(s,s)
        setContext(icon)
        spriteMode(CENTER)
        sprite(self.content, s/2, s/2)
        setContext()
        return icon
    elseif self.type == "text" then
        local txt = readText(self.content)
        local icon = image(200, 200)
        setContext(icon)
        background(200)
        
        font("Inconsolata")
        fontSize(16)
        fill(0)
        textMode(CORNER)
        textWrapWidth(300)
        
        txt = string.sub(txt, 0, 700)
        local w,h = textSize(txt)
        text(txt, 0, 200-h)
        setContext()
        return icon
    elseif self.content.ext then
        local icon = image(50,50)
        setContext(icon)
        stroke(47, 72, 131)
        strokeWidth(4)
        fill(200)
        rect(-1,-1,52,52)
        
        textMode(CORNER)
        font("Vegur-Light")
        fontSize(30)
        
        fill(47, 72, 131)
        text("."..self.content.ext, 0, 0)
        
        setContext()
        return icon
    end
end

