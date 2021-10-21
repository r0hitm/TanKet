--[[
    TanKet
    - A Tower Defense Survival Game.
    - Player has to survive as long as possible from a hoard of attackers.

    --- Missile Class ---

    Author: Rohit Mehta

    Represents the missiles that the Tower shoots.
    Missile eliminates the Enemy on collision.
]]

Missile = Object:extend()

-- missile Speed
local SPEED = 3

--[[
    Move is one of
    - 'ltr'
    - 'rtl'
    - 'ttb'
    - 'btt'

    interp, moving left-to-right, right-to-left, top-to-bottom or, botom-to-top
]]

function Missile:new(x, y, move)
    if not x and y and move then
        error('Invalid Missile Object')
    end

    self.x = x
    self.y = y
    self.move = move
end

function Missile:update()
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

function Missile:render()
    love.graphics.setColor(1, 0.4, 0.4)
    love.graphics.ellipse('fill', self.x, self.y, 4, 2)
end