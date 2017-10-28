--[[
    GD50 2018
    Match-3 Remake

    -- BeginGameState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    State in which we can actually play, moving around a grid cursor that
    can swap two tiles; when two tiles make a legal swap (a swap that results
    in a valid match), perform the swap and destroy all matched tiles, adding
    their values to the player's point score. The player can continue playing
    until they exceed the number of points needed to get to the next level
    or until the time runs out, at which point they are brought back to the
    main menu or the score entry menu if they made the top 10.
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    -- start our transition alpha at full, so we fade in
    self.transitionAlpha = 255
end

function PlayState:enter(def)
    -- grab level # from the def we're passed
    self.level = def.level

    -- spawn a board and place it toward the right
    self.board = def.board or Board(VIRTUAL_WIDTH - 272, 16)
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    Timer.update(dt)
end

function PlayState:render()
    -- background color
    love.graphics.clear(89, 82, 82, 255)

    -- render board of tiles
    self.board:render()
end