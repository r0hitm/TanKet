--[[
    TanKet
    - A very minimal Tank Defense Survival Game.
    - Player has to survive as long as possible from a hoard of attackers.

    --- Gantasmito inherited from Enemy Class ---

    Author: Rohit Mehta

    Represents the ghost enemy in the game, named Gantasmito
]]

require 'Enemy'

Gantasmito = Enemy:extend()

function Gantasmito:new(x, y)
    Gantasmito.super.new(self, x, y)

    self.sprite = love.graphics.newImage('img/Enemy/Gantasmito.png')

    self.width = self.sprite:getWidth() * self.scale
    self.height = self.sprite:getHeight() * self.scale

    self.speed = 14
end