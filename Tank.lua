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
  self.turretAngle = 0
  self.bodyAngle = 0

  self.health = 100

  -- the drawable for the tank
  self.turret = love.graphics.newImage('img/turret.png')
  self.body = love.graphics.newImage('img/body.png')
end

--[[
  Returns the position of turret mouth, and it's turretAngle
]]
function Tank:getTurretPos()
  local turret_length = 48
  return self.x + turret_length * math.cos(self.turretAngle),
         self.y + turret_length * math.sin(self.turretAngle),
         self.turretAngle
end

-- turn the Tank in anti-clockwise direction
function Tank:turnAntiClock()
  self.turretAngle = self.turretAngle - math.pi / 180 -- by 1 degree
end

-- turn the Tank in clockwise direction
function Tank:turnClock()
  self.turretAngle = self.turretAngle + math.pi / 180 -- by 1 degree
end

-- draw the tank onto the screen
function Tank:render()
  local turret_width, turret_height = self.turret:getDimensions()
  local body_width, body_height = self.body:getDimensions()

  love.graphics.draw(self.body, self.x, self.y, 0, 1, 1, body_width / 2, body_height / 2)
  love.graphics.draw(self.turret, self.x, self.y, self.turretAngle, 1, 1, turret_width / 2, turret_height / 2)
end