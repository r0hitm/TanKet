--[[
    TanKet
    - A very minimal Tower Defense Survival Game.
    - Player has to survive as long as possible from a hoard of attackers.

    Author: Rohit Mehta

    Contains utility functions and methods for main.lua
]]

--[[
    Handle Player movements: using wasd keys for movement control
]]
function player_movement(dt)
    if love.keyboard.isDown('w') then
        PlayerTank:moveForward(dt)
    elseif love.keyboard.isDown('s') then
        PlayerTank:moveBackward(dt)
    end

    if love.keyboard.isDown('a') then
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
    Spawn a Enemy for the current Level (gloabl variable)
]]
function spawnEnemy()
    local enemy = nil

    -- randomly choose the enemy to spawn at their respective spawn location
    local rnd = math.random(1, 4)
    if rnd == 1 then
        enemy = Fan350(0, math.random(500))

    elseif rnd == 2 then
        enemy = Gantasmito(0, WINDOW_HEIGHT - 500)

    elseif rnd == 3 then
        if math.random() <= 0.5 then
            enemy = Demonio(math.random(WINDOW_WIDTH - 500, WINDOW_WIDTH), 100, false)
        else
            enemy = Demonio(math.random(0, 500), WINDOW_HEIGHT, true)
        end

    else
        if math.random() <= 0.5 then
            enemy = Oscuro(math.random(0, 600), WINDOW_HEIGHT, true)
        else
            enemy = Oscuro(WINDOW_WIDTH, math.random(0, WINDOW_HEIGHT / 2 + 100), false)
        end
    end

    -- Increase Enemy speed based with each level
    enemy:setSpeed(enemy:getSpeed() + 0.5)

    -- add to enemy list
    table.insert(ListOfEnemies, #ListOfEnemies + 1, enemy)
end

--[[
    spawn multiple enemies
]]
local function spawnMultipleEnemies(n)
    for i = 1, n do
        spawnEnemy()
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
function areColliding(a, b)
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
    End the game if the player is dead
]]
function isPlayerDead()
    if PlayerTank:getHealth() == 0 then    -- yes
        Gamestate = 'over'
        if MUSIC_PLAY:isPlaying() or MUSIC_START:isPlaying() then
            MUSIC_PLAY:pause()
            MUSIC_START:pause()
        end
        if not MUSIC_OVER:isPlaying() then
            MUSIC_OVER:play()
        end
    end
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
    Enemy_Count = Enemy_Count + 5
    EnemiesToKill = Enemy_Count
    ListOfMissiles = {}   ---------- reset the list of missiles
    spawnMultipleEnemies(Enemy_Count)
end

--[[
    Reset the Game variables to play a new game
]]
function reset()
    Gamestate = "start"

    Level = 1
    Enemy_Count = 5

    PlayerTank = Tank(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
    PlayerScore = 0

    ListOfEnemies = {}
    ListOfMissiles = {}
    EnemiesToKill = Enemy_Count
    ListOfProjectiles = {}

    spawnMultipleEnemies(Enemy_Count)
end