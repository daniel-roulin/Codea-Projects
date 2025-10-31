-- Asset Picker

function setup()
    -- You can provide a handler function as a first parameter
    -- This function gets called whenever you click on an item that is neither a folder nor a project
    openAsset = function(asst)
        print(asst.path)
    end
     
    -- Initialization may take a little while
    assetPicker = AssetPicker(openAsset)  
    
    -- Opens the interface
    assetPicker:show()
    
    -- Closes the interface
    -- The interface also closes if you click on Done
    -- assetPicker:close()
    
    -- Returns true if the interface is shown
    parameter.watch("assetPicker:isActive()")
    -- print(assetPicker.topY)
end

function draw()
    background(40)
    assetPicker:draw()
end

function touched(t)
    assetPicker:touched(t)
    if t.state == ENDED then
        assetPicker:show()
    end
end

