--[[
    Cat Class

    Author: Vaibhav Kumar
    not.vaibhav92@gmail.com

    Based on code from lecture 1 of CS50G written by:
        Author: Colton Ogden
        cogden@cs50.harvard.edu

    The cat (Onion) is controlled by the player using either the arrow keys corresponding to each direction,
    or W-A-S-D keys mapped to up-left-down-right.
]]

Cat = Class{}
local CAT_SPEED = 150

function Cat:init()
    -- load cat image from disk and assign its width and height
    self.image = love.graphics.newImage('cat.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- position cat in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2.4
    self.y = VIRTUAL_HEIGHT / 2.4
    -- no initial velocity as cat is controlled by player
    self.dx = 0
    self.dy = 0
end


function Cat:update(dt)
    -- Check for movement controls in separate 'if' statements, so that if the player presses 2 keys at once, the cat will move in 2 directions (this will allow for diagonal movement)
    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
        self.dy = -CAT_SPEED
        self.y = math.max(-10, self.y + self.dy * dt)
    end
    if love.keyboard.isDown('s') or love.keyboard.isDown('down') then
        self.dy = CAT_SPEED
        self.y = math.min(VIRTUAL_HEIGHT - 36, self.y + self.dy * dt)
    end
    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        self.dx = -CAT_SPEED
        self.x = math.max(-14, self.x + self.dx * dt)
    end
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        self.dx = CAT_SPEED
        self.x = math.min(VIRTUAL_WIDTH - 38, self.x + self.dx * dt)
    end
end


function Cat:collides(ghost)
    -- AABB collision, multiplied to adjust box boundaries/scale
    -- offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    if self.x > ghost.x + ghost.width*0.01 or ghost.x > self.x + self.width*0.1 then
        return false
    end
    if self.y > ghost.y + ghost.height*0.01 or ghost.y > self.y + self.height*0.1 then
        return false
    end 
    -- if the above aren't true, they're overlapping
    return true
end

function Cat:render()
    love.graphics.draw(self.image, self.x, self.y, 0, 0.17, 0.17)
end