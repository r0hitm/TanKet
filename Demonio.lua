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

function Demonio:new(x, y, dir_bool)
    Demonio.super.new(self, x, y)
    self.sprite = love.graphics.newImage('assets/characters/demonio.png')
    
    self.width = self.sprite:getWidth() * self.scale
    self.height = self.sprite:getHeight() * self.scale

    self.dir_bool = dir_bool    -- true means go up else go down
end

-- follows "go straight and change direction mid-screen"
function Demonio:move(dt)
    if self.y > 300 and self.y < 400 then    -- change direction
        if self.dir_bool then
            self.x = self.x + self.speed * dt
        else
            self.x = self.x - self.speed * dt
        end
    else
        if self.dir_bool then
            self.y = self.y - self.speed * dt
        else
            self.y = self.y + self.speed * dt
        end
    end
end