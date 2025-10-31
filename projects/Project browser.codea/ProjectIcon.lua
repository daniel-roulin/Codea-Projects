Project = class()

function Project:init(folder, name)
    self.width = 70
    self.height = self.width + 5 + 34
    self.folder = folder
    self.name = name 
    self.isSetup = false
end

function Project:setup()
    self.maxTextHeight = 34
    self.textToImg = 2
    self:layout()
    self.asset = self:getAsset()
    self.icon = self:getIcon()
end

function Project:draw()
    if not self.isSetup then
        self:setup()
        self.isSetup = true
    end
    
    font("ArialMT")
    fontSize(15)
    textWrapWidth(self.width)
    textAlign(CENTER)
    textMode(CENTER)
    local w, h = textSize(self.displayText)
    text(self.displayText, self.width/2, self.iconBase - h/2 - 5)
    
    spriteMode(CORNER)
    self.icon:draw(0, self.iconBase, self.width, 0.1)
end

function Project:getAsset()
    local root
    local folderName
    if self.name == string.sub(asset.name, 1, -7) then      
        return asset
    elseif self.folder == "Documents" then
        root = asset
        folderName = "documents"
    else
        root = asset.documents
        folderName = self.folder
    end
    local assetName = string.gsub(self.name, "[ .]", "_")
    if string.match(string.sub(assetName, 1, 1), "%d") then
        assetName = "_"..assetName
    end
    if root[folderName] == nil then
        error("Unable to find folder "..self.folder)
    end
    
    -- Normal path
    local testAsset = root[folderName][assetName]
    if testAsset ~= nil then
        return testAsset
    end
    
    -- Sometimes we need to append "_codea" to the name 
    testAsset = root[folderName][assetName.."_codea"]
    if testAsset ~= nil then
        return testAsset
    end
    
    print("No match for ")
    -- And sometimes we just dont have a choice :(
    -- This happens when the name contains a special character like - or ' or an emoji
    for i, v in pairs(root[folderName].all) do
        if v.type == "project" and string.sub(v.name, 1, -7) == self.name then
            return v
        end
    end
    error("Unable to find project "..self.name)
end

function Project:getIcon()
    for k,v in pairs(self.asset.all) do
        if (string.sub(v.name, 1, 5)  == "Icon." or string.sub(v.name, 1, 5)  == "Icon@") and v.type == "sprites" then
            return rSprite(v)
        end
    end
    
    local icon = image(100, 100)
    pushMatrix()
    resetMatrix()
    setContext(icon)
    spriteMode(CENTER)
    sprite(asset.documents.Assets.Assets_Picker.ProjectIcon,50,50,100,100)
    
    textMode(CENTER)
    textWrapWidth(200)
    font("Vegur-Light")
    fontSize(90)
    
    fill(255)
    text(string.sub(self.name, 0, 2), 60, 50)
    setContext()
    popMatrix()
    
    return rSprite(icon)
end

function Project:touched(t)
    print(self.name)
end

function Project:layout()
    self.iconBase = self.maxTextHeight + self.textToImg
    font("ArialMT")
    fontSize(15)
    textWrapWidth(self.width)
    self.displayText = cropText(self.name, self.maxTextHeight)
end



