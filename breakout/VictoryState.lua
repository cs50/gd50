--[[
    GD50 2018
    Breakout Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state that the game is in when we've just completed a level.
    Very similar to the ServeState, except here we increment the level 
]]

VictoryState = Class{__includes = BaseState}

function VictoryState:enter()
    -- play victory sound effect when state starts up
    gSounds['victory']:play()
end

function VictoryState:update(dt)
    playerMove()
    player:update(dt)

    -- have the ball track the player
    ball.x = player.x + (player.width / 2) - 4
    ball.y = player.y - 8

    -- go to play screen if the player presses Enter
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        level = level + 1
        bricks = LevelMaker:createMap(level)
        gStateMachine:change('play')
    end
end

function VictoryState:render()
    player:render()
    ball:render()

    renderHealth()
    renderScore()

    -- level complete text
    love.graphics.setFont(largeFont)
    love.graphics.printf("Level " .. tostring(level) .. " complete!",
        0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    -- instructions text
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter to serve!', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end