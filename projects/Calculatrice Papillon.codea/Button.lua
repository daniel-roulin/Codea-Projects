--# Button
button=class()

function button:init(h,w,x,y,v,f)
    self.h=h -- height
    self.w=w -- width
    self.x=x -- x position
    self.y=y -- y position
    self.v=v -- value
    self.col=color(115,150,170)
end

function button:draw()
    rectMode(CENTER)
    fontSize(50)
    fill(self.col)
    rect(self.x,self.y,self.w, self.h)
    fill(239, 239, 242, 255)
    text(self.v,self.x,self.y-10)
end

function button:touched(t)
    if t.state==BEGAN then
        if t.x>self.x-self.w/2 and t.x< self.x+self.w/2 and t.y > self.y-self.h/2 and t.y < self.y + self.h/2 then
            
            self.col = color(81, 107, 122, 255)
            fontSize(50)
            w,h = textSize(expression)
            if self.v == "( | )" then
                if w+20 < WIDTH then
                    if t.x < self.x then
                        expression=expression.."("
                    else
                        expression=expression..")"
                    end
                end
            elseif self.v == "=" then
                if expression ~= "" then
                    load("result="..expression)()
                    if math.tointeger(result) then
                        result=math.tointeger(result)
                    end
                end
            elseif self.v == "C" then
                expression = string.sub(expression, 1, -2)
                result=0
            elseif self.v == "AC" then
                result=0
                expression=""
            else
                if w+20 < WIDTH then
                    expression=expression..self.v
                end
            end
        end
    else
        self.col = color(115,150,170)
    end
end