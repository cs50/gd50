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

PlayState = Class{__includes = BaseState}

function PlayState:init()
    ball.dx = math.random(-200, 200)
    ball.dy = math.random(-50, -80)
end

function PlayState:update(dt)
    -- player input
    playerMove(dt)

    -- update positions based on velocity
    player:update(dt)
    ball:update(dt)

    -- bounce the ball back up if we collide with the paddle
    if ball:collides(player) then
        -- tweak angle of bounce based on where it hits the paddle
        ball.y = player.y - 8
        ball.dy = -ball.dy

        if ball.x < player.x + (player.width / 2) then
            if player.dx < 0 then
                ball.dx = -math.random(30, 50 + 10 * player.width / 2 - (ball.x + 8 - player.x))
            end
        else
            if player.dx > 0 then
                ball.dx = math.random(30, 50 + 10 * (ball.x - player.x - player.width / 2))
            end
        end
        gSounds['paddle-hit']:play()
    end

    -- eliminate brick if we collide with it
    for k, brick in pairs(bricks) do
        if brick.inPlay and ball:collides(brick) then
            brick.inPlay = false
            gSounds['brick-hit-1']:play()
            gSounds['brick-hit-2']:play()
            score = score + brick.tier * 10 + brick.color * 5

            -- change ball's trajectory based on how we hit the brick
            if ball.x < brick.x or ball.x + 8 > brick.x + brick.width then
                -- we hit from the left, so reverse dx
                ball.dx = -ball.dx
            end

            if ball.y < brick.y or ball.y + 8 > brick.y + brick.height then
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
end

function PlayState:render()
    player:render()
    ball:render()

    renderBricks()
    renderScore()
    renderHealth()
end