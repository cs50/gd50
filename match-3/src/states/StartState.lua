--[[
    GD50 2018
    Match-3 Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state the game is in when we've just started; should
    simply display "Match-3" in large text, as well as a message to press
    Enter to begin.
]]

local positions = {}

StartState = Class{__includes = BaseState}

function StartState:init()
    -- glow shader
    self.glowEffect = moonshine(moonshine.effects.glow)
    self.glowEffect.min_luma = 0.1
    self.glowEffect.strength = 0.12

    -- gradient image we'll be using as our background
    self.backgroundGradient = Gradient {
        direction = 'vertical',
        {89, 86, 82},
        {155, 173, 183}
    }

    -- gradient image we'll be using for our GUI box
    self.windowGradient = Gradient {
        direction = 'horizontal',
        {69, 40, 60},
        {89, 86, 82}
    }

    -- generate full table of tiles
    for i = 1, 64 do
        table.insert(positions, gFrames['tiles'][math.random(18)][math.random(6)])
    end
end

function StartState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render()
    -- render gradient background
    DrawInRect(self.backgroundGradient, 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    -- render all tiles and their drop shadows
    self.glowEffect(function()
        for y = 1, 8 do
            for x = 1, 8 do
                -- render shadow first
                love.graphics.setColor(0, 0, 0, 255)
                love.graphics.draw(gTextures['main'], positions[(y - 1) * x + x], 
                    (x - 1) * 32 + 128 + 3, (y - 1) * 32 + 16 + 3)
    
                -- render tile
                love.graphics.setColor(255, 255, 255, 255)
                love.graphics.draw(gTextures['main'], positions[(y - 1) * x + x], 
                    (x - 1) * 32 + 128, (y - 1) * 32 + 16)
            end
        end
    end)

    -- draw MATCH 3 text
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('MATCH 3', 2, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('MATCH 3', 1, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('MATCH 3', 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('MATCH 3', 1, VIRTUAL_HEIGHT / 2 - 31, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(48, 96, 130, 255)
    love.graphics.printf('MATCH 3', 0, VIRTUAL_HEIGHT / 2 - 33, VIRTUAL_WIDTH, 'center')

    -- draw Start text
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Start', 2, VIRTUAL_HEIGHT / 2 + 45, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Start', 1, VIRTUAL_HEIGHT / 2 + 45, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Start', 0, VIRTUAL_HEIGHT / 2 + 45, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Start', 1, VIRTUAL_HEIGHT / 2 + 46, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(48, 96, 130, 255)
    love.graphics.printf('Start', 0, VIRTUAL_HEIGHT / 2 + 44, VIRTUAL_WIDTH, 'center')

    -- draw High Scores text
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('High Scores', 2, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('High Scores', 1, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('High Scores', 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('High Scores', 1, VIRTUAL_HEIGHT / 2 + 71, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(48, 96, 130, 255)
    love.graphics.printf('High Scores', 0, VIRTUAL_HEIGHT / 2 + 69, VIRTUAL_WIDTH, 'center')
end