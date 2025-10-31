Soduko = class()

function Soduko:init()
    grid = {}
    for x = 0,8 do
        grid[x] = {}
        for y = 0,8 do
            grid[x][y] = 0
        end
    end
    
    -- grid[1][1] = 7
    -- grid[1][9] = 9
    
    --[[
    grid = {
    {0,0,6, 5,0,8, 4,0,0},
    {5,2,0, 0,0,0, 0,0,0},
    {0,8,7, 0,0,0, 0,3,1},
    
    {0,0,3, 0,1,0, 0,8,0},
    {9,0,0, 8,6,3, 0,0,5},
    {0,5,0, 0,9,0, 6,0,0},
    
    {1,3,0, 0,0,0, 2,5,0},
    {0,0,0, 0,0,0, 0,7,4},
    {0,0,5, 2,0,6, 3,0,0}}
    ]]
    
    selectCell = vec2(0,0)
    
    solveGrid()
end

function Soduko:draw()
    -- Background
    fill(dark2)
    rect(0, HEIGHT-WIDTH-barW, WIDTH, WIDTH)
    
    -- Small lines
    stroke(white2)
    strokeWidth(2)
    for x = 0,9 do
        line(x*WIDTH/9, HEIGHT-barW, x*WIDTH/9, HEIGHT-WIDTH-barW)
    end
    for y = 0,9 do
        line(0, HEIGHT-WIDTH-barW + (y*WIDTH/9), WIDTH, HEIGHT-WIDTH-barW + (y*WIDTH/9))
    end
    
    -- Big lines
    stroke(white1)
    strokeWidth(4)
    for x = 0,3 do
        line(x*WIDTH/3, HEIGHT-barW, x*WIDTH/3, HEIGHT-WIDTH-barW)
    end
    for y = 0,3 do
        line(0, HEIGHT-WIDTH-barW + (y*WIDTH/3), WIDTH, HEIGHT-WIDTH-barW + (y*WIDTH/3))
    end
    
    -- Selected Cell
    strokeWidth(3)
    stroke(accent2)
    fill(accent1)
    -- fill(red)
    
    rect(selectCell.x*WIDTH/9, HEIGHT-WIDTH-barW + (selectCell.y*WIDTH/9), WIDTH/9, WIDTH/9)
    
    
    -- Numbers
    fontSize(30)
    fill(white1)
    for x = 0,8 do
        for y = 0,8 do
            if grid[x][y] ~= 0 then
                text(grid[x][y], (x*WIDTH/9) + (WIDTH/9/2), (HEIGHT-barW-WIDTH) + (y*WIDTH/9) + (WIDTH/9/2))
                -- text(grid[x][y],(y*WIDTH/9)+(WIDTH/9/2), ((HEIGHT-barW) - (x*WIDTH/9))-(WIDTH/9/2))
            end
        end
    end
    
    noStroke()
end

function Soduko:touched(t)
    selectCell.x = math.floor(t.x/WIDTH*9)
    selectCell.y = math.floor((t.y-(HEIGHT-WIDTH-barW))/WIDTH*9)
    checkNum(3,selectCell.x,selectCell.y)
end

-- Solve the grid
function solveGrid()
    for x = 0,8 do
        for y = 0,8 do
            if grid[x][y] == 0 then
                for n = 1,9 do
                    if checkNum(n,x,y) then
                        grid[x][y] = n
                        break
                    end
                    grid[x][y] = 0
                end
            end
        end
    end
end

-- Test if the the grid is full
function checkGrid()
    for x = 0,8 do
        for y = 0,8 do
            if grid[x][y] ~= 0 then
                return false
            end
        end
    end
    return true
end

-- Check if a number can fit in a particular cell in the grid
function checkNum(n,x,y)
    -- check colum
    for col = 0,8 do
        if grid[x][col] == n then
            print("col")
            return false
        end
    end
    
    -- check row
    for row = 0,8 do
        if grid[row][y] == n then
            print("row")
            return false
        end
    end
    
    -- check square
    sqrX = math.floor(x/3)
    sqrY = math.floor(y/3)
    
    for row = sqrX*3, ((sqrX+1)*3)-1 do
        for col = sqrY*3, ((sqrY+1)*3) -1 do
            if grid[row][col] == n then
                print("sqr")
                return false
            end
        end
    end
    
    print("ok")
    return true
end

function shiftRotateGrid()
    -- Rotate
    newGrid = {{},{},{},{},{},{},{},{},{},{},{}}
    for x = 1,9 do
        for y = 1,9 do
            newGrid[x][10-y] = grid[y][x]
        end
    end
    grid = newGrid
    
    -- Shift
    grid[0] = {}
    for x = 1,9 do
        for y = 1,9 do
            grid[x-1][y-1] = grid[x][y]
        end
    end
end

