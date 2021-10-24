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
    self.x = x
    self.y = y

    self.sprite = love.graphics.newImage('img/Enemy/Fan350.png')
    self.speed = 16
end