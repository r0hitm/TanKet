--[[
    TanKet
    - A very minimal Tank Defense Survival Game.
    - Player has to survive as long as possible from a hoard of attackers.

    --- Tank Class ---

    Author: Rohit Mehta

    Represents the Tank the Player controls.
]]

Tank = Body:extend()


-- constructor
function Tank:new(x, y)
  Tank.super.new(self, x, y)
  -- self.angular_position is Tank's body orientation
  self.turretAngle = 0    -- relative to angular_position

  self.health = 1000
  self.damageInflicted = false

  -- the drawable for the tank
  self.turret = love.graphics.newImage('assets/tank/turret.png')
  self.body = love.graphics.newImage('assets/tank/body.png')
  
  self.scale = .8 -- scaling factor for Tank sprites

  self.width = self.body:getWidth() * self.scale
  self.height = self.body:getHeight() * self.scale
end

function Tank:getHealth()
  return self.health
end

--[[
  Fraction[0...1] -> Nothing
  Decreases the health of tank by given number (default by 1)
]]
function Tank:inflictDamage(dmg)
  self.health = self.health - (dmg or 0.1)
  if self.health < 0 then self.health = 0 end
  self.damageInflicted = true
end

--[[
  Returns the position of turret mouth, and it's turretAngle
]]
function Tank:getTurretMouth()
  local turret_length = 48 * self.scale
  return self.x + turret_length * math.cos(self.turretAngle + self.angular_position),
         self.y + turret_length * math.sin(self.turretAngle + self.angular_position),
         self.angular_position + self.turretAngle
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
  self.x = self.x + self.speed * math.cos(self.angular_position)
  self.y = self.y + self.speed * math.sin(self.angular_position)
end

function Tank:moveBackward(dt)
  self.x = self.x - self.speed * math.cos(self.angular_position)
  self.y = self.y - self.speed * math.sin(self.angular_position)
end

function Tank:turnLeft(dt)
  self.angular_position = self.angular_position - self.body:getWidth() * math.pi * dt / 360 -- taking image-width /2 as the turning radius
end

function Tank:turnRight(dt)
  self.angular_position = self.angular_position + self.body:getWidth() * math.pi * dt / 360
end

-- draw the tank onto the screen
function Tank:render()
  local turret_width, turret_height = self.turret:getDimensions()
  local body_width, body_height = self.body:getDimensions()

  if self.damageInflicted then
    love.graphics.setColor(1,0,0,0.8)
    self.damageInflicted = false
  end
  
  love.graphics.draw(self.body, self.x, self.y, self.angular_position, self.scale, self.scale, body_width / 2, body_height / 2)
  love.graphics.draw(self.turret, self.x, self.y, self.angular_position + self.turretAngle, self.scale, self.scale, turret_width / 2, turret_height / 2)
  love.graphics.setColor(1,1,1)
  
end