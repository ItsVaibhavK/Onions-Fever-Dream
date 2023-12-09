--[[
    TitleScreenState Class
    Borrowed from:
        Author: Colton Ogden
        cogden@cs50.harvard.edu

    The TitleScreenState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.
]]

TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()
    -- nothing
end

function TitleScreenState:update(dt)
    -- transition to countdown when enter/return are pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function TitleScreenState:render()
    -- simple UI code
    love.graphics.setFont(bunnyFont)
    love.graphics.printf('Onion\'s Fever Dream', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter to start', 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('CONTROLS', 0, 150, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf('w or up arrow - move up', 0, 170, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('a or left arrow - move left', 0, 180, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('s or down arrow - move down', 0, 190, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('d or right arrow - move right', 0, 200, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('p - pause/resume', 0, 210, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('escape - quit', 0, 220, VIRTUAL_WIDTH, 'center')
end