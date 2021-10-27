--[[
    TanKet
    - A very minimal Tower Defense Survival Game.
    - Player has to survive as long as possible from a hoard of attackers.

    Author: Rohit Mehta

    This is my Final Project for the CS50x 2021 Course by Harvard.
]]

require 'utils'

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
    require 'Projectile'

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

    MUSIC_START = love.audio.newSource('assets/music/Ludum Dare 32 - Track 1.wav', 'stream')
    MUSIC_PLAY = love.audio.newSource('assets/music/Ludum Dare 32 - Track 4.wav', 'stream')
    MUSIC_OVER = love.audio.newSource('assets/music/Ludum Dare 32 - Track 2.wav', 'stream')

    MUSIC_START:setVolume(.4)
    MUSIC_PLAY:setVolume(.4)
    MUSIC_OVER:setVolume(.4)

    MUSIC_START:setLooping(true)
    MUSIC_PLAY:setLooping(true)
    MUSIC_OVER:setLooping(true)

    HUD_HEIGHT = love.graphics.getHeight() *  0.05

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
    reset() -- contains all important game variables
end

--[[
    Update the state while game is in the "play" state
]]
function love.update(dt)
    if Gamestate == "start" then
        --[[
            start the start streaming music
        ]]
        if MUSIC_PLAY:isPlaying() or MUSIC_OVER:isPlaying() then
            MUSIC_OVER:pause()
            MUSIC_PLAY:pause()
        end
        if not MUSIC_START:isPlaying() then
            MUSIC_START:play()
        end

    elseif Gamestate == "play" then
        --- stream the play music
        if MUSIC_START:isPlaying() or MUSIC_OVER:isPlaying() then
            MUSIC_OVER:pause()
            MUSIC_START:pause()
        end
        if not MUSIC_PLAY:isPlaying() then
            MUSIC_PLAY:play()
        end

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
            if areColliding(enemy, PlayerTank) then
                -- if SFX_HURT:isPlaying() then
                --     SFX_HURT:stop()
                -- end
                SFX_HURT:play()
                PlayerTank:inflictDamage(enemy:getDamage())
            end

            -- shoot missile at random
            if math.random(0,500) == 1  then
                local projectile = Projectile(enemy:getPos())
                projectile:setDirection(PlayerTank:getPos())
                table.insert(ListOfProjectiles, #ListOfProjectiles + 1, projectile)
            end

            enemy:move(dt)
        end

        for i, projectile in ipairs(ListOfProjectiles) do
            local x, y = projectile:getPos()
            -- remove the projectiles if out of screen
            if x > WINDOW_WIDTH and x < WINDOW_WIDTH or
               y > WINDOW_HEIGHT and y < WINDOW_HEIGHT then
                   table.remove(ListOfProjectiles, i)

            elseif areColliding(projectile, PlayerTank) then
                SFX_HURT:play()
                PlayerTank:inflictDamage(projectile:getDamage())
                table.remove(ListOfProjectiles, i)

            else
                projectile:update(dt)
            end
        end

        -- is player dead?
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

        --- clear current level, load next level
        if #ListOfEnemies == 0 then
            Gamestate = "nextLevel"
            if MUSIC_PLAY:isPlaying() or MUSIC_START:isPlaying() then
                MUSIC_PLAY:pause()
                MUSIC_START:pause()
            end
            if not MUSIC_OVER:isPlaying() then
                MUSIC_OVER:play()
            end
        end
    end
end

function love.draw()
    if Gamestate == "start" then
        --[[
            print a big welcome message onto the screen,
            and other messages, including lore
        ]]
        love.graphics.setBackgroundColor(35/255,53/255,43/255)
        love.graphics.printf(
            'TanKet',
            EXTRA_BIG_FONT,
            0,          -- x position
            100,        -- y position
            WINDOW_WIDTH,
            "center"
        )

        love.graphics.printf(
            'Press Enter to Start',
            SUBTITLE_FONT,
            0,
            300,
            WINDOW_WIDTH,
            "center"
        )

        love.graphics.printf(
            'Press Esc to Quit',
            SUBTITLE_FONT,
            0,
            350,
            WINDOW_WIDTH,
            "center"
        )

        love.graphics.printf(
            'Controls:',
            MED_FONT,
            10,
            450,
            WINDOW_WIDTH,
            "left"
        )

        love.graphics.printf(
            'w - move forward\na - turn left\ns - move backwards\nd - turn right\n'
            .. '<- - turn turret anticlockwise\n-> - turn turret clockwise\n'
            .. 'space - shoot missile',
            MED_FONT,
            20,
            480,
            WINDOW_WIDTH,
            "left"
        )

        love.graphics.printf(
            'Can you survive the ghost apocalypse?',
            MED_FONT,
            10,
            450,
            WINDOW_WIDTH,
            "center"
        )

    elseif Gamestate == "play" then
        love.graphics.setBackgroundColor(0,0,0)
        drawBackground()
        ---
        PlayerTank:render()

        for i, enemy in ipairs(ListOfEnemies) do
            --- remove the enemies if they reach out of screen
            local x, y = enemy:getPos()
            if x > WINDOW_WIDTH or x < 0 or
                y > WINDOW_HEIGHT or y < 0 then
                    table.remove(ListOfEnemies, i)
                end

            enemy:render()
        end

        ----- following loop does three things:
        -- renders missile
        -- renders bullet
        -- removes colliding missile and enemy, and increment the score
        for i, missile in ipairs(ListOfMissiles) do
            missile:render()

            for j, enemy in ipairs(ListOfEnemies) do
                if areColliding(enemy, missile) then
                    renderExplosionAt(missile:getPos())
                    table.remove(ListOfEnemies, j)
                    table.remove(ListOfMissiles, i)
                    PlayerScore = PlayerScore + 1
                end
            end
        end

        -- render all the projectiles onto the screen
        for _, projectile in ipairs(ListOfProjectiles) do
            projectile:render()
        end

        drawHUD()

    elseif Gamestate == "over" then
        love.graphics.setBackgroundColor(35/255,53/255,43/255, .8)
        drawBackground()

        love.graphics.printf(
            'Game Over',
            EXTRA_BIG_FONT,
            0,
            WINDOW_HEIGHT * .4,
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

            -- reset player
            PlayerTank = Tank(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
            loadNextLevel()
        end
    end
end

function love.keyreleased(key)
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