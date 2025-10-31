-- Speedometer

function setup()
    viewer.mode = FULLSCREEN
    location.enable()
    parameter.watch("location.speed")
    parameter.watch("location.latitude")
    
    dark1 = color(60)
    dark2 = color(40)
    
    white1 = color(200)
    white2 = color(150)
    
    red = color(209, 25, 14)
    
    if location.available() == false then
        viewer.alert("Please enable location for codea in settings", "Location Unavaible")
    end
    
    dialSpeed = 0
end

function draw()
    if location.available() == false then
        speed = 0
    else
        speed = math.floor(location.speed * 3.6)
    end
        
    background(dark2)
    
    translate(WIDTH/2, HEIGHT/2)
    
    noStroke()
    fill(dark1)
    ellipse(0, 0, WIDTH)
    
    fill(dark2)
    ellipse(0, 0, 330)
    
    for i = 0, 40 do
        gap = 270/40
        
        x = math.cos(math.rad((i * gap) - 45))
        x1 = x * 165
        x2 = x * 150
        x3 = x * 125
        
        y = math.sin(math.rad((i * gap) - 45))
        y1 = y * 165
        y2 = y * 150
        y3 = y * 125
        
        if i % 5 == 0 then
            strokeWidth(7)
            stroke(white1)
            
            fontSize(20)
            fill(white1)
            text(160 - (i*4), x3, y3)
        else
            strokeWidth(5)
            stroke(white2)
        end
        line(x1, y1, x2, y2)
    end
    
    if speed < 0 then
        dialSpeed = 0
    else
        dialSpeed = lerp(dialSpeed, speed, 0.1)
    end
    
    angle = (((-dialSpeed+80)/160)*270)+90
    radAngle = math.rad(angle)
    
    x = math.cos(radAngle) * 110
    y = math.sin(radAngle) * 110
    
    stroke(red)
    strokeWidth(10)
    line(0, 0, x, y)
    
    noStroke()
    fill(dark1)
    ellipse(0, 0, 60)
    
    
    fill(white1)
    fontSize(50)
    if speed < 0 then
        speed = "-"
    end
    text(speed, 0, -80)
    
    fill(white2)
    fontSize(20)
    text("km/h", 0, -120)
end

-- Linear Interpolation
function lerp(pos1, pos2, perc)
    return (1-perc)*pos1 + perc*pos2
end

