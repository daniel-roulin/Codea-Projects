-- Sudoku

PLAY = 0
PAUSE = 1

function setup()
    font("HelveticaNeue-Light")
    barW = 50
    
    time = 0
    state = PLAY
    
    accent1 = color(29, 133, 104)
    accent2 = color(32, 88, 72)
    
    dark1 = color(60)
    dark2 = color(40)
    
    white1 = color(200)
    white2 = color(150)
    
    red = color(200, 27, 16)
    
    keyboard = Keyboard()
    soduko = Soduko()
    topBar = TopBar()
    
    parameter.boolean("switch", false)
end

function draw()
    background(0)
    topBar:draw()
    keyboard:draw()
    soduko:draw()
    
    if state == PAUSE then
        fill(0,0,0,200)
        rect(0,0,WIDTH, HEIGHT-barW)
        
        fontSize(50)
        fill(white1)
        text("Pause", WIDTH/2, HEIGHT/3*2)
    else
        time = time + DeltaTime
    end
end

function touched(t)
    if state == PLAY then
        if t.y < HEIGHT-WIDTH-barW then
            keyboard:touched(t)
        elseif t.y < HEIGHT-barW then
            soduko:touched(t)
        else
            topBar:touched(t)
        end
    else
        if t.y > HEIGHT - barW then
            topBar:touched(t)
        end
    end
end

