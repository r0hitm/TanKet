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

    TITLE_FONT = love.graphics.newFont('font/market_deco.ttf', 30)
    MED_FONT   = love.graphics.newFont('font/market_deco.ttf', 16)
    SMALL_FONT = love.graphics.newFont('font/market_deco.ttf', 12)

    EXPLOSION_PNG = love.graphics.newImage('img/explosion.png')
    SOIL_PNG = love.graphics.newImage('img/ground/soil.jpg')
    GRASS_PNG = love.graphics.newImage('img/ground/grass.jpg')

    HUD_HEIGHT = love.graphics.getHeight() *  0.05

    --[[
        Using glow effect from moonshine.
        https://github.com/vrld/moonshine
    ]]
    local moonshine = require 'moonshine'
    ghost_effect = moonshine(WINDOW_WIDTH, WINDOW_HEIGHT, moonshine.effects.glow)
    ghost_effect.parameters = {
        glow = {strength = 1, min_luma = 1}
    }

    player_tank = Tank(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
    player_score = 0

    listOfEnemies = {}
    listOfMissiles = {}
    spawnEnemies(50)

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

    --[[
        Gamestate is one of:
            - "start"
            - "play"
        interp, two states of game, play - when game is being played
        and, start - when the game is just started
    ]]
    Gamestate = "start"
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
        if love.keyboard.isDown('right') then
            player_tank:turnClock(dt)
        elseif love.keyboard.isDown('left') then
            player_tank:turnAntiClock(dt)
        elseif love.keyboard.isDown('w') then
            player_tank:moveForward(dt)
        elseif love.keyboard.isDown('s') then
            player_tank:moveBackward(dt)
        elseif love.keyboard.isDown('a') then
            player_tank:turnLeft(dt)
        elseif love.keyboard.isDown('d') then
            player_tank:turnRight(dt)
        end

        --[[
            update the missile positions
            and remove the ones that go off-screen
        ]]
        for i, missile in ipairs(listOfMissiles) do
            local x, y = missile:getPos()
            -- remove the missiles if out of screen
            if x > WINDOW_WIDTH and x < WINDOW_WIDTH or
               y > WINDOW_HEIGHT and y < WINDOW_HEIGHT then
                   table.remove(listOfMissiles, i)
            else
                missile:update(dt)
            end
        end

        --[[
            update the enemy position
        ]]
        for _, enemy in ipairs(listOfEnemies) do
            --[[
                enemy is colliding with player and inflicts damage to the player
            ]]
            if areCollidingWith(enemy, player_tank) then
                player_tank:inflictDamage()
                
                -- is player dead?
                if player_tank:getHealth() == 0 then    -- yes
                    Gamestate = 'over'
                end
            end
            enemy:moveTowards(dt, player_tank:getPos())
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
        -- very important!: reset color before drawing to canvas to have colors properly displayed
        -- see discussion here: https://love2d.org/forums/viewtopic.php?f=4&p=211418#p211418
        love.graphics.setColor(1, 1, 1, 1)

        -- Use the premultiplied alpha blend mode when drawing the Canvas itself to prevent improper blending.
        love.graphics.setBlendMode("alpha")
        love.graphics.draw(ground_canvas)
        
        ---
        player_tank:render()

        ----- render the enemies with the ghost effect glow
        ghost_effect(function ()
            for _, enemy in ipairs(listOfEnemies) do
                enemy:render()
            end
        end)

        ----- following loop does three things:
        -- renders missile
        -- renders bullet
        -- removes colliding missile and enemy, and increment the score
        for i, missile in ipairs(listOfMissiles) do
            missile:render()

            for j, enemy in ipairs(listOfEnemies) do
                if areCollidingWith(enemy, missile) then
                    renderExplosionAt(missile:getPos())
                    table.remove(listOfEnemies, j)
                    table.remove(listOfMissiles, i)
                    player_score = player_score + 1
                end
            end
        end
        drawHUD()
    end
end


--[[
    Keypressed events: handle changes in Gamestate, and quit event
]]
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if Gamestate == "start" then Gamestate = "play" end
    end
end

function love.keyreleased(key)
    if key == 'down' then
        table.insert(listOfMissiles, #listOfMissiles + 1, Missile(player_tank:getTurretMouth()))
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
            enemy = dir == -1 and Perro_Huevo(rnd_x_pos, math.random(WINDOW_HEIGHT)) -- generate at left or right of screen
                              or  Perro_Huevo(math.random(WINDOW_WIDTH), rnd_y_pos)  -- genertae at top or bottom of screen

        else    -- call Pez (fish)
            enemy = dir == -1 and Pez(rnd_x_pos, math.random(WINDOW_HEIGHT)) -- generate at left or right of screen
                              or  Pez(math.random(WINDOW_WIDTH), rnd_y_pos)  -- genertae at top or bottom of screen
        end
        
        -- add to enemy list
        table.insert(listOfEnemies, #listOfEnemies + 1, enemy)
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
    local green_width = math.floor(total_width * hp / 1000)
    local red_width = math.floor(total_width * (1000 - hp) / 1000)

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
    drawHealthBar(player_tank:getHealth())
    printScore()
end

--[[
    print user score
]]
function printScore()
    love.graphics.setColor(1,1,1)
    love.graphics.printf(
        'Score: ' .. tostring(player_score),
        MED_FONT,
        400,   --- x coordinate
        5,    --- y coordinate
        150,   --- limit
        'left' --- align
    )
end