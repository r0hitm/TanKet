--[[
    TanKet
    - A Two Player Tank Battle Game.

    -- Enemy Class --

    Author: Rohit Mehta

    Represents the enemies that attack from each edge towards the center.
]]

Enemy = Object:extend()

local WIDTH = 20
local HEIGHT = 20

local SPEED = 1

--[[
    Move is one of
    - 'ltr'
    - 'rtl'
    - 'ttb'
    - 'btt'

    interp, moving left-to-right, right-to-left, top-to-bottom or, botom-to-top
]]

-- Enemy:new()
-- Integer Integer Move -> Enemy
-- creates an enemy at x,y
function Enemy:new(x, y, move)
  self.x = x or 0
  self.y = y or 0

  self.move = move or 'rtl'
end

function Enemy:update()
    if self.move == 'ltr' then
        self.x = self.x + SPEED
    elseif self.move == 'rtl' then
        self.x = self.x - SPEED
    elseif self.move == 'ttb' then
        self.y = self.y + SPEED
    elseif self.move == 'btt' then
        self.y = self.y - SPEED
    end
end

-- draw the enemy onto the screen
function Enemy:render()
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle('fill', self.x, self.y, WIDTH, HEIGHT)
end

