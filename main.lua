--[[
    TanKet
    - A Two Player Tank Battle Game.

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

    -- Get the Tank class
    require 'Tank'

    ----------------------------------------------------------------------------
    -- Constants:
    WINDOW_WIDTH = 1280
    WINDOW_HEIGHT = 720

    TANK_SPEED = 10

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

    player = Tank(110, 200)

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

    if love.keyboard.isDown('w') then
        player.y = player.y - TANK_SPEED
    elseif love.keyboard.isDown('s') then
        player.y = player.y + TANK_SPEED
    elseif love.keyboard.isDown('d') then
        player.x = player.x + TANK_SPEED
    elseif love.keyboard.isDown('a') then
        player.x = player.x - TANK_SPEED
    end
end

function love.draw()
    love.graphics.setColor(1,1,1)
    love.graphics.printf(
        'Currently in "' .. Gamestate .. '" state.',
        0,
        100,
        WINDOW_WIDTH,
        'center'
    )
    player:render()
end


--[[
    Keypressed events: handle changes in Gamestate, and quit event
]]
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'space' or key == 'enter' then
        Gamestate = "play"
    end
end