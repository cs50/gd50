--[[
    GD50 2018
    Match-3 Remake

    -- BeginGameState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state the game is in right before we start playing;
    should fade in, display a drop-down "Level X" message, then transition
    to the PlayState, where we can finally use player input.
]]

BeginGameState = Class{__includes = BaseState}

function BeginGameState:init()
    -- start our transition alpha at full, so we fade in
    self.transitionAlpha = 255

    -- spawn a board and place it toward the right
    self.board = Board(VIRTUAL_WIDTH - 272, 16)

    -- start our level # label off-screen
    self.levelLabelY = -64
end

function BeginGameState:enter(def)
    -- grab level # from the def we're passed
    self.level = def.level

    --
    -- animate our white screen fade-in, then animate a drop-down with
    -- the level text
    --

    -- first, after one second, transition our alpha to 0
    Timer.tween(1, {
        [self] = {transitionAlpha = 0}
    })
    -- once that's finished, start a transition of our text label to
    -- the center of the screen over 0.25 seconds
    :finish(function()
        Timer.tween(0.25, {
            [self] = {levelLabelY = VIRTUAL_HEIGHT / 2 - 8}
        })
        -- after that, pause for one second with Timer.after
        :finish(function()
            Timer.after(1, function()
                -- then, animate the label going down past the bottom edge
                Timer.tween(0.25, {
                    [self] = {levelLabelY = VIRTUAL_HEIGHT + 30}
                })
                -- once that's complete, we're ready to play!
                :finish(function()
                    gStateMachine:change('play', {
                        level = self.level,
                        board = self.board
                    })
                end)
            end)
        end)
    end)
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

    -- render Level # label and background rect
    love.graphics.setColor(95, 205, 228, 200)
    love.graphics.rectangle('fill', 0, self.levelLabelY - 8, VIRTUAL_WIDTH, 48)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level),
        0, self.levelLabelY, VIRTUAL_WIDTH, 'center')

    -- our transition foreground rectangle
    love.graphics.setColor(255, 255, 255, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end