ProjectBrowser = class()

function ProjectBrowser:init()
    self:getFolders()
end

function ProjectBrowser:draw()
    background(40)
    --[[
    spriteMode(CORNER)
    sprite(asset.documents.Background,0,0,WIDTH,HEIGHT)
    ]]
    self.container:draw()
end

function ProjectBrowser:getDummyProjects()
    local shelves = {}
    for i = 0, 0 do
        local objects = {}
        for j = 1, 50 do
            table.insert(objects, Project(asset,j))
        end
        table.insert(shelves, ProjectFolder(objects, "Documents "..i+1))
    end
    
    self.container = VerticalScrollContainer(shelves, 0, 0, WIDTH, HEIGHT, true)
end

function ProjectBrowser:getFolders()
    local shelves = {}
    local folderProjects = {}
    local projects = listProjects()
    local lastFolderName = split(projects[1], ":", 1)[1]
    for i, project in pairs(projects) do
        parts = split(project, ":", 1)
        folderName = parts[1]
        projectName = parts[2]
        if folderName ~= lastFolderName then
            table.insert(shelves, ProjectFolder(lastFolderName, folderProjects))
            folderProjects = {}
        end
        lastFolderName = folderName
        table.insert(folderProjects, Project(folderName, projectName))
    end
    table.insert(shelves, ProjectFolder(lastFolderName, folderProjects))
    self.container = VerticalScrollContainer(shelves, 0, 0, WIDTH, HEIGHT, true)
end

