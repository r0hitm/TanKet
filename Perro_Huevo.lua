--[[
    TanKet
    - A very minimal Tank Defense Survival Game.
    - Player has to survive as long as possible from a hoard of attackers.

    --- Perro_Huevo inherited from Enemy Class ---

    Author: Rohit Mehta

    Represents the mole enemy in the game, named Perro Huevo
]]

require 'Enemy'

Perro_Huevo = Enemy:extend()

function Perro_Huevo:new(x, y)
    Perro_Huevo.super.new(self, x, y)
    self.sprite = love.graphics.newImage('img/Enemy/perro_huevo.png')
    
    self.width = self.sprite:getWidth() * self.scale
    self.height = self.sprite:getHeight() * self.scale
end


--[[
    Float Number Number -> nil
    moves the enemy towards the given coordinates (x, y) by in dt

    Perro Huevo directly follows the Player current position (short-test distance)
]]
-- function Perro_Huevo:moveTowards(dt, x, y)
--     -- move along x-axis
--     if x > self.x then      -- move towards right of current position
--         self.x = self.x + self.vx * dt
--     elseif x < self.x then  -- move towards the left of current position
--         self.x = self.x - self.vx * dt
--     end

--     -- move along y-axis
--     if y > self.y then      -- move down from the current position
--         self.y = self.y + self.vy * dt
--     elseif y < self.y then  -- move up from the current position
--         self.y = self.y - self.vy * dt
--     end
-- end