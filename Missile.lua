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
    Return the position
]]
function Missile:getPos()
    return self.x, self.y
end

--[[
    returns the angle of the missile travel
]]
function Missile:getAngle()
    return self.angle
end

--[[
    move the missile in the direction of angle
]]
function Missile:update(dt)
    self.x = self.x + SPEED * math.cos(self.angle)
    self.y = self.y + SPEED * math.sin(self.angle)
end

function Missile:render()
    love.graphics.setColor(0, 0, 0)
    love.graphics.ellipse('fill', self.x, self.y, 6, 4)
end