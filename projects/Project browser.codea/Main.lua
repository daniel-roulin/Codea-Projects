-- Project Folders

-- Todo:
-- ICONS: broken and no transparency
-- dynamic scrolling?
-- icons should have a shadow for better text readability
function setup()
    browser = ProjectBrowser()
end

function draw()
    background(255, 0, 0)
    browser:draw()
end