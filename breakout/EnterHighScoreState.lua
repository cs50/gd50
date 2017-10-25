--[[
    GD50 2018
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the screen where we can view all high scores previously recorded.
]]

EnterHighScoreState = Class{__includes = BaseState}

-- individual chars of our string
local chars = {
    [1] = 65,
    [2] = 65,
    [3] = 65
}

-- char we're currently changing
local highlightedChar = 1

function EnterHighScoreState:init()

end

function EnterHighScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- update scores table
        local name = string.char(chars[1]) .. string.char(chars[2]) .. string.char(chars[3])

        -- go backwards through high scores table till this score, shifting scores
        for i = 10, highScoreIndex, -1 do
            highScores[i + 1] = {
                name = highScores[i].name,
                score = highScores[i].score
            }
        end

        highScores[highScoreIndex].name = name
        highScores[highScoreIndex].score = score

        -- write scores to file
        local scoresStr = ''

        for i = 1, 10 do
            scoresStr = scoresStr .. highScores[i].name .. '\n'
            scoresStr = scoresStr .. tostring(highScores[i].score) .. '\n'
        end

        love.filesystem.write('breakout.lst', scoresStr)

        gStateMachine:change('high-scores')
    end

    -- scroll through character slots
    if love.keyboard.wasPressed('left') and highlightedChar > 1 then
        highlightedChar = highlightedChar - 1
        gSounds['select']:play()
    elseif love.keyboard.wasPressed('right') and highlightedChar < 3 then
        highlightedChar = highlightedChar + 1
        gSounds['select']:play()
    end

    -- scroll through characters
    if love.keyboard.wasPressed('up') then
        chars[highlightedChar] = chars[highlightedChar] + 1
        if chars[highlightedChar] > 90 then
            chars[highlightedChar] = 65
        end
    elseif love.keyboard.wasPressed('down') then
        chars[highlightedChar] = chars[highlightedChar] - 1
        if chars[highlightedChar] < 65 then
            chars[highlightedChar] = 90
        end
    end
end

function EnterHighScoreState:render()
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Your score: ' .. tostring(score), 0, 30,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(largeFont)
    
    --
    -- render all three characters of the name
    --
    if highlightedChar == 1 then
        love.graphics.setColor(103, 255, 255, 255)
    end
    love.graphics.print(string.char(chars[1]), VIRTUAL_WIDTH / 2 - 28, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(255, 255, 255, 255)

    if highlightedChar == 2 then
        love.graphics.setColor(103, 255, 255, 255)
    end
    love.graphics.print(string.char(chars[2]), VIRTUAL_WIDTH / 2 - 6, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(255, 255, 255, 255)

    if highlightedChar == 3 then
        love.graphics.setColor(103, 255, 255, 255)
    end
    love.graphics.print(string.char(chars[3]), VIRTUAL_WIDTH / 2 + 20, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(255, 255, 255, 255)
    
    love.graphics.setFont(smallFont)
    love.graphics.printf('Press Enter to confirm!', 0, VIRTUAL_HEIGHT - 18,
        VIRTUAL_WIDTH, 'center')
end