--[[
    TanKet
    - A very minimal Tank Defense Survival Game.
    - Player has to survive as long as possible from a hoard of attackers.

    --- Fan350 inherited from Enemy Class ---

    Author: Rohit Mehta

    Represents the ghost enemy in the game, named Fan350
]]

require 'Enemy'

Fan350 = Enemy:extend()

function Fan350:new(x, y)
    Fan350.super.new(self, x, y)
    
    self.sprite = love.graphics.newImage('img/Enemy/Fan350.png')
    
    self.width = self.sprite:getWidth() * self.scale
    self.height = self.sprite:getHeight() * self.scale

    self.speed = 16
end

--[[
    Float Number Number -> nil
    moves the enemy towards the given coordinates (x, y) by in dt

    Fan350 follows the player in spiral fashion
]]
-- function Fan350:moveTowards(dt, x, y)
    
-- end