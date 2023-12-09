# DEMO LINKS
#### [1. Onion's Fever Dream - The original version on Scratch](https://scratch.mit.edu/projects/778439439/)
#### [2. The current version of Onion's Fever Dream created using Lua and LÖVE2D](https://youtu.be/98ArOOz-dU8)
#### [3. Demo showcasing the original Scratch version and the current version of Onion's Fever Dream](https://youtu.be/H7JrDLxPTVw)

*Note: The current version of the game is 2.*

## IMPORTANT NOTE REGARDING SOUNDTRACK
I used [Death Grips'](https://thirdworlds.net/) song, [Get Got](https://www.youtube.com/watch?v=HIrKSqb4H4A), or rather, an instrumental version of the same that I found on [YouTube](https://www.youtube.com/watch?v=53TiNT9sSdI). I cut the part I wanted to keep looped.<br>I do not have any rights to this music, I just really loved how it sounded with the game, and of course, I love Death Grips. I do not intend to have<br>any commercial usage out of this game, it was only meant to be a game that I developed at home as an experiment and a way for me to better understand<br>the concepts that I am learning currently in [CS50's Introduction to Game Development](https://pll.harvard.edu/course/cs50s-introduction-game-development).

**IF YOU INTEND TO USE THIS CODE AND RELEASE IT, PLEASE CHANGE THE SOUNDTRACK.**

## IMPORTANT NOTE REGARDING THE SPRITES
I did not design the various game assets myself, I looked for license-free/royalty-free sprites/backgrounds that I could use.
1. [Cat sprite](https://judgemon21.itch.io/super-flying-cat-popo-48x48)
2. [Background](https://free-game-assets.itch.io/free-city-backgrounds-pixel-art)
3. [Ghost sprite](https://dyru.itch.io/pixel-ghost-template)

# IDEA/CONCEPT
While going through Week 1 of [CS50's Introduction to Game Development](https://pll.harvard.edu/course/cs50s-introduction-game-development), in which we dissected the popular mobile game, [Flappy Bird](https://en.wikipedia.org/wiki/Flappy_Bird),<br>I decided to not go with the idea of making variants of the game as I had done in Week 0, where we dissected the 1972 arcade hit, [Pong](https://en.wikipedia.org/wiki/Pong),<br>and I made 3 variants of the same - [Dong, Wrong and Dead Wrong](https://github.com/ItsVaibhavK/Pong-Variants). Instead, to better understand the game development concepts I had learnt so far,<br>I decided to make *my own game.*

When I first started learning how to write programs, my very first assignment while undertaking [CS50X - CS50’s Introduction to Computer Science](https://cs50.harvard.edu/x/2023/)<br>was to create a program using the [Scratch](https://scratch.mit.edu/about/) platform. I had ended up making my own mini-game of sorts, titled *Onion's Fever Dream,* which I have linked at the top of this **README**.

Now, at Week 1 of [CS50's Introduction to Game Development](https://pll.harvard.edu/course/cs50s-introduction-game-development), I decided to make a proper 2D endless scrolling version, *a real game,* of the same name and concept.<br>This is how *Onion's Fever Dream* was born.

# GAMEPLAY

### CONTROLS
The player controls Onion (the cat) using:
1. Arrow keys to move in the corresponding direction.
2. W-A-S-D keys mapped to move the player Up-Left-Down-Right.

The player can also move diagonally by pressing two keys at a time.<br>Additionally, the player can:
1. Pause/resume the game at any point by pressing 'P.'
2. Exit the game at any point by pressing 'ESC'.

### OBJECTIVE
The player has to survive for as long as possible by avoiding making contact with the "ghosts" that are chasing them through their fever dream.

### SCORING MECHANISM
The player earns 1 point for every 3 seconds that they survive. Points are only calculated once the "ghosts" start appearing on-screen.

# THE CODE
I've used a few libraries to help build this game:
1. `push.lua` - library that allows us to draw the game at a virtual resolution, instead of however large our window is; used to provide a more retro aesthetic
2. `class.lua` - library that allows us to represent anything in our game as code, rather than keeping track of many disparate variables and methods

Then comes the `StateMachine` class, and the various states in the game:
1. `StateMachine.lua` - a basic StateMachine class which allows us to transition to and from game states smoothly and avoid monolithic code in one file
2. `BaseState.lua` - used as the base class for all states
3. `CountdownState.lua` - counts down visually on the screen (3,2,1) so that the player knows the
    game is about to begin.<br>Transitions to the PlayState as soon as the countdown is complete
4. `PlayState.lua` - the bulk of the game, where the player actually controls the cat and avoids ghosts.<br>When the player collides with a ghost, we go to the GameOver state, where we then go back to the main menu
5. `ScoreState.lua` - used to display the player's score before they transition back into the PlayState. Transitioned to from the PlayState when they collide with a ghost
6. `TitleScreenState.lua` - the starting screen of the game, shown on startup

### CONTROLLING ONION (THE CAT)/PLAYER
I split movement key checks into separate conditionals. This allows for diagonal movement if the player presses 2 keys. <br>For example: 'up' and 'right' will move the player in the corresponding diagonal trajectory.
This can be seen in `Cat.lua`:
```
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
```

### COLLISION DETECTION
Collisions are detected using AABB collision, and the bounding boxes are also shrunk to give the player a little more leeway in the game.<br>The code for this can also be seen in `Cat.lua`:
```
if self.x > ghost.x + ghost.width*0.01 or ghost.x > self.x + self.width*0.1 then
    return false
end
if self.y > ghost.y + ghost.height*0.01 or ghost.y > self.y + self.height*0.1 then
    return false
end 
-- if the above aren't true, they're overlapping
return true
```

### GHOST MECHANISM
*IMPORTANT*<br>Since we only want the image loaded once, not per instantation, we define it externally in `Ghost.lua` as `local GHOST_IMAGE = love.graphics.newImage('ghost.png')`.

Ghosts always appear from the left-hand side of the screen, as it better suits the illusion that they are chasing the player.<br>Ghosts are also given a random velocity for each ghost when they spawn. This behavior is defined as follows in `Ghost.lua`:
```
-- position ghost
self.x = math.random(-VIRTUAL_WIDTH, 0)
self.y = math.random(0, VIRTUAL_HEIGHT)

-- give ghost velocity along both axes
self.dy = math.random(GHOST_SPEED, GHOST_SPEED*2)
self.dx = math.random(GHOST_SPEED, GHOST_SPEED*2)
```
Also seen in `Ghost.lua` is the logic that keeps the ghosts bouncing off each edge, so that they don't go offscreen:
```
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
```
Ghosts are spawned every 5 seconds, and are currently limited to five ghosts as seen in `PlayState.lua`:
```
local ghostCounter = 0
self.timer = 0

self.timer = self.timer + dt

if self.timer > 5 and ghostCounter < 5 then
    ghostCounter = ghostCounter + 1        
    table.insert(self.ghosts, Ghost())
    self.timer = 0
end
```

### SCORING MECHANISM
A point is awarded for every 3 seconds the player survives AFTER the first ghost has spawned. This is defined in `PlayState.lua`:
```
self.score = 0
self.scoreTimer = 0
self.scoreCount = 0

if self.scoreTimer > 4 then
    self.scoreCount = self.scoreCount + dt/3
    self.score = math.floor(self.scoreCount)
end
```

### ENDLESS SCROLLING BACKGROUND
The endless scrolling illusion is achieved by having the background image copied and attached as one long image, and then executing the following logic on it in `main.lua`: 
```
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0
local BACKGROUND_SCROLL_SPEED = 100
local BACKGROUND_LOOPING_POINT = VIRTUAL_WIDTH
scrolling = true

function love.update(dt)
    if scrolling then
        -- scroll background by preset speed * dt, looping back to 0 after the looping point
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    end
end
```
The endless scrolling stops/starts as determined by the logic in `PlayState.lua`:
```
-- Called when this state is transitioned to from another state.
function PlayState:enter()
    -- if we're coming from death, restart scrolling
    scrolling = true
end

-- Called when this state changes to another state.
function PlayState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
end
```

# UPDATES - VERSION 2
### PAUSE
I've added pause functionality for the game such that the player can pause the game at any point in the play state by pressing '**p**' on their keyboard.<br>I've used a few variables to achieve this:
1. In `main.lua` is the global variable `scrolling = true` which helps determine if the background should be scrolling or not depending on the game state that the player is in.
2. In `PlayState.lua`, I've declared a local variable `local paused = false` to keep a track of if the game is in a paused state or not.

In `PlayState.lua`, I've moved all the update execution inside the following conditional: `if scrolling then`. This means that all motion,<br>whether it is of the background, or sprites, will only happen if scrolling is set to true.

I've then implemented the pause feature as seen here:
```
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
```
If the game is paused, the soundtrack is also paused and a short sound effect to indicate the game being paused is also heard.

Further, if the game is paused, there is a new UI message displayed onscreen:
```
if paused == true then
    love.graphics.setFont(bunnyFont)
    love.graphics.printf('Paused', 0, 130, VIRTUAL_WIDTH, 'center')
end
```
### CONTROLS DISPLAYED ON TITLESCREEN
This is a cosmetic update, I've added a helpful list of controls for the player to see at the title screen itself. This can be seen in `TitleScreen.lua`:
```
love.graphics.setFont(mediumFont)
love.graphics.printf('CONTROLS', 0, 150, VIRTUAL_WIDTH, 'center')
love.graphics.setFont(smallFont)
love.graphics.printf('w or up arrow - move up', 0, 170, VIRTUAL_WIDTH, 'center')
love.graphics.printf('a or left arrow - move left', 0, 180, VIRTUAL_WIDTH, 'center')
love.graphics.printf('s or down arrow - move down', 0, 190, VIRTUAL_WIDTH, 'center')
love.graphics.printf('d or right arrow - move right', 0, 200, VIRTUAL_WIDTH, 'center')
love.graphics.printf('p - pause/resume', 0, 210, VIRTUAL_WIDTH, 'center')
love.graphics.printf('escape - quit', 0, 220, VIRTUAL_WIDTH, 'center')
```
### MINOR UPDATES
I've also updated the messages that are displayed onscreen (when a player collides with a ghost) in `ScoreState.lua`.

# FUTURE IDEAS
1. Give the option to the player to choose levels, change the number of ghosts that can be spawned according to difficulty,<br>and perhaps change the background and soundtrack, too.
2. Keep a track of high scores to show who has the highest score so far, like a leaderboard.
3. Provide power-ups for the player like an extra life, or the ability to kill ghosts.
4. Add other obstacles to challenge the player with their own separate mechanics and logic.
5. Provide the player with the option to change the sprite/cat that they control.

# CREDITS
As always, I cannot begin to express my gratitude for the people behind all the [CS50](https://pll.harvard.edu/course/cs50-introduction-computer-science) courses.<br>In less than a year, I have gone from knowing nothing about programming to being able to write my own programs, web apps, create my own databases, and now - GAMES!

Thank you, [Colton Ogden](https://www.linkedin.com/in/colton-ogden-0514029b), for taking us through this course, and all the staff members at [CS50](https://pll.harvard.edu/course/cs50-introduction-computer-science), for instilling the love of programming in us!