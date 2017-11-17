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
    self.matches = {}

    for tileY = 1, 8 do
        for tileX = 1, 8 do
            -- create a new tile at X,Y with a random color and variety
            table.insert(self.tiles, Tile(tileX, tileY, math.random(18), math.random(6)))
        end
    end
end

--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the 
    last two haven't been a match.
]]
function Board:calculateMatches()
    local matches = {}

    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    -- horizontal matches first
    for y = 1, 8 do
        local colorToMatch = self.tiles[(y - 1) * 8 + 1].color

        -- account for the last row ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for x = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[(y - 2) * 8 + x])
            end

            table.insert(matches, match)
        end

        matchNum = 1
        
        -- every horizontal tile
        for x = 2, 8 do
            -- if this is the same color as the one we're trying to match...
            if self.tiles[(y - 1) * 8 + x].color == colorToMatch then
                matchNum = matchNum + 1
                print(matchNum)
            else
                -- set this as the new color we want to watch for
                colorToMatch = self.tiles[(y - 1) * 8 + x].color

                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    local match = {}

                    -- go backwards from here by matchNum
                    for x2 = x - 1, x - matchNum, -1 do
                        -- add each tile to the match that's in that match
                        table.insert(match, self.tiles[(y - 1) * 8 + x2])
                    end

                    -- add this match to our total matches table
                    table.insert(matches, match)
                end

                matchNum = 1
            end
        end
    end

    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[x].color

        -- account for the last column ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for y = 8, 8 - matchNum, -1 do
                table.insert(match, self.tiles[(y - 1) * 8 + x - 1])
            end

            table.insert(matches, match)
        end

        matchNum = 1

        -- every vertical tile
        for y = 2, 8 do
            if self.tiles[(y - 1) * 8 + x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[(y - 1) * 8 + x].color

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[(y2 - 1) * 8 + x])
                    end

                    table.insert(matches, match)
                end

                matchNum = 1
            end
        end
    end

    self.matches = matches

    -- return true so we can determine whether we need to call more code
    return #self.matches > 0
end

--[[
    Remove the matches from the Board.
]]
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[(tile.gridY - 1) * 8 + tile.gridX] = nil
            -- table.remove(self.tiles, (tile.gridY - 1) * 8 + tile.gridX)
        end
    end

    self.matches = nil
end

function Board:outputNilTiles()
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[(y - 1) * 8 + x]
            if tile == nil then
                print('nil tile!')
            end
        end
    end
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    for x = 1, 10 do
        print(x)
        x = x + 2
    end

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do
            -- if our last tile was a space...
            local tile = self.tiles[(y - 1) * 8 + x]
            
            if space then
                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then
                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[(spaceY - 1) * 8 + x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[(y - 1) * 8 + x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- set space back to 0, set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    return tweens
end

function Board:getNewTiles()
    return {}
end

function Board:update(dt)

end

function Board:render()
    for k, tile in pairs(self.tiles) do
        tile:render(self.x, self.y)
    end
end