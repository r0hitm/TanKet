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

    require 'Tank'
    require 'EnemyList'
    require 'Missile'

    math.randomseed(os.time())

    ----------------------------------------------------------------------------
    -- Constants:
    WINDOW_WIDTH = 1280
    WINDOW_HEIGHT = 720

    TITLE_FONT = love.graphics.newFont('font/market_deco.ttf', 30)
    SMALL_FONT = love.graphics.newFont('font/market_deco.ttf', 12)

    EXPLOSION_PNG = love.graphics.newImage('img/explosion.png')
    SOIL_PNG = love.graphics.newImage('img/ground/soil.jpg')
    GRASS_PNG = love.graphics.newImage('img/ground/grass.jpg')

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

        for _, enemy in ipairs(listOfEnemies) do
            enemy:approach(dt, player_tank:getPos())
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

        ghost_effect(function ()
            for _, enemy in ipairs(listOfEnemies) do
                enemy:render()
            end
        end)

        for i, missile in ipairs(listOfMissiles) do
            missile:render()

            for j, enemy in ipairs(listOfEnemies) do
                local x1, y1 = missile:getPos()
                local x2, y2 = enemy:getPos()
                if areColliding(x1, y1, x2, y2) then
                    renderExplosionAt(missile:getPos())
                    table.remove(listOfEnemies, j)
                    table.remove(listOfMissiles, i)
                end
            end
        end
    end
    displayFPS()
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
    Number Number Number Number -> Boolean
    produce true if the given objects, passed as two pairs of numbers, are colliding
]]
function areColliding(x1, y1, x2, y2)
    local HIT_RANGE = 20 * math.sqrt(2) / 2
    local hit_radius = math.sqrt((x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2))

    if hit_radius <= HIT_RANGE then
        return true
    else
        return false
    end

end

--[[
    Randomly spawn 4 enemies off the screen
]]
function spawnEnemies(num)
    local i = 1
    while i <= num do
        -- random value used to get the enemies on random 
        local rnd = math.random()

        if rnd < 0.25 then  -- call Fan350, our fastest enemey (ghost)
            table.insert(
                listOfEnemies,
                #listOfEnemies + 1,
                Fan350(math.random() < .5 and math.random(-100, 0) or math.random(WINDOW_WIDTH, WINDOW_WIDTH + 100),
                math.random(WINDOW_HEIGHT)))

        elseif rnd >= .25 and rnd < .50 then    -- call Gantasmito (ghost)
            table.insert(
                listOfEnemies,
                #listOfEnemies + 1,
                Gantasmito(math.random() < .5 and math.random(-100, 0) or math.random(WINDOW_WIDTH, WINDOW_WIDTH + 100),
                math.random(WINDOW_HEIGHT)))

        elseif rnd >= .5 and rnd < .75 then     -- call Perro_Huevo (mole)
            table.insert(
                listOfEnemies,
                #listOfEnemies + 1,
                Perro_Huevo(math.random() < .5 and math.random(-100, 0) or math.random(WINDOW_WIDTH, WINDOW_WIDTH + 100),
                math.random(WINDOW_HEIGHT)))

        else    -- call pez (fish)
            table.insert(
                listOfEnemies,
                #listOfEnemies + 1,
                Pez(math.random() < .5 and math.random(-100, 0) or math.random(WINDOW_WIDTH, WINDOW_WIDTH + 100),
                math.random(WINDOW_HEIGHT)))
        end
        table.insert(
            listOfEnemies,
            #listOfEnemies + 1,
            Perro_Huevo(math.random() < .5 and math.random(-100, 0) or math.random(WINDOW_WIDTH, WINDOW_WIDTH + 100),
                math.random(WINDOW_HEIGHT)))

        table.insert(listOfEnemies,
            #listOfEnemies + 1,
            Pez(math.random(WINDOW_WIDTH),
                math.random() < .5 and math.random(-100, 0) or math.random(WINDOW_HEIGHT, WINDOW_HEIGHT + 100)))
        i = i + 1
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