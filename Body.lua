--[[
    TanKet
    - A very minimal Tank Defense Survival Game.
    - Player has to survive as long as possible from a hoard of attackers.

    --- Body Class (extends classic)---

    Author: Rohit Mehta

    Defines all the properites & methods common to all game objects,
    i.e. Tank and enemies.
    Hitboxes, positions, speeds etc. are defined
]]

Body = Object:extend()

local SPEED = 3

--[[
    initialize the Body with it's position (default position: (0,0))
]]
function Body:new(x, y)
    --[[
        Remember these coordinates are the top-left points of the Body
        NOT the center
    ]]
    self.x = x or 0
    self.y = y or 0

    self.scale = 1      -- default, don't scale

    self.angular_position = 0
    self.speed = SPEED
end

--[[
    get the current position of the Body
]]
function Body:getPos()
    return self.x, self.y
end

function Body:getAngularPos()
    return self.angular_position
end

--[[
    exists return its dimentions
]]
function Body:getDimensions()
    if self.width then
        return self.width, self.height
    end
end

--[[
    Fraction -> Nothing
    renders the sprite and scales it down by scale factor (if exists)
]]
function Body:render()
    if self.sprite then
        love.graphics.draw(self.sprite, self.x, self.y, self.angular_position, self.scale, self.scale,
                            self.sprite:getWidth() / 2, self.sprite:getHeight() / 2) -- and offset to center of the sprite
    end
end