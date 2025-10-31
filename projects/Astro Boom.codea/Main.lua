-- Astro-Boom

MENU     = 0
PLAYING  = 1
PAUSED   = 2
GAMEOVER = 3
SETTINGS = 4

function setup()
    viewer.mode = FULLSCREEN
    rectMode(CORNER)
    
    music(asset.downloaded.Game_Music_One.Funk_Blue_Cube,true,0.8)
    
    music.volume = readLocalData("musicVol") or 1
    sfxVol = readLocalData("sfxVol") or 1
    
    backdrop = Stars()
    
    playButton = Button(WIDTH/2,HEIGHT/2.5,270,50,"Play !", "orange", function() state = PLAYING end)
    
    setButton = Button(WIDTH/2,HEIGHT/2.5-70,270,50,"Settings", "blue", function() state = SETTINGS end)
    
    restartButton = Button(WIDTH/2,HEIGHT/2.5-70,270,50,"Restart !", "orange", function() reset() state = PLAYING end)
    
    pausButton = Button(WIDTH-30, HEIGHT-30, 50,50,"", "pause", function()
        if state == PLAYING then
            state = PAUSED
        else
            state = PLAYING
        end
    end)
    
    menuButton = Button(30, HEIGHT-30, 40,40,"", "menu", reset)
    
    resumButton = Button(WIDTH/2,HEIGHT/2.5+70,270,50,"Resume", "orange", function() state = PLAYING end)
    
    quitButton = Button(WIDTH/2, HEIGHT/2.5-140, 270, 50, "Quit", "blue", close)
    
    musicButton = Button(WIDTH/2,HEIGHT/2.5,270,50, "Music: On", "blue", function()
        if music.volume > 0 then
            musicButton.t = "Music: Off"
            musicButton.s = "orange"
            music.volume = 0
        else
            musicButton.t = "Music: On"
            musicButton.s = "blue"
            music.volume = 0.8
        end
        saveLocalData("musicVol", music.volume)
    end)
    if music.volume > 0 then
        musicButton.t = "Music: On"
        musicButton.s = "blue"
    else
        musicButton.t = "Music: Off"
        musicButton.s = "orange"
    end
    
    sfxButton = Button(WIDTH/2,HEIGHT/2.5-70,270,50,"Sound Effect: On", "blue", function()
        if sfxVol > 0 then
            sfxButton.t = "Sound Effects: Off"
            sfxButton.s = "orange"
            sfxVol = 0
        else
            sfxButton.t = "Sound Effects: On"
            sfxButton.s = "blue"
            sfxVol = 1
        end
        saveLocalData("sfxVol", sfxVol)
    end)
    if sfxVol > 0 then
        sfxButton.t = "Sound Effects: On"
        sfxButton.s = "blue"
    else
        sfxButton.t = "Sound Effects: Off"
        sfxButton.s = "orange"
    end
    
    colorList = {}
    
    colorList[1] = color(253, 255, 0, 255)
    colorList[2] = color(255, 188, 0, 255)
    colorList[3] = color(255, 75,  0, 255)
    colorList[4] = color(255, 0, 157, 255)
    colorList[5] = color(252, 0, 255, 255)
    colorList[6] = color(138, 0, 255, 255)
    colorList[7] = color(0, 159, 255, 255)
    colorList[8] = color(0, 247, 255, 255)
    colorList[9] = color(0, 255, 158, 255)
    colorList[10] = color(41, 255, 0, 255)
    
    reset()
end

function reset()
    state = MENU
    
    player = Player(WIDTH/2, HEIGHT/3)
    score = 0
    life = 5
    
    bullets = {}
    coolDown = 0
    
    reloadTime = 7
    bulletSpeed = 5
    
    brickSpeed = 0.2
    brickLife = 10
    
    initBricks()
    
    asteroides = {}
    astAcc = -2
    rnd = math.random(0,100000000000)
    
    emitter = Emitter()
end

function draw()
    if state == MENU then --------------------
        backdrop:draw()
        
        pushMatrix()
        translate(WIDTH/4, HEIGHT/3*2+15)
        rotate(-10)
        sprite(asset.builtin.Space_Art.Cloudy_Nebula,0,0,180,110)
        popMatrix()
        
        pushMatrix()
        translate(WIDTH/2, HEIGHT/4*3-10)
        rotate(10+math.sin(ElapsedTime*2)*2)
        
        textMode(CENTER)
        font("Futura-CondensedExtraBold")
        fontSize(40)
        fill(255, 255, 255, 255)
        text("ASTRO-BOOOM !", 0,0)
        popMatrix()
        
        playButton:draw()
        setButton:draw()
        quitButton:draw()
        
    elseif state == PLAYING then -------------
        backdrop:draw()
        
        checkCollisions()
        
        for i, bullet in pairs(bullets) do
            bullet:update()
            bullet:draw()
        end
        
        for i,brick in pairs(bricks) do
            brick:update()
            if brick.y - 10 < HEIGHT then
                brick:draw()
            end
        end
        
        player:update()
        player:draw()
        
        for ind,asteroide in pairs(asteroides) do
            asteroide:draw()
        end
        
        textMode(CORNER)
        font("Arial-BoldMT")
        fontSize(25)
        fill(255, 255, 255, 255)
        text("Score: "..score, 10, 40)
        
        for x = 0,life-1 do
            sprite(asset.builtin.Space_Art.Red_Ship_Icon,WIDTH - (x*40)-20,55,35,30)
        end
        
        emitter:draw()
        
        pausButton:draw()
        
    elseif state == PAUSED then --------------
        background(39, 39, 50, 64)
        
        textMode(CENTER)
        font("Futura-CondensedExtraBold")
        fontSize(40)
        fill(255, 255, 255, 255)
        text("PAUSE", WIDTH/2, HEIGHT-100)
        
        pausButton:draw()
        menuButton:draw()
        resumButton:draw()
        sfxButton:draw()
        musicButton:draw()
        quitButton:draw()
    elseif state == GAMEOVER then ------------
        backdrop:draw()
        
        translate(WIDTH/2, HEIGHT-100)
        rotate(-25)
        sprite(asset.builtin.Space_Art.Red_Ship_Damaged,0,0,200,160)
        resetMatrix()
        
        textMode(CENTER)
        font("Futura-CondensedExtraBold")
        fontSize(40)
        fill(255, 255, 255, 255)
        text("GAME OVER", WIDTH/2, HEIGHT-225)
        
        font("Arial-BoldMT")
        fontSize(30)
        text("Score: "..score, WIDTH/2, HEIGHT/2)
        
        menuButton:draw()
        restartButton:draw()
        quitButton:draw()
        
    elseif state == SETTINGS then ------------
        background(39,39,39)
        
        musicButton:draw()
        sfxButton:draw()
        menuButton:draw()
    end
end

function touched(t)
    if state == MENU then
        playButton:touched(t)
        setButton:touched(t)
        quitButton:touched(t)
    elseif state == PLAYING then
        if pausButton:touched(t) then
            return
        end
        player:touched(t)
        pausButton:touched(t)
    elseif state == PAUSED then
        pausButton:touched(t)
        resumButton:touched(t)
        menuButton:touched(t)
        musicButton:touched(t)
        sfxButton:touched(t)
        quitButton:touched(t)
    elseif state == SETTINGS then
        musicButton:touched(t)
        sfxButton:touched(t)
        menuButton:touched(t)
    elseif state == GAMEOVER then
        menuButton:touched(t)
        restartButton:touched(t)
        quitButton:touched(t)
    end
end

function initBricks()
    
    brickEspacement = 15
    brickPerRow = 3
    startRows = 100
    brickWidth = (WIDTH/brickPerRow)-
    brickEspacement
    brickHeight = 30
    
    bricks = {}
    
    for y = 1, startRows do
        for x = 0, brickPerRow-1 do
            table.insert(bricks, Brick((x*(brickWidth+brickEspacement))+brickEspacement/2,HEIGHT - (y-startRows+3)*(brickHeight+brickEspacement), brickWidth, brickHeight, c))
        end
    end
end

function checkCollisions()
    for brInd,br in pairs(bricks) do
        for buInd,bu in pairs(bullets) do
            if  bu.x + bu.w/2 > br.x
            and bu.x - bu.w/2 < br.x + br.w
            and bu.y + bu.h/2 > br.y
            and bu.y - bu.h/2 < br.y + br.h
            then
                sound(SOUND_HIT, 18842,sfxVol)
                
                table.remove(bullets, buInd)
                br.life = br.life - 1
                
                emitter:addEx(bu.x, br.y, 30, 15, 100, color(255,0,0,255))
                
                if br.life <= 0 then
                    
                    sound(SOUND_EXPLODE, 27987,sfxVol)
                    
                    emitter:addEx(br.x+br.w/2, br.y+br.h/2, 100, 25, 200, color(255,255,255,255))
                    
                    table.remove(bricks,brInd)
                    score = score + 1
                    
                    table.insert(asteroides, Asteroide(br.x+br.w/2, br.y))
                    
                end
            end
        end
    end
    
    for ind,ast in pairs(asteroides) do
        if intersects(ast.pos.x, ast.pos.y, ast.size-ast.size/10, player.x, player.y-10, 90, 30) or intersects(ast.pos.x, ast.pos.y, ast.size-ast.size/10, player.x, player.y, 20, 75) then
            table.remove(asteroides, ind)
            life = life - 1
            
            emitter:addEx(ast.pos.x, ast.pos.y, 200, 20, 300, color(255,100,0,255))
            
            emitter:addEx(WIDTH - ((life)*40)-20, 55, 100, 30, 100, color(255,0,0,255))
        end
        
        if life <= 0 then
            state = GAMEOVER
        end
        
        if ast.pos.y < -70 then
            table.remove(asteroides, ind)
        end
    end
end

function intersects(cx, cy, cr, rx, ry, rw, rh)
    
    local cd = vec2(0,0)
    
    cd.x = math.abs(cx - rx)
    cd.y = math.abs(cy - ry)
    
    if cd.x > rw/2 + cr/2 then return false end
    if cd.y > rh/2 + cr/2 then return false end
    
    if cd.x <= rw/2 then return true end
    if cd.y <= rh/2 then return true end
    
    local cdSq = (cd.x - rw/2)^2 + (cd.y - rh/2)^2
    
    return cdSq <= ((cr/2)^2)
end


function lerp(pos1, pos2, perc)
    return (1-perc)*pos1 + perc*pos2
end