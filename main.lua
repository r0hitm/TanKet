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
    require 'Enemy'
    require 'Missile'

    math.randomseed(os.time())

    ----------------------------------------------------------------------------
    -- Constants:
    WINDOW_WIDTH = 1280
    WINDOW_HEIGHT = 720

    TITLE_FONT = love.graphics.newFont('font/market_deco.ttf', 30)
    SMALL_FONT = love.graphics.newFont('font/market_deco.ttf', 12)

    tank = Tank(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
    listOfEnemies = {}
    listOfMissiles = {}
    spawnEnemies(100)

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
            tank:turnClock()
        elseif love.keyboard.isDown('left') then
            tank:turnAntiClock()
        end

        for _, missile in ipairs(listOfMissiles) do
            missile:update(dt)
        end

        for _, enemy in ipairs(listOfEnemies) do
            enemy:approach(dt, WINDOW_WIDTH / 2 - 30, WINDOW_HEIGHT / 2 - 30)
        end
    end
end

function love.draw()
    displayFPS()

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
        love.graphics.setBackgroundColor(0.5, 0.5, 0.15)
        tank:render()

        for _, enemy in ipairs(listOfEnemies) do
            enemy:render()
        end

        for _, missile in ipairs(listOfMissiles) do
            missile:render()
        end
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
    if key == 'space' then
        table.insert(listOfMissiles, #listOfMissiles + 1, Missile(tank:getTurretPos()))
    end
end

function love.quit()
    print('Thanks for playing! Come back soon!')
end

--[[
    Object Object -> Boolean
    produce true if the given objects are colliding
]]
function areColliding(object1, object2)
    if not object1 and object2 then  -- either of the objects is nil
        return false
    end

    -- using AABB collision detection

end

--[[
    Randomly spawn 4 enemies off the screen
]]
function spawnEnemies(num)
    local i = 1
    while i <= num do
        table.insert(
            listOfEnemies,
            #listOfEnemies + 1,
            Enemy(math.random() < .5 and math.random(-100, 0) or math.random(WINDOW_WIDTH, WINDOW_WIDTH + 100),
                math.random(WINDOW_HEIGHT)))

        table.insert(listOfEnemies,
            #listOfEnemies + 1,
            Enemy(math.random(WINDOW_WIDTH),
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