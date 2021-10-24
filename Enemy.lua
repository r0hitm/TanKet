--[[
    TanKet
    - A very minimal Tank Defense Survival Game.
    - Player has to survive as long as possible from a hoard of attackers.

    --- Enemy Class ---

    Author: Rohit Mehta

    Represents the generic Enemy in the game.
    Contains the menthods used by all enemies.
]]

Enemy = Object:extend()

--[[
    Float Number Number -> nil
    moves the enemy towards the given coordinates (x, y) by in dt
]]
function Enemy:approach(dt, x, y)
    -- move along x-axis
    if x > self.x then      -- move towards right of current position
        self.x = self.x + self.speed * dt
    elseif x < self.x then  -- move towards the left of current position
        self.x = self.x - self.speed * dt
    end

    -- move along y-axis
    if y > self.y then      -- move down from the current position
        self.y = self.y + self.speed * dt
    elseif y < self.y then  -- move up from the current position
        self.y = self.y - self.speed * dt
    end
end

--[[
    Number Number -> Boolean
    Produce true if the current positon is same as the given x,y
]]
function Enemy:getPos()
    return self.x, self.y
end

--[[
    render the enemy on the screen
]]
function Enemy:render()
    -- make sure the enemy sprite exists
    if self.sprite then
        love.graphics.setColor(1,1,1)
        love.graphics.draw(self.sprite, self.x, self.y, 0, .2, .2)
    end
end