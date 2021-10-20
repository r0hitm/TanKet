--[[
    TanKet
    - A Two Player Tank Battle Game.

    -- Tank Class --

    Author: Rohit Mehta

    Represents the Tank that can move in any direction on the screen and
    shoot missiles. The only playable entity of the game.
]]

Tank = Object:extend()

-- Dimensions of the Tank
local WIDTH = 50
local HEIGHT = 50

-- constructor
function Tank:new(x, y)
  self.x = x or 0
  self.y = y or 0
end

-- draw the tank onto the screen
function Tank:render()
    love.graphics.setColor(0,0,1)
    love.graphics.rectangle('fill', self.x, self.y, WIDTH, HEIGHT)
end