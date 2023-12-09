--[[
    PlayState Class
    Borrowed from:
        Author: Colton Ogden
        cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the cat and
    avoids ghosts. When the player collides with a ghost, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class{__includes = BaseState}
local ghostCounter = 0
-- variable to check if the game is in a paused state
local paused = false

function PlayState:init()
    self.cat = Cat()
    self.ghosts = {}
    self.timer = 0
    self.score = 0
    self.scoreTimer = 0
    self.scoreCount = 0
end

function PlayState:update(dt)
    if scrolling then
        -- update timer for ghost spawning and keeping track of time to calculate score
        -- since a point is awarded for every 3 seconds that the player survives
        self.timer = self.timer + dt
        self.scoreTimer = self.scoreTimer + dt
        

        -- spawn a new ghost every 5 seconds
        if self.timer > 5 and ghostCounter < 5 then
            ghostCounter = ghostCounter + 1        
            table.insert(self.ghosts, Ghost())
            self.timer = 0
        end

        -- score mechanism
        if self.scoreTimer > 4 then
            self.scoreCount = self.scoreCount + dt/3
            self.score = math.floor(self.scoreCount)
        end

        -- update for every ghost sprite
        for k, ghost in pairs(self.ghosts) do
            ghost:update(dt)
        end

        self.cat:update(dt)

        -- simple collision between cat and all ghosts
        for k, ghost in pairs(self.ghosts) do
            if self.cat:collides(ghost) then
                ghostCounter = 0
                sounds['hurt']:play()
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end

    -- pause mechanism
    if love.keyboard.wasPressed('p') and paused == false then
        scrolling = false
        paused = true
        love.audio.pause(sounds['music'])
        love.audio.play(sounds['pause'])
    elseif love.keyboard.wasPressed('p') and paused == true then
        scrolling = true
        paused = false
        love.audio.play(sounds['music'])
    end
end

function PlayState:render()
    love.graphics.setFont(bunnyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    -- if the game is paused, render a pause message
    if paused == true then
        love.graphics.setFont(bunnyFont)
        love.graphics.printf('Paused', 0, 130, VIRTUAL_WIDTH, 'center')
    end

    -- render ghosts and cat after the text so the sprites always appear 'on top' of text
    for k, pair in pairs(self.ghosts) do
        pair:render()
    end
    self.cat:render()
end

--[[
    Called when this state is transitioned to from another state.
]]
function PlayState:enter()
    -- if we're coming from death, restart scrolling
    scrolling = true
end

--[[
    Called when this state changes to another state.
]]
function PlayState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
end