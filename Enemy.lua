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
    self.speed = 10   -- override default speed for Enemy
    self.scale = .2
end

--[[
    Float Number Number -> nil
    moves the enemy towards the given coordinates (x, y) by in dt

    Generic def.
]]
-- function Enemy:moveTowards(dt, x, y)
-- end

function Enemy:moveTowards(dt, x, y)
    -- move along x-axis
    if x > self.x then      -- move towards right of current position
        self.x = self.x + self.speed * dt
    elseif x < self.x then  -- move towards the left of current position
        self.x = self.x - self.speed * dt
    end

    -- move along y-axis
    if y > self.y then      -- move down from the current position
        self.y = self.y + self.speed * dt
    elseif y < self.y then  -- move up from the current position
        self.y = self.y - self.speed * dt
    end
end