
function Editor:initKeyboardButtons()
    self.hideKeyboardButton = HideKeyboardButton(WIDTH/2, self.keyboardHeight + 25)
end


function Editor:drawKeyboardBar()
    fill(55, 55, 58, 255)
    noStroke()
    rectMode(CORNER)
    rect(0, self.keyboardHeight, WIDTH+1, 50)
    
    self.hideKeyboardButton:draw()
end

function Editor:keyboardBarTouched(t)
    if t.y >= HEIGHT/3-7 and t.y <= HEIGHT/3-7 + 50 then
        self.hideKeyboardButton:touched(t)
        return true
    end
end
