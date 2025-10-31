-- Editor

function setup()
    viewer.mode = FULLSCREEN
    parameter.watch("1/DeltaTime")
    --[[
    parameter.watch("editor.cursorCol")
    parameter.watch("editor.cursorLine")
    ]]
     
    editor = Editor()
    editor:draw()
    
    showKeyboard()
    
    sound(SOUND_PICKUP, 12344)
end

function draw()
    editor:draw()
end

function touched(t)
    editor:touched(t) 
end

function keyboard(k)
    editor:keyboard(k)
end

--[[
TODO:
    Main class: Editor

    Classes:
    Line class
    Cursor class
    

]]



