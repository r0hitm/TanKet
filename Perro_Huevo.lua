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