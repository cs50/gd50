--[[
    GD50 2018
    Breakout Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state the game is in when we've just started; should
    simply display "Breakout" in large text, as well as a message to press
    Enter to begin.
]]

-- the "__includes" bit here means we're going to inherit all of the methods
-- that BaseState has, so it will have empty versions of all StateMachine methods
-- even if we don't override them ourselves; handy to avoid superfluous code!
StartState = Class{__includes = BaseState}

function StartState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()
        gStateMachine:change('paddle-select')
    end
end

function StartState:render()
    -- title
    love.graphics.setFont(largeFont)
    love.graphics.printf("BREAKOUT", 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')
    
    -- instructions
    love.graphics.setFont(mediumFont)
    love.graphics.printf("Press Enter to start!", 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end