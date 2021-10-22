--[[
    TanKet
    - A very minimal Tank Defense Survival Game.
    - Player has to survive as long as possible from a hoard of attackers.

    --- Tank Class ---

    Author: Rohit Mehta

    Represents the Tank the Player controls.
]]

Tank = Object:extend()

-- constructor
function Tank:new(x, y)
  -- position of the Tank
  self.x = x or 0
  self.y = y or 0
  self.orientation = 0

  self.health = 100

  -- the drawable for the tank
  self.turret = love.graphics.newImage('img/turret.png')
  self.body = love.graphics.newImage('img/body.png')
end

-- turn the Tank in anti-clockwise direction
function Tank:turnAntiClock()
  self.orientation = self.orientation - math.pi / 180 -- by 1 degree
end

-- turn the Tank in clockwise direction
function Tank:turnClock()
  self.orientation = self.orientation + math.pi / 180 -- by 1 degree
end

-- draw the tank onto the screen
function Tank:render()
    -- love.graphics.setColor(self.r, self.g, self.b)
    -- love.graphics.rectangle('fill', self.x, self.y, 50, 50)

    love.graphics.draw(self.body, self.x, self.y, 0, 1, 1, 128 / 2, 128 / 2) -- offsetting x,y by 128/2
    -- draw the tank with rotaion, the image size is 127x127 so offsetting by 127/2 to make it rotate around center
    love.graphics.draw(self.turret, self.x, self.y, self.orientation, 1, 1, 127 / 2, 127 / 2)
end