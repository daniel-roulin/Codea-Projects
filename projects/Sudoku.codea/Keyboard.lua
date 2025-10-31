Keyboard = class()

function Keyboard:init()
    self.buttons = {}
    for x = 0,4 do
        self.buttons[x] = Button((WIDTH/5*x) + (WIDTH/5)/2, (HEIGHT-WIDTH-10)/3*2, x+1)
    end
    for x = 5,9 do
        self.buttons[x] = Button((WIDTH/5*(x-5)) + (WIDTH/5)/2, (HEIGHT-WIDTH-10)/3, x+1)
    end
    self.buttons[9].t = "X"
end

function Keyboard:draw()
    fill(dark1)
    rect(0, 0, WIDTH, HEIGHT-WIDTH-barW)
    
    for i,b in pairs(self.buttons) do
        b:draw()
    end
end

function Keyboard:touched(t)
    for i,b in pairs(self.buttons) do
        b:touched(t)
    end
end


Button = class()

function Button:init(x,y,t)
    self.x = x
    self.y = y
    self.t = t
    self.c = accent1
end

function Button:draw()
    fill(self.c)
    ellipse(self.x, self.y, 70)
    
    fontSize(35)
    fill(white1)
    text(self.t, self.x, self.y)
end

function Button:touched(t)
    if t.state == BEGAN then
        if vec2(t.x, t.y):dist(vec2(self.x, self.y)) <= 35 then
            self.c = accent2
            grid[selectCell.x][selectCell.y] = self.t
            if self.t == "X" then
                grid[selectCell.x][selectCell.y] = 0
            end
        end
    else
        self.c = accent1
    end
end
