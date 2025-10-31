-- Mise a mort timer

STOP = 0
EXERCISE = 1
REST = 2

function setup()
  timer = 0
  parameter.number("multiplier", 0.1, 2, 1)
  state = STOP
  viewer.preferredFPS = 60
  parameter.action("Fullscreen", function()
        viewer.mode = FULLSCREEN_NO_BUTTONS
    end)
end

function draw()
  if state == STOP then
    background(40)
    buttonText = "Start"
  elseif state == EXERCISE then
    background(0, 255, 0)
    buttonText = "Switch"
    timer = timer + DeltaTime
  elseif state == REST then
    background(255, 0, 0)
    timer = timer - DeltaTime
    buttonText = "Stop"
    if timer <= 0 then
      state = EXERCISE
    end
  end
  
  ms = pad(math.floor(timer*100)%100)
  sc = pad(math.floor(timer)%60)
  mn = pad(math.floor(timer/60)%60)
  
  if timer <= 3 
  and timer > 3 - 1/viewer.preferredFPS
  and state == REST then
    sound(asset.downloaded.Game_Sounds_One["1-2-3 Go.wav"])
  end
  
  fill(255)
  fontSize(90)
  font("HelveticaNeue")
  text(mn..":"..sc.."."..ms, WIDTH/2, HEIGHT/2)
  
  fontSize(50)
  fill(254, 160, 10)
  rectMode(CENTER)
  rRect(WIDTH/2, HEIGHT/4, 200, 75, 50)
  
  fill(255)
  text(buttonText, WIDTH/2, HEIGHT/4)
end

function pad(n)
  if n < 10 then
    return "0"..n
  else
    return n
  end
end

function touched(t)
  if  t.x <= WIDTH/2 + 100
  and t.x >= WIDTH/2 - 100
  and t.y <= HEIGHT/4 + 75/2 
  and t.y >= HEIGHT/4 - 75/2 
  and t.state == ENDED then
    if state == STOP then
      state = EXERCISE
    elseif state == EXERCISE then
      state = REST
      timer = timer * multiplier
    elseif state == REST then
      state = STOP
      timer = 0
    end
  end
end

function rRect(x,y,w,h,r)
  pushMatrix()
  translate(x, y)
  rect(0, 0, w, h-r)
  rect(0, 0, w-r, h)
  ellipse(w/2-r/2, h/2-r/2, r)
  ellipse(w/2-r/2, -h/2+r/2, r)
  ellipse(-w/2+r/2, h/2-r/2, r)
  ellipse(-w/2+r/2, -h/2+r/2, r)
  popMatrix()
end

