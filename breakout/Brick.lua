--[[
    GD50 2018
    Breakout Remake

    -- Brick Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a brick in the world space that the ball can collide with;
    differently colored bricks have different point values. On collision,
    the ball will bounce away depending on the angle of collision. When all
    bricks are cleared in the current map, the player should be taken to a new
    layout of bricks.
]]

Brick = Class{}

function Brick:init(x, y)
    self.tier = 0
    self.color = 1
    self.x = x
    self.y = y
end

function Brick:update(dt)

end

function Brick:render()
    love.graphics.draw(gTextures['main'], gFrames['bricks'][1 * self.color + self.tier],
        self.x, self.y)
end