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
    -- used for coloring and score calculation
    self.tier = 0
    self.color = 1
    
    self.x = x
    self.y = y
    self.width = 32
    self.height = 16
    
    -- used to determine whether this brick should be rendered
    self.inPlay = true
end

function Brick:update(dt)

end

function Brick:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'], gFrames['bricks'][1 * self.color + self.tier],
            self.x, self.y)
    end
end