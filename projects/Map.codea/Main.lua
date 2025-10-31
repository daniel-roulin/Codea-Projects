-- Map
-- by dadarourou

function setup()
    map = Map()
    
    location.enable()
    parameter.watch("location.horizontalAccuracy")
    viewer.mode = FULLSCREEN
end

function draw()
    background(200)
    
    refCoords = vec2(-46.207391, 6.155887)
    realCoords = vec2(
    -location.latitude,
    location.longitude)
    
    refPos = map:coordsToPos(refCoords:unpack())
    realPos = map:coordsToPos(realCoords:unpack())
    
    refScrn = map.trl:wrldToScrn(refPos)
    realScrn = map.trl:wrldToScrn(realPos)
  
    map:draw()

    fill(0,255,0)
    ellipse(refScrn.x, refScrn.y, 10)
    
    fill(255, 0, 0)
    ellipse(realScrn.x, realScrn.y, 10)
end

function touched(t)
    map:touched(t)
end

