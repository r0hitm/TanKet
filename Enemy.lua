--[[
    TanKet
    - A very minimal Tank Defense Survival Game.
    - Player has to survive as long as possible from a hoard of attackers.

    --- Enemy Class ---

    Author: Rohit Mehta

    Represents the generic Enemy in the game.
    Contains the menthods used by all enemies.
]]

Enemy = Body:extend()

function Enemy:new(x, y)
    Enemy.super.new(self, x, y)
    self.speed = 16   -- override default speed for Enemy
    self.scale = .2
    
    self.damage = 2   -- damage given to player on direct collision
end

function Enemy:getDamage()
    return self.damage
end

function Enemy:setDamage(d)
    self.damage = d or 0.1
end

--[[
    Float Number Number -> nil
    moves the enemy towards the given coordinates (x, y) by in dt

    Generic def. will be overriden by each enemy.
]]
function Enemy:move(dt)
end
