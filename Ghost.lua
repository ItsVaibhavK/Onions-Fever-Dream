--[[
    Ghost Class
    
    Author: Vaibhav Kumar
    not.vaibhav92@gmail.com

    Based on code from lecture 1 of CS50G written by:
        Author: Colton Ogden
        cogden@cs50.harvard.edu

    The ghost entity is what the player must avoid making contact with in the game.
    The longer the player survives, the higher their score.
]]

Ghost = Class{}

-- since we only want the image loaded once, not per instantation, define it externally
local GHOST_IMAGE = love.graphics.newImage('ghost.png')
GHOST_SPEED = 100

function Ghost:init()
    self.width = GHOST_IMAGE:getWidth()
    self.height = GHOST_IMAGE:getHeight()

    -- position ghost
    self.x = math.random(-VIRTUAL_WIDTH, 0)
    self.y = math.random(0, VIRTUAL_HEIGHT)

    -- give ghost velocity along both axes
    self.dy = math.random(GHOST_SPEED, GHOST_SPEED*2)
    self.dx = math.random(GHOST_SPEED, GHOST_SPEED*2)

end


function Ghost:update(dt)
    -- keep the ghost bouncing off all the edges of the screen
    if self.y <= 0 then
        self.y = 0
        self.dy = -self.dy
    end
    if self.y >= VIRTUAL_HEIGHT - 15 then
        self.y = VIRTUAL_HEIGHT - 15
        self.dy = -self.dy
    end
    if self.x <= 0 then
        self.x = 0
        self.dx = -self.dx
    end
    if self.x >= VIRTUAL_WIDTH - 18 then
        self.x = VIRTUAL_WIDTH - 18
        self.dx = -self.dx
    end
    -- update ghost position each frame, multipled by dt to keep it independent of FPS
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ghost:render()
    love.graphics.draw(GHOST_IMAGE, self.x, self.y, 0, 0.12, 0.12)
end