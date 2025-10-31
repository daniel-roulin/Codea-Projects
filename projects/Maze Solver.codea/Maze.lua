function createMaze(width, height)
    grid = {}
    for x = 0, width-1 do
        grid[x] = {}
        for y = 0, height-1 do
            grid[x][y] = 0
        end
    end
    
    n = 0
    for x, rows in pairs(grid) do
        for y, value in pairs(rows) do
            if x % 2 == 1 and y % 2 == 1 then
                n = n + 1
                grid[x][y] = n
            end
        end
    end
    
    walls = {}
    for x, rows in pairs(grid) do
        for y, value in pairs(rows) do
            if (x+y)%2 == 1 and x > 0 and y > 0 and x < width-1 and y < height-1 then
                table.insert(walls, {x, y})
            end
        end
    end
    
    colors = {}
    for i = 1, n do
        colors[i] = color(math.random(100, 255), math.random(100, 255), math.random(100, 255))
    end
    
    for i = 1, n-1 do
        output.clear()
        print(((i/n) * 100).." %")
        step()
    end
    
    for x, rows in pairs(grid) do
        for y, value in pairs(rows) do
            if value ~= 0 then
                grid[x][y] = -1
            end
        end
    end
    
    -- Remove 10 random walls
    walls = {}
    for x, rows in pairs(grid) do
        for y, value in pairs(rows) do
            if (x+y)%2 == 1 and x > 0 and y > 0 and x < width-1 and y < height-1 and value == 0 then
                table.insert(walls, {x, y})
            end
        end
    end 
    for i = 1, 20 do
        index = math.random(1, #walls)
        wall = table.remove(walls, index)
        x, y = table.unpack(wall)
        grid[x][y] = -1
    end
    
    return grid
end

function step()
    x, y, c1, c2 = getRandomWall()
    grid[x][y] = c1
    for col, rows in pairs(grid) do
        for row, value in pairs(rows) do
            if value == c2 then
                grid[col][row] = c1
            end
        end
    end
end

function getNeighbors(x, y)
    if x % 2 == 1 then
        c1 = grid[x][y + 1]
        c2 = grid[x][y - 1]
    else
        c1 = grid[x + 1][y]
        c2 = grid[x - 1][y]
    end
    return c1, c2
end

function getRandomWall()
    while true do
        index = math.random(1, #walls)
        wall = table.remove(walls, index)
        x, y = table.unpack(wall)
        c1, c2 = getNeighbors(x, y)
        if c1 ~= c2 then
            return x, y, c1, c2
        end
    end
end