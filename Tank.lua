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
  self.turretAngle = 0    -- relative to bodyAngle
  self.bodyAngle = 0

  self.health = 100
  self.speed = 3

  -- the drawable for the tank
  self.turret = love.graphics.newImage('img/Tank/turret.png')
  self.body = love.graphics.newImage('img/Tank/body.png')
end

--[[
  get Tank's body center's coordinates
]]
function Tank:getPos()
  return self.x + self.body:getWidth() / 2, self.y + self.body:getWidth() / 2
end

--[[
  Returns the position of turret mouth, and it's turretAngle
]]
function Tank:getTurretMouth()
  local turret_length = 48 * .8
  return self.x + turret_length * math.cos(self.turretAngle + self.bodyAngle),
         self.y + turret_length * math.sin(self.turretAngle + self.bodyAngle),
         self.bodyAngle + self.turretAngle
end

-- turn the Tank in anti-clockwise direction
function Tank:turnAntiClock(dt)
  self.turretAngle = self.turretAngle - 90 * math.pi * dt / 180
end

-- turn the Tank in clockwise direction
function Tank:turnClock(dt)
  self.turretAngle = self.turretAngle + 90 * math.pi * dt / 180
end

--[[
  Tank movement controllers
]]
function Tank:moveForward(dt)
  self.x = self.x + self.speed * math.cos(self.bodyAngle)
  self.y = self.y + self.speed * math.sin(self.bodyAngle)
end

function Tank:moveBackward(dt)
  self.x = self.x - self.speed * math.cos(self.bodyAngle)
  self.y = self.y - self.speed * math.sin(self.bodyAngle)
end

function Tank:turnLeft(dt)
  self.bodyAngle = self.bodyAngle - self.body:getWidth() * math.pi * dt / 360 -- taking image-width /2 as the turning radius
end

function Tank:turnRight(dt)
  self.bodyAngle = self.bodyAngle + self.body:getWidth() * math.pi * dt / 360
end

-- draw the tank onto the screen
function Tank:render()
  local turret_width, turret_height = self.turret:getDimensions()
  local body_width, body_height = self.body:getDimensions()

  love.graphics.draw(self.body, self.x, self.y, self.bodyAngle, .8, .8, body_width / 2, body_height / 2)
  love.graphics.draw(self.turret, self.x, self.y, self.bodyAngle + self.turretAngle, .8, .8, turret_width / 2, turret_height / 2)
end