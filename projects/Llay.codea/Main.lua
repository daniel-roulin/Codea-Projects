-- Llay

-- With complete text support

function setup()
    viewer.mode = FULLSCREEN
    
    ui = Rectangle(40)
    :setPosition(0, 0)
    :setWidth(FIXED, WIDTH)
    :setHeight(FIXED, HEIGHT)
    :setAlignmentX(CENTER)
    :setAlignmentY(CENTER)
    :setChildren({
        Rectangle(color(43, 67, 196))
        :setWidth(FIXED, 800)
        :setHeight(FIT)
        :setChildren({
            Text("One Two Three Four Five")
            :setFontSize(40)
            :setWidth(GROW),
            
            Rectangle(color(236, 223, 18))
            :setHeight(FIT)
            :setWidth(PERC, 1/3)
            :setChildren({
                Text("Lorem Ipsum cupiditate quidem repellendus quos. Doloribus magnam commodi amet. Adipisci est porro voluptatibus quasi non nulla et. Sit voluptas explicabo doloribus et. Neque sunt et hic maxime qui voluptas vero non. Consequatur sed itaque nam similique est harum neque rerum. Eos enim ut cupiditate ipsa quidem cupiditate et exercitationem. Velit ipsa officia modi magnam architecto optio ea. Molestias similique et voluptas nisi a nostrum.")
                :setWidth(GROW)
            }),
            
            Rectangle(color(26, 191, 236))
            :setHeight(GROW)
            :setWidth(PERC, 1/3)
            :setChildren({
                Text("Six Seven Eight Nine Ten")
                :setFontSize(40)
                :setWidth(GROW)
                :setHeight(GROW)
                :setAlignmentY(BOTTOM)
                :setAlignmentX(RIGHT)
            }),
        })
    })
    
    ui:layout()
end

function draw()
    ui:render()
end

function copy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
    return res
end

--[[
TODO:
- Image elements
- Handling touches (lib) and Buttons
- Library of buttons: toggles, slider, one options, 
- Scrolling containers
- Maps

Primitives:
- Text field
- File explorer
- Color Picker
- Project browser
]]


