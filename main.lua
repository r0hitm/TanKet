--[[
    TanKet
    - A very minimal Tower Defense Survival Game.
    - Player has to survive as long as possible from a hoard of attackers.

    Author: Rohit Mehta

    This is my Final Project for the CS50x 2021 Course by Harvard.
]]

--[[
    In the battlefield, you are supposed to wreak havoc on the enemy using your tank.
    But tank's treads have been damaged severly, and you cannot move, but the war is going on!
    Hopefully, your turrets are working fine and you have good amount of ammunition still available.

    Shoot out the enemies and survive as long as possible on the battlefield!
]]

--[[
    load the game resources.
    Called only once when the game starts.
]]
function love.load()
    --[[
       Classic
       A tiny class module for Lua. Attempts to stay simple and provide decent
       performance by avoiding unnecessary over-abstraction.

       https://github.com/rxi/classic
    ]]
    Object = require 'classic'

    require 'Body'
    require 'Tank'
    require 'EnemyList'
    require 'Missile'

    math.randomseed(os.time())

    ----------------------------------------------------------------------------
    -- Constants:
    WINDOW_WIDTH = 1280
    WINDOW_HEIGHT = 720

    EXTRA_BIG_FONT = love.graphics.newFont('assets/fonts/market_deco.ttf', 48)
    TITLE_FONT = love.graphics.newFont('assets/fonts/market_deco.ttf', 32)
    SUBTITLE_FONT = love.graphics.newFont('assets/fonts/market_deco.ttf', 24)
    MED_FONT   = love.graphics.newFont('assets/fonts/market_deco.ttf', 16)
    SMALL_FONT = love.graphics.newFont('assets/fonts/market_deco.ttf', 12)

    EXPLOSION_PNG = love.graphics.newImage('assets/explosion.png')
    SOIL_PNG = love.graphics.newImage('assets/textures/soil.jpg')
    GRASS_PNG = love.graphics.newImage('assets/textures/grass.jpg')

    SFX_EXPLODE = love.audio.newSource('assets/sfx/explosion_29.wav', 'static')
    SFX_HURT    = love.audio.newSource('assets/sfx/hurt_025.wav', 'static')
    SFX_SHOOT   = love.audio.newSource('assets/sfx/laser_001.wav', 'static')

    SFX_EXPLODE:setVolume(.4)
    SFX_SHOOT:setVolume(.2)
    SFX_HURT:setVolume(.3)

    HUD_HEIGHT = love.graphics.getHeight() *  0.05

    --[[
        Using glow effect from moonshine.
        https://github.com/vrld/moonshine
    ]]
    local moonshine = require 'moonshine'
    GhostEffect = moonshine(WINDOW_WIDTH, WINDOW_HEIGHT, moonshine.effects.glow)
    GhostEffect.parameters = {
        glow = {strength = 1, min_luma = 1}
    }

    love.window.setTitle('TanKet')
    --[[
        Running game in windowed mode with no resizability.
        Might add resizable or fullscreen later.
    ]]
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = 1,
        fullscreen = false,
        resizable = false
    })

    --[[
        set up the canvas for the bacground ground and grass
    ]]
    ground_canvas = love.graphics.newCanvas(love.graphics.getDimensions())

    --- render the soil and grass tiles on the canvas using alpha blend mode
    love.graphics.setCanvas(ground_canvas)
        love.graphics.clear()
        love.graphics.setBlendMode("alpha")
        love.graphics.setColor(1,1,1,0.9)
        for i = 0, love.graphics.getWidth() / SOIL_PNG:getWidth() do
            for j = 0, love.graphics.getHeight() / SOIL_PNG:getHeight() do
                love.graphics.draw(math.random() < 0.3 and GRASS_PNG or SOIL_PNG, i * SOIL_PNG:getWidth(), j * SOIL_PNG:getHeight())
            end
        end
    love.graphics.setCanvas()

    ----------------------------------------------------------------
    -- Important Game Variables
    ----------------------------------------------------------------
    --[[
        Gamestate is one of:
            - "start"       -- start screen
            - "play"        -- game is being played
            - "nextLevel"   -- interval between two consecutive levels
            - "over"        -- game over
    ]]
    Gamestate = "start"

    Level = 1
    Enemy_Count = 50

    PlayerTank = Tank(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
    PlayerScore = 0

    ListOfEnemies = {}
    ListOfMissiles = {}

    spawnEnemies(Enemy_Count)
end

--[[
    Handle Player movements: using wasd keys for movement control
]]
function player_movement(dt)
    if love.keyboard.isDown('w') then
        PlayerTank:moveForward(dt)
    elseif love.keyboard.isDown('s') then
        PlayerTank:moveBackward(dt)
    elseif love.keyboard.isDown('a') then
        PlayerTank:turnLeft(dt)
    elseif love.keyboard.isDown('d') then
        PlayerTank:turnRight(dt)
    end

    --- Is turrent rotate?
    if love.keyboard.isDown('right') then
        PlayerTank:turnClock(dt)
    elseif love.keyboard.isDown('left') then
        PlayerTank:turnAntiClock(dt)
    end
end

--[[
    Update the state while game is in the "play" state
]]
function love.update(dt)
    if Gamestate == "start" then
        --[[
            handle events that trigger the "play" state.
            And make the "start" screen little interactive by adding animation
        ]]
    elseif Gamestate == "play" then
        player_movement(dt)

        --[[
            update the missile positions
            and remove the ones that go off-screen
        ]]
        for i, missile in ipairs(ListOfMissiles) do
            local x, y = missile:getPos()
            -- remove the missiles if out of screen
            if x > WINDOW_WIDTH and x < WINDOW_WIDTH or
               y > WINDOW_HEIGHT and y < WINDOW_HEIGHT then
                   table.remove(ListOfMissiles, i)
            else
                missile:update(dt)
            end
        end

        --[[
            update the enemy position
        ]]
        for _, enemy in ipairs(ListOfEnemies) do
            --[[
                enemy is colliding with player and inflicts damage to the player
            ]]
            if areCollidingWith(enemy, PlayerTank) then
                -- if SFX_HURT:isPlaying() then
                --     SFX_HURT:stop()
                -- end
                SFX_HURT:play()
                PlayerTank:inflictDamage(enemy:getDamage())
                
                -- is player dead?
                if PlayerTank:getHealth() == 0 then    -- yes
                    Gamestate = 'over'
                end
            end
            enemy:moveTowards(dt, PlayerTank:getPos())
        end

        --- clear current level, load next level
        if #ListOfEnemies == 0 then
            Gamestate = "nextLevel"
        end
    end
end

function love.draw()
    if Gamestate == "start" then
        --[[
            print a big welcome message onto the screen,
            and other messages, including lore
        ]]
        -- for now just print a simple message
        love.graphics.printf(
            'Press Enter to Start the Game',
            TITLE_FONT,
            0,
            WINDOW_HEIGHT / 2 - 6,
            WINDOW_WIDTH,
            "center"
        )

    elseif Gamestate == "play" then
        drawBackground()
        ---
        PlayerTank:render()

        ----- render the enemies with the ghost effect glow
        GhostEffect(function ()
            for _, enemy in ipairs(ListOfEnemies) do
                enemy:render()
            end
        end)

        ----- following loop does three things:
        -- renders missile
        -- renders bullet
        -- removes colliding missile and enemy, and increment the score
        for i, missile in ipairs(ListOfMissiles) do
            missile:render()

            for j, enemy in ipairs(ListOfEnemies) do
                if areCollidingWith(enemy, missile) then
                    renderExplosionAt(missile:getPos())
                    table.remove(ListOfEnemies, j)
                    table.remove(ListOfMissiles, i)
                    PlayerScore = PlayerScore + 1
                end
            end
        end
        drawHUD()

    elseif Gamestate == "over" then
        -- for now just print a simple message
        love.graphics.printf(
            'Game Over',
            EXTRA_BIG_FONT,
            0,
            WINDOW_HEIGHT / 2 - 6,
            WINDOW_WIDTH,
            "center"
        )

        --print user score
        love.graphics.printf(
            'Your Score: ' .. PlayerScore,
            SUBTITLE_FONT,
            0,
            WINDOW_HEIGHT / 2 - 6 + 50,
            WINDOW_WIDTH,
            'center'
        )

        -- tell user how to reset
        love.graphics.printf(
            'Press Enter to return to Title screen\nPress Esc to quit',
            MED_FONT,
            0,
            WINDOW_HEIGHT - 100,
            WINDOW_WIDTH,
            'center'
        )

    elseif Gamestate == "nextLevel" then
        drawBackground()
        -----
        love.graphics.setColor(1, 1, 0)
        love.graphics.printf(
            'Congratulations! You cleared Level ' .. Level,
            SUBTITLE_FONT,
            0,
            WINDOW_HEIGHT / 2 - 6,
            WINDOW_WIDTH,
            "center"
        )
        love.graphics.printf(
            'Press Enter to go to next Level...',
            MED_FONT,
            0,
            WINDOW_HEIGHT / 2 - 6 + 100,
            WINDOW_WIDTH,
            "center"
        )
    end
end


--[[
    Keypressed events: handle changes in Gamestate, and quit event
]]
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if Gamestate == "start" then
            Gamestate = "play"

        elseif Gamestate == "over" then
            reset()

        elseif Gamestate == "nextLevel" then
            Gamestate = "play"
            loadNextLevel()
        end
    end
end

function love.keyreleased(key)
    local dt = love.timer.getDelta()

    if Gamestate == "play" then
        --[[
            shoot control is here so as to prevent player
            from holding down 'space' and continuously relase missile stream.
        ]]
        if key == 'space' then  --- shoot the missile
            if SFX_SHOOT:isPlaying() then
                SFX_SHOOT:stop()
            end
            SFX_SHOOT:play()
            table.insert(ListOfMissiles, #ListOfMissiles + 1, Missile(PlayerTank:getTurretMouth()))
        end
    end
end

function love.quit()
    print('Thanks for playing! Come back soon!')
end

--[[
    Randomly spawn 4 enemies off the screen
]]
function spawnEnemies(num)
    for i = 1, num do
        -- random value used to get the enemies on random 
        local rnd = math.random()
        local dir = math.random(-1,1)   -- use for generating on horizontal regions (-1) or vertical (1)
        local enemy = nil

        -- off-screen 50 px region is used for enemy spawn
        local rnd_x_pos = math.random() < .5 and math.random(-50, 0) or math.random(WINDOW_WIDTH, WINDOW_WIDTH + 50)
        local rnd_y_pos = math.random() < .5 and math.random(-50, 0) or math.random(WINDOW_HEIGHT, WINDOW_HEIGHT + 50)

        if rnd < .25 then  -- call Fan350, our fastest enemey (ghost)
            enemy = dir == -1 and Fan350(rnd_x_pos, math.random(WINDOW_HEIGHT)) -- generate at left or right of screen
                              or  Fan350(math.random(WINDOW_WIDTH), rnd_y_pos)  -- genertae at top or bottom of screen

        elseif rnd >= .25 and rnd < .50 then    -- call Gantasmito (ghost)
            enemy = dir == -1 and Gantasmito(rnd_x_pos, math.random(WINDOW_HEIGHT)) -- generate at left or right of screen
                              or  Gantasmito(math.random(WINDOW_WIDTH), rnd_y_pos)  -- genertae at top or bottom of screen

        elseif rnd >= .5 and rnd < .75 then     -- call Perro_Huevo (mole)
            enemy = dir == -1 and Demonio(rnd_x_pos, math.random(WINDOW_HEIGHT)) -- generate at left or right of screen
                              or  Demonio(math.random(WINDOW_WIDTH), rnd_y_pos)  -- genertae at top or bottom of screen

        else    -- call Pez (fish)
            enemy = dir == -1 and Oscuro(rnd_x_pos, math.random(WINDOW_HEIGHT)) -- generate at left or right of screen
                              or  Oscuro(math.random(WINDOW_WIDTH), rnd_y_pos)  -- genertae at top or bottom of screen
        end

        -- Increase Enemy Damage and speed based on Level
        enemy:setDamage(enemy:getDamage() * Level)
        enemy:setSpeed(enemy:getSpeed() + 0.1)

        -- add to enemy list
        table.insert(ListOfEnemies, #ListOfEnemies + 1, enemy)
    end
end

--[[
    Renders the current FPS.
]]
function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(SMALL_FONT)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(1,1,1)
end

--[[
    draws the explosion image at the given coordinates
]]
function renderExplosionAt(x, y)
    if SFX_EXPLODE:isPlaying() then
        SFX_EXPLODE:stop()
    end
    SFX_EXPLODE:play()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(EXPLOSION_PNG, x, y, 0, 0.3, 0.3, EXPLOSION_PNG:getWidth() / 2, EXPLOSION_PNG:getHeight() / 2)
end

--[[
    Body Body -> Boolean
    produce true if the two given Body objects are colliding
    -- using AABB collision detection technique --

    note: invalid input also produces Boolean false
]]
function areCollidingWith(a, b)
    if not a:is(Body) and b:is(Body) then return false end     -- handle invalid Object

    local a_left, a_top = a:getPos()
    local a_right, a_bottom = a:getDimensions()
    a_right = a_right + a_left  -- correct the position of right edge, from getDimensions()
    a_bottom = a_bottom + a_top -- similarly for top edge

    local b_left, b_top = b:getPos()
    local b_right, b_bottom = b:getDimensions()
    b_right = b_right + b_left  -- correct the position of right edge, from getDimensions()
    b_bottom = b_bottom + b_top -- similarly for top edge

    --If Red's right side is further to the right than Blue's left side.
    if  a_right > b_left
    --and Red's left side is further to the left than Blue's right side.
    and a_left < b_right
    --and Red's bottom side is further to the bottom than Blue's top side.
    and a_bottom > b_top
    --and Red's top side is further to the top than Blue's bottom side then..
    and a_top < b_bottom then
        --There is collision!
        return true
    else
        --If one of these statements is false, return false.
        return false
    end
end

--[[
    draws a health bar at the middle left corner
]]
function drawHealthBar(hp)
    local total_width = 300
    local max_hp = 1000
    local green_width = math.floor(total_width * hp / max_hp)
    local red_width = math.floor(total_width * (max_hp - hp) / max_hp)

    love.graphics.setColor(1,1,1)
    love.graphics.printf(
        'Health: ',
        SMALL_FONT,
        5,       --- x coordinate
        10,      --- y coordinate
        50,      --- limit
        'left'   --- align
    )
    love.graphics.setColor(0,0.9,0)
    ------------------------- x-offset of 50 px
    love.graphics.rectangle('fill', 50, 10, green_width, HUD_HEIGHT - 20)                                  -- draw green rectangle
    love.graphics.setColor(0.9,0,0)
    love.graphics.rectangle('fill', 50 + green_width, 10, red_width, HUD_HEIGHT - 20) -- draw green rectangle
end

--[[
    draw heads up display
]]
function drawHUD()
    love.graphics.setColor(68/255, 68/255, 68/255, .9)
    love.graphics.rectangle('fill', 0,0, love.graphics.getWidth(), HUD_HEIGHT)
    drawHealthBar(PlayerTank:getHealth())
    printScore()
    displayLevel()
end

--[[
    print user score
]]
function printScore()
    love.graphics.setColor(1,1,1)
    love.graphics.printf(
        'Score: ' .. tostring(PlayerScore),
        MED_FONT,
        400,   --- x coordinate
        5,    --- y coordinate
        150,   --- limit
        'left' --- align
    )
end

function displayLevel()
    love.graphics.setColor(1,1,1)
    love.graphics.printf(
        'Level ' .. tostring(Level),
        MED_FONT,
        600,   --- x coordinate
        5,    --- y coordinate
        150,   --- limit
        'left' --- align
    )
end

function drawBackground()
        -- very important!: reset color before drawing to canvas to have colors properly displayed
        -- see discussion here: https://love2d.org/forums/viewtopic.php?f=4&p=211418#p211418
        love.graphics.setColor(1, 1, 1, 1)

        -- Use the premultiplied alpha blend mode when drawing the Canvas itself to prevent improper blending.
        love.graphics.setBlendMode("alpha")
        love.graphics.draw(ground_canvas)
end

function loadNextLevel()
    Level = Level + 1
    Enemy_Count = Enemy_Count + 50
    ListOfMissiles = {}   ---------- reset the list of missiles
    spawnEnemies(Enemy_Count)
end

--[[
    Reset the Game variables to play a new game
]]
function reset()
    Gamestate = "start"

    Level = 1
    Enemy_Count = 50

    PlayerTank = Tank(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
    PlayerScore = 0

    ListOfEnemies = {}
    ListOfMissiles = {}

    spawnEnemies(Enemy_Count)
end