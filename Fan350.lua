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

    self.sprite = love.graphics.newImage('assets/characters/Fan350.png')

    self.width = self.sprite:getWidth() * self.scale
    self.height = self.sprite:getHeight() * self.scale

    self.speed = 22
end

-- follows "downward diagonal"
function Fan350:move(dt)
    self.x = self.x + self.speed * dt
    self.y = self.y + self.speed * dt
end