--[[
    TanKet
    - A very minimal Tower Defense Survival Game.
    - Player has to survive as long as possible from a hoard of attackers.

    --- Missile Class ---

    Author: Rohit Mehta

    Represents the projectiles that enemy shoots
]]

Projectile = Body:extend()

function Projectile:new(x, y)
    Projectile.super.new(self, x, y)
    self.speed = self.speed * 100

    self.sprite = love.graphics.newImage('assets/projectile.png')

    self.scale = .4

    self.damage = 5

    self.width = self.sprite:getHeight() * self.scale
    self.height = self.sprite:getWidth() * self.scale
end

--[[
    move the missile in the direction of angle
]]
-- function Projectile:update(dt)
--     self.x = self.x + self.speed * math.cos(self.angular_position) * dt
--     self.y = self.y + self.speed * math.sin(self.angular_position) * dt
-- end

function Projectile:update(dt)
    self.x = self.x + self.speed * self.cos * dt
    self.y = self.y + self.speed * self.sin * dt
end

--[[
    sets the target to follow
]]
function Projectile:setDirection(x, y)
    local dx = x - self.x
    local dy = y - self.y
    local r = math.sqrt(dx^2 + dy^2)

    self.cos = dx / r
    self.sin = dy / r
end


function Projectile:getDamage()
    return self.damage
end

function Projectile:setDamage(dmg)
    self.damage = dmg
end