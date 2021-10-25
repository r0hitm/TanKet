--[[
    TanKet
    - A very minimal Tank Defense Survival Game.
    - Player has to survive as long as possible from a hoard of attackers.

    --- Demonio inherited from Enemy Class ---

    Author: Rohit Mehta

    Represents the demon in the game, named Perro Huevo
]]

require 'Enemy'

Demonio = Enemy:extend()

function Demonio:new(x, y)
    Demonio.super.new(self, x, y)
    self.sprite = love.graphics.newImage('assets/characters/demonio.png')
    
    self.width = self.sprite:getWidth() * self.scale
    self.height = self.sprite:getHeight() * self.scale
end