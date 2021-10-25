--[[
    TanKet
    - A very minimal Tank Defense Survival Game.
    - Player has to survive as long as possible from a hoard of attackers.

    --- OCA inherited from Enemy Class ---

    Author: Rohit Mehta

    Represents the Ocuro Con Aplo enemy in the game
]]

require 'Enemy'

Oscuro = Enemy:extend()

function Oscuro:new(x, y)
    Oscuro.super.new(self, x, y)

    self.sprite = love.graphics.newImage('assets/characters/oscuro_con_aplo.png')

    self.width = self.sprite:getWidth() * self.scale
    self.height = self.sprite:getHeight() * self.scale

    self.speed = 18
end