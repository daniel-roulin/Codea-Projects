-- Snake

function setup()
    viewer.mode = FULLSCREEN
    
    width = 16
    height = 30
    length = 4
    score = 0
    direction = vec2(0, 1)
    snake = {}
    for i = 1, length do
        table.insert(snake, vec2(width/2 + length - i, height/2))
    end
    new_apple()
    tick(1/8)
end

function new_apple()
    while true do
        apple = vec2(math.random(0, width-1), math.random(0, height-1))
        inside = false
        for i, part in pairs(snake) do
            if part.pos == apple then
                inside = true
            end
        end
        if not inside then
            return
        end
    end
end

function tick(time)
    new_head_pos = snake[1] + direction
    if new_head_pos.x < 0 or new_head_pos.y < 0 or new_head_pos.x >= width or new_head_pos.y >= height then
        print("You died")
        -- return
    end
    for i, part in pairs(snake) do
        if part == new_head_pos then
            print("You died")
            return
        end
    end
    if new_head_pos == apple then
        new_apple()
        score = score + 1
    else
        table.remove(snake)
    end
    table.insert(snake, 1, new_head_pos)
    tween.delay(time, function()
        tick(time)
    end)
end

function draw()
    background(40)
    
    fill(65)
    font("HelveticaNeue")
    fontSize(200)
    textAlign(CENTER)
    text(score, WIDTH/2, HEIGHT/2)
    
    size = math.min(WIDTH/width, HEIGHT/height)
    startx = (WIDTH-size*width)/2
    starty = (HEIGHT-size*height)/2
    
    fill(0)
    rect(-1, -1, WIDTH+2, starty+1)
    rect(-1, HEIGHT-starty, WIDTH+2, starty+2)
    rect(-1, -1, startx+1, HEIGHT+2)
    rect(WIDTH-startx, -1, startx+2, HEIGHT+2)
    
    translate(startx, starty)
    for i, part in pairs(snake) do
        fill(74, 172, 74)
        rect(part.x * size, part.y * size, size-1, size-1)
    end
    fill(204, 42, 45)
    ellipse(apple.x*size + size/2, apple.y*size + size/2, size-1)
end

function touched(t)
    if t.state == BEGAN then
        startpos = t.pos
    elseif t.state == ENDED then
        touchdir = t.pos - startpos
        touchdir = touchdir:normalize()
        sqrt2 = math.cos(math.pi/4)
        if touchdir.x > sqrt2 then
            newdirection = vec2(1, 0)
        elseif touchdir.x < -sqrt2 then
            newdirection = vec2(-1, 0)
        elseif touchdir.y > sqrt2 then
            newdirection = vec2(0, 1)
        else
            newdirection = vec2(0, -1)
        end
        if newdirection ~= -direction then
            direction = newdirection
        end
    end
end

