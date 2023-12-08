--[[
    Onion's Fever Dream

    Author: Vaibhav Kumar
    not.vaibhav92@gmail.com

    Based on code from lecture 1 of CS50G written by:
        Author: Colton Ogden
        cogden@cs50.harvard.edu

    An endless scrolling game where the player controls the cat, "Onion", using either the arrow keys to move in the corresponding direction, or the W-A-S-D keys for up-left-down-right movement. The objective of the game is to survive against five "ghosts" for as long as possible. The scoring mechanism awards the player 1 point for every 3 seconds that they survive.
]]

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

-- cat class
require 'Cat'

-- ghost class
require 'Ghost'

-- a basic StateMachine class which will allow us to transition to and from
-- game states smoothly and avoid monolithic code in one file
require 'StateMachine'
-- all states our StateMachine can transition between
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288


-- background image and starting scroll location (X axis)
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

-- speed at which to scroll background, scaled by dt
local BACKGROUND_SCROLL_SPEED = 100

-- point at which to loop background back to X = 0
local BACKGROUND_LOOPING_POINT = VIRTUAL_WIDTH

-- scrolling variable to pause the game when we collide with a ghost
scrolling = true

function love.load()
    -- initialize nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- app window title
    love.window.setTitle('Onion\'s Fever Dream')

    -- initialize our nice-looking retro text fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('bunny.ttf', 14)
    bunnyFont = love.graphics.newFont('bunny.ttf', 28)
    hugeFont = love.graphics.newFont('bunny.ttf', 56)
    love.graphics.setFont(bunnyFont)

    -- seed RNG
    math.randomseed(os.time())

    -- initialize table of sounds
    --[[
    Note: The soundtrack is a snippet+loop of an instrumental version of
     "Get Got" by Death Grips. I don't have any license to use this music,
     but I am NOT using this in any commercial sense whatsoever. I only wrote
     this game as an experiment for myself to better understand Game Development
     while going through CS50's Game Development course on edX.
     If you intend to use this code, PLEASE change the soundtrack to something you have
     a license to use, or some other royalty-free music. I just really loved how this song
     worked with the game, and of course, I love Death Grips.
    ]]
    sounds = {
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['music'] = love.audio.newSource('music.mp3', 'static')
    }

    -- kick off music
    sounds['music']:setLooping(true)
    sounds['music']:play()

    -- initialize virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')

    -- initialize input table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- add to table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
    
    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    Custom function to extend LÖVE's input handling; returns whether a given
    key was set to true in our input table this frame.
]]
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end


function love.update(dt)
    if scrolling then
        -- scroll background by preset speed * dt, looping back to 0 after the looping point
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    end
    
    -- update the state machine, which defers to the right state
    gStateMachine:update(dt)

    -- reset input table
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    love.graphics.draw(background, -backgroundScroll, 0, 0, 1/4.5, 1/4.5)
    gStateMachine:render() 
    push:finish()
end