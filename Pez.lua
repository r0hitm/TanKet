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
    self.x = x
    self.y = y

    self.sprite = love.graphics.newImage('img/Enemy/pez.png')
    self.speed = 8
end