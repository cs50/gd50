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
    ball.skin = math.random(7)
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
    ball.x = player.x + (player.width / 2) - 4
    ball.y = player.y - 8
end

function ServeState:render()
    player:render()
    ball:render()

    for k, brick in pairs(bricks) do
        brick:render()
    end

    local healthX = VIRTUAL_WIDTH - 100

    -- render health
    for i = 1, health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], healthX, 4)
        healthX = healthX + 11
    end

    -- render missing health
    for i = 1, 3 - health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], healthX, 4)
        healthX = healthX + 11
    end

    -- render score
    love.graphics.setFont(smallFont)
    love.graphics.print('Score:', VIRTUAL_WIDTH - 60, 5)
    love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, 'right')
end