-- Maze

function setup()
    viewer.mode = FULLSCREEN
    
    width = 51
    height = 51
    
    createAndSolve()
end

function createAndSolve()
    grid = createMaze(width, height)
    solve()
    
    tween.delay(0.3, createAndSolve)
end

function solve()
    setDistance(1, 1, 1)
    pathfind(width-2, height-2)
end

function pathfind(x, y)
    grid[x][y] = -1
    
    if x == 1 and y == 1 then
        return
    end
    
    min = math.maxinteger
    minX, minY = 0, 0
    for i = -1, 1, 2 do
        if grid[x + i][y] > 0 and grid[x + i][y] < min then
            min = grid[x + i][y]
            minX, minY = x + i, y
        end
    end
    for i = -1, 1, 2 do
        if grid[x][y + i] > 0 and grid[x][y + i] < min then
            min = grid[x][y + i]
            minX, minY = x, y + i
        end
    end
    pathfind(minX, minY)
end

function setDistance(x, y, n)
    grid[x][y] = n
    if grid[x + 1][y] == -1 then
        setDistance(x + 1, y, n + 1)
    end
    if grid[x - 1][y] == -1 then
        setDistance(x - 1, y, n + 1)
    end
    if grid[x][y + 1] == -1 then
        setDistance(x, y + 1, n + 1)
    end
    if grid[x][y - 1] == -1 then
        setDistance(x, y - 1, n + 1)
    end
end

function drawGrid()
    textMode(CENTER)
    textAlign(CENTER)
    fontSize(10)
    size = math.min(WIDTH/width, HEIGHT/height)
    startx = (WIDTH-size*width)/2
    starty = (HEIGHT-size*height)/2
    for x, rows in pairs(grid) do
        for y, value in pairs(rows) do
            if value == 0 then
                fill(0)
            elseif value == -1 then
                fill(147, 223, 146)
            else
                fill(255)
            end 
            rect(startx + x*size, starty + y*size, size+2, size+2)
            
            fill(0)
            -- text(value, startx + x*size + size/2, starty + y*size + size/2)
        end
    end
end

function draw()
    background(40)
    drawGrid()
end

