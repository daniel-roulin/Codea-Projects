-- Calculatrice Papillon

--# Main
function setup()
    viewer.mode = FULLSCREEN
    butterflies = Butterflies(50)
    values = {}
    values[1] = "( | )"
    values[2] = 0
    values[3] = "."
    values[4] = "="
    values[5] = 1
    values[6] = 2
    values[7] = 3
    values[8] = "/"
    values[9] = 4
    values[10] = 5
    values[11] = 6
    values[12] = "*"
    values[13] = 7
    values[14] = 8
    values[15] = 9
    values[16] = "-"
    values[17] = "AC"
    values[18] = "C"
    values[19] = "^"
    values[20] = "+"
    buttons={}
    i = 0
    for y = 1,5 do
        for x = 1,4 do
            i = i + 1
            buttons[i] = button(HEIGHT/10,WIDTH/4,((WIDTH/4)*x)-WIDTH/8,(HEIGHT/10*y)-HEIGHT/
            20, values[i])
        end
    end
    expression = ""
    result = 0
    font("AcademyEngravedLetPlain")
    stroke(255, 255, 255, 255)
    strokeWidth(3)
end

function draw()
    background(68, 68, 68, 255)
    butterflies:draw()
    for i,b in pairs(buttons) do
        b:draw()
    end
    rectMode(CORNER)
    fill(115,150,170)
    rect(0,HEIGHT/2, WIDTH, HEIGHT/12)
    rect(0,HEIGHT/2+HEIGHT/12, WIDTH, HEIGHT/8)
    fill(239, 239, 242, 255)
    w,h = textSize(expression)
    text(expression, WIDTH-w/2-5, HEIGHT/2+11)
    fontSize(70)
    w,h = textSize(tonumber(result))
    text(tonumber(result), WIDTH-w/2-5, HEIGHT/2+HEIGHT/12+20)
end

function touched(t)
    butterflies:touched(t)
    for i,b in pairs(buttons) do
        b:touched(t)
    end
end