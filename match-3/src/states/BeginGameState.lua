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

function BeginGameState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end 
end