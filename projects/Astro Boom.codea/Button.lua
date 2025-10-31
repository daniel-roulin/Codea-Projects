Button = class()

function Button:init(x,y,w,h,t,s,f)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.t = t
    self.s = s
    self.f = f
    self.touch = false
end

function Button:draw()
    if self.s == "orange" then
        if self.touch then
            sprite(asset.builtin.UI.Red_Button_12,self.x,self.y,self.w,self.h)
        else
            sprite(asset.builtin.UI.Red_Button_11,self.x,self.y,self.w,self.h)
        end
    end
    
    if self.s == "blue" then
        if self.touch then
            sprite(asset.builtin.UI.Blue_Button_01,self.x,self.y,self.w,self.h)
        else
            sprite(asset.builtin.UI.Blue_Button_00,self.x,self.y,self.w,self.h)
        end
    end
    
    if self.s == "pause" then
        if self.touch then
            tint(127, 127, 127, 255)
        end
        sprite(asset.documents.Orange_Pause_Button,self.x,self.y,self.w,self.h)
        noTint()
    end
    
    if self.s == "menu" then
        if self.touch then
            tint(127, 127, 127, 255)
        end
        sprite(asset.documents.Orange_Home_Button,self.x,self.y,self.w,self.h)
        noTint()
    end
    
    textMode(CENTER)
    font("Arial-BoldMT")
    fontSize(30)
    fill(225, 225, 225, 255)
    text(self.t, self.x, self.y)
end

function Button:touched(t)
    if t.x > self.x-self.w and t.x < self.x + self.w and t.y > self.y - self.h and t.y < self.y + self.h then
        if t.state == BEGAN then
            self.touch = true
        elseif (t.state == ENDED or t.state == CANCELLED) and self.touch == true then
            self.f()
            self.touch = false
        end
        return true
    end
    if t.state == ENDED or t.state == CANCELLED then
        self.touch = false 
        return false
    end
end