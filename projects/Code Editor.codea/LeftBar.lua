

function Editor:drawLeftBar()
    font(self.font)
    textMode(CORNER)
    noStroke()
    rectMode(CORNER)
    fill(35, 41, 53)
    rect(0, 0, self.barW-3, HEIGHT)
end
