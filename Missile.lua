--[[
    TanKet
    - A very minimal Tower Defense Survival Game.
    - Player has to survive as long as possible from a hoard of attackers.

    --- Missile Class ---

    Author: Rohit Mehta

    Represents the missiles that the Tank shoots.
    Missile eliminates the Enemy on collision.
]]

Missile = Body:extend()

function Missile:new(x, y, theta)
    Missile.super.new(self, x, y)
    self.angular_position = theta
    self.speed = self.speed * 100        -- Bullet travels fastest in the game

    self.sprite = love.graphics.newImage('img/bullet.png')
    
    self.width = self.sprite:getHeight() * self.scale
    self.height = self.sprite:getWidth() * self.scale
end

--[[
    move the missile in the direction of angle
]]
function Missile:update(dt)
    self.x = self.x + self.speed * math.cos(self.angular_position) * dt
    self.y = self.y + self.speed * math.sin(self.angular_position) * dt
end