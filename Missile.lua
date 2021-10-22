--[[
    TanKet
    - A very minimal Tower Defense Survival Game.
    - Player has to survive as long as possible from a hoard of attackers.

    --- Missile Class ---

    Author: Rohit Mehta

    Represents the missiles that the Tank shoots.
    Missile eliminates the Enemy on collision.
]]

Missile = Object:extend()

-- missile Speed
local SPEED = 3

function Missile:new(x, y, angle)
    if not x and y and angle then
        error('Invalid Missile Object')
    end

    self.x = x
    self.y = y

    self.angle = angle  -- (in radians) travel direction
end

--[[
    Return the position and the direction of travel of the missile
]]
function Missile:getPos()
    return self.x, self.y, self.angle
end

--[[
    move the missile in the direction of angle
]]
function Missile:update(dt)
    self.x = self.x + SPEED * math.cos(self.angle - math.pi / 2)    -- adjust for the turret angle offset of math.pi / 2
    self.y = self.y + SPEED * math.sin(self.angle - math.pi / 2)
end

function Missile:render()
    love.graphics.setColor(0, 0, 0)
    love.graphics.ellipse('fill', self.x, self.y, 6, 4)
end