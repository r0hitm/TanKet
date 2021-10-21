--[[
    TanKet
    - A Tower Defense Survival Game.
    - Player has to survive as long as possible from a hoard of attackers.

    Author: Rohit Mehta

    This is my Final Project for the CS50x 2021 Course by Harvard.
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

    require 'Tower'
    require 'Enemy'
    require 'Missile'

    ----------------------------------------------------------------------------
    -- Constants:
    WINDOW_WIDTH = 1280
    WINDOW_HEIGHT = 720

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

    player = Tower(WINDOW_WIDTH / 2 - 30, WINDOW_HEIGHT / 2 - 30) -- the central tower

    -- testEnemy = Enemy(WINDOW_WIDTH, WINDOW_HEIGHT / 2, 'rtl')
    -- testMissile = Missile(WINDOW_WIDTH / 2 - 30, WINDOW_HEIGHT / 2 - 30, 'ltr')

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
        
    elseif Gamestate == "play" then

    end
    if love.keyboard.isDown('w') then
        player:moveUp()
    elseif love.keyboard.isDown('s') then
        player:moveDown()
    elseif love.keyboard.isDown('d') then
        player:moveRight()
    elseif love.keyboard.isDown('a') then
        player:moveLeft()
    end
end

function love.draw()
    -- testEnemy:render()
    player:render()
    -- testMissile:render()
end


--[[
    Keypressed events: handle changes in Gamestate, and quit event
]]
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' then
        if Gamestate == "start" then Gamestate = "play" end
    end
end

--[[
    Object Object -> Boolean
    produce true if the given objects are colliding
]]
---@diagnostic disable-next-line: lowercase-global
function areColliding(object1, object2)
    if not object1 and object2 then  -- either of the objects is nil
        return false
    end

    -- using AABB collision detection

end