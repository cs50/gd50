--[[
    GD50 2018
    Breakout Remake

    -- ServeState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The state in which we are waiting to serve the ball; here, we are
    basically just moving the paddle left and right with the ball until we
    press Enter, though everything in the actual game now should render in
    preparation for the serve, including our current health and score, as
    well as the level we're on.
]]

ServeState = Class{__includes = BaseState}

function ServeState:init()
    player.x = VIRTUAL_WIDTH / 2 - 32
    player.y = VIRTUAL_HEIGHT - 24
end

function ServeState:enter(skin)
    player.skin = skin
end

function ServeState:update(dt)
    if love.keyboard.isDown('left') then
        player.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        player.dx = PADDLE_SPEED
    else
        player.dx = 0
    end 

    player:update(dt)
end

function ServeState:render()
    player:render()
end