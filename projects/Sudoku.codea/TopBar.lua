TopBar = class()

function TopBar:init()
    self.pc = accent1
    self.rc = red
end

function TopBar:draw()
    -- Background
    fill(accent2)
    rect(0, HEIGHT-barW, WIDTH, barW)
    
    -- Pause
    pushMatrix()
    translate(WIDTH-20, HEIGHT-barW/2)
    
    stroke(self.pc)
    strokeWidth(7)
    line(10, 15, 10, -15)
    line(-10, 15, -10, -15)
    popMatrix()
    
    -- Restart
    noStroke()
    fill(self.rc)
    ellipse(WIDTH-60, HEIGHT-barW/2, 40)
    fontSize(30)
    fill(white1)
    text("R", WIDTH-60, HEIGHT-barW/2)
    
    -- Timer
    mn = math.floor(time/60)
    sc = math.floor(time%60)
    if sc < 10 then
        sc = "0"..sc
    end
    if mn < 10 then
        mn = "0"..mn
    end
    
    fontSize(35)
    fill(white1)
    text(mn..":"..sc, WIDTH/2, HEIGHT-barW/2)
    
    noStroke()
end

function TopBar:touched(t)
    if t.state == BEGAN then
        if t.x < WIDTH-50 then
            self.rc = dark1
            restart()
        else
            self.pc = dark1
            if state == PLAY then
                state = PAUSE
            else
                state = PLAY
            end
        end
    else
        self.pc = accent1
        self.rc = red
    end
end
