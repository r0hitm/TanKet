--[[
    TanKet
    - A very minimal Tank Defense Survival Game.
    - Player has to survive as long as possible from a hoard of attackers.

    --- Enemy Class ---

    Author: Rohit Mehta

    Represents the generic Enemy in the game.
]]

Enemy = Object:extend()

local WIDTH = 20
local HEIGHT = 20

local SPEED = 1

-- Enemy:new()
-- Integer Integer Move -> Enemy
-- creates an enemy at x,y
function Enemy:new(x, y)
  self.x = x or 0
  self.y = y or 0
end

function Enemy:getPos()
    return self.x, self.y
end

--[[
    Float Number Number -> nil
    moves the enemy towards the given coordinates (x, y) by in dt
]]
function Enemy:approach(dt, x, y)
    -- move along x-axis
    if x > self.x then      -- move towards right of current position
        self.x = self.x + SPEED * dt
    elseif x < self.x then  -- move towards the left of current position
        self.x = self.x - SPEED * dt
    end

    -- move along y-axis
    if y > self.y then      -- move down from the current position
        self.y = self.y + SPEED * dt
    elseif y < self.y then  -- move up from the current position
        self.y = self.y - SPEED * dt
    end
end

--[[
    Number Number -> Boolean
    Produce true if the current positon is same as the given x,y
]]
function Enemy:atCoord(x, y)
    if self.x == x and self.y == y then
        return true
    else
        return false
    end
end

-- draw the enemy onto the screen
function Enemy:render()
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle('fill', self.x, self.y, WIDTH, HEIGHT)
end

