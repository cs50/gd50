--[[
    GD50 2018
    Match-3 Remake

    -- Board Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Board = Class{}

function Board:init(x, y)
    self.x = x
    self.y = y

    self.tiles = {}

    for tileY = 1, 8 do
        for tileX = 1, 8 do
            -- create a new tile at X,Y with a random color and variety
            table.insert(self.tiles, Tile(tileX, tileY, math.random(18), math.random(6)))
        end
    end
end

function Board:calculateMatches()

end

function Board:update(dt)

end

function Board:render()
    for k, tile in pairs(self.tiles) do
        tile:render(self.x, self.y)
    end
end