--[[
    GD50 2018
    Match-3 Remake

    -- BeginGameState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state the game is in when we've just started; should
    simply display "Match-3" in large text, as well as a message to press
    Enter to begin.
]]

BeginGameState = Class{__includes = BaseState}

function BeginGameState:init()
    self.transitionAlpha = 255
    self.board = Board(VIRTUAL_WIDTH - 272, 16)
end

function BeginGameState:enter()
    -- animate our transition into this state
    Timer.tween(1, {
        [self] = {transitionAlpha = 1}
    })
end

function BeginGameState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    Timer.update(dt)
end

function BeginGameState:render()
    -- render board of tiles
    self.board:render()

    -- our transition foreground rectangle
    love.graphics.setColor(255, 255, 255, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end