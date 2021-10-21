--[[
    TanKet
    - A Tower Defense Survival Game.
    - Player has to survive as long as possible from a hoard of attackers.

    --- Tower Class ---

    Author: Rohit Mehta

    Represents the tower the Player defends.
]]

Tower = Object:extend()

-- constructor
function Tower:new(x, y)
  -- position of the tower
  self.x = x or 0
  self.y = y or 0

  self.health = 100

  self.r = 1
  self.g = 1
  self.b = 1

  self.speed = 2
end

function Tower:setColor(r, g, b)
  self.r = r or 1
  self.g = g or 1
  self.b = b or 1
end

-- move the tower in different directions
function Tower:moveUp()
  self.y = self.y - self.speed
end

function Tower:moveDown()
  self.y = self.y + self.speed
end

function Tower:moveLeft()
  self.x = self.x - self.speed
end

function Tower:moveRight()
  self.x = self.x + self.speed
end

-- this will make the tower shoot the corresponding missiles
-- function Tower:shootUp()
  
-- end

-- function Tower:shootDown()
  
-- end

-- function Tower:shootLeft()
  
-- end

-- function Tower:shootRight()
  
-- end


-- draw the tank onto the screen
function Tower:render()
    love.graphics.setColor(self.r, self.g, self.b)
    love.graphics.rectangle('fill', self.x, self.y, 50, 50)
end