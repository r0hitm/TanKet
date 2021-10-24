--[[
    TanKet
    - A very minimal Tank Defense Survival Game.
    - Player has to survive as long as possible from a hoard of attackers.

    --- Pez inherited from Enemy Class ---

    Author: Rohit Mehta

    Represents the fish enemy in the game, named Pez
]]

require 'Enemy'

Pez = Enemy:extend()

function Pez:new(x, y)
    Pez.super.new(self, x, y)

    self.sprite = love.graphics.newImage('img/Enemy/pez.png')

    self.width = self.sprite:getWidth() * self.scale
    self.height = self.sprite:getHeight() * self.scale

    self.speed = 12
end

--[[
    Float Number Number -> nil
    moves the enemy towards the given coordinates (x, y) by in dt

    Pez follows player in sinosudial fashion
]]
-- function Pez:moveTowards(dt, x, y)
    
-- end