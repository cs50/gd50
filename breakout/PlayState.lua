--[[
    GD50 2018
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    ball.dx = math.random(-200, 200)
    -- give a random y velocity, but add an amount (capped) based on the level
    ball.dy = math.random(-50, -60) - math.min(100, level * 5)
end

function PlayState:update(dt)
    -- player input
    playerMove(dt)

    -- update positions based on velocity
    player:update(dt)
    ball:update(dt)

    -- bounce the ball back up if we collide with the paddle
    if ball:collides(player) then
        -- raise ball above paddle in case it goes below it, then reverse dy
        ball.y = player.y - 8
        ball.dy = -ball.dy

        --
        -- tweak angle of bounce based on where it hits the paddle
        --

        -- if we hit the paddle on its left side...
        if ball.x < player.x + (player.width / 2) and player.dx < 0 then
            -- if the player is moving left...
            if player.dx < 0 then
                ball.dx = -math.random(30, 50 + 
                    10 * player.width / 2 - (ball.x + 8 - player.x))
            end
        else
            -- if the player is moving right...
            if player.dx > 0 then
                ball.dx = math.random(30, 50 + 
                    10 * (ball.x - player.x - player.width / 2))
            end
        end
        gSounds['paddle-hit']:play()
    end

    -- eliminate brick if we collide with it
    for k, brick in pairs(bricks) do
        if brick.inPlay and ball:collides(brick) then
            score = score + (brick.tier + brick.color) * 25
            brick:hit()

            -- if we have enough points, recover a point of health
            if score > recoverPoints then
                -- can't go above 3 health
                health = math.min(3, health + 1)

                -- multiply recover points by 2, but no more than 100000
                recoverPoints = math.min(100000, recoverPoints * 2)

                -- play recover sound effect
                gSounds['recover']:play()
            end

            if self:checkVictory() then
                gStateMachine:change('victory')
            end

            -- change ball's trajectory based on how we hit the brick
            if ball.x < brick.x or ball.x + 7 >= brick.x + brick.width then
                -- we hit from the left, so reverse dx
                ball.dx = -ball.dx
            end

            if ball.y < brick.y or ball.y + 7 > brick.y + brick.height then
                ball.dy = -ball.dy
            end

            -- slightly scale the y velocity to speed up the game
            ball.dy = ball.dy * 1.02
        end
    end

    -- if ball goes below bounds, revert to serve state and decrease health
    if ball.y >= VIRTUAL_HEIGHT then
        health = health - 1
        gSounds['hurt']:play()

        if health == 0 then
            gStateMachine:change('game-over')
        else
            gStateMachine:change('serve', player.skin)
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    player:render()
    ball:render()

    renderBricks()
    renderScore()
    renderHealth()

    -- current level text
    love.graphics.setFont(smallFont)
    love.graphics.printf('Level ' .. tostring(level),
        0, 4, VIRTUAL_WIDTH, 'center')
end

function PlayState:checkVictory()
    for k, brick in pairs(bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end