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

    -- currently selected menu item
    self.currentMenuItem = 1

    -- colors we'll use to change the title text
    self.colors = {
        [1] = {217, 87, 99, 255},
        [2] = {95, 205, 228, 255},
        [3] = {251, 242, 54, 255},
        [4] = {118, 66, 138, 255},
        [5] = {153, 229, 80, 255},
        [6] = {223, 113, 38, 255}
    }

    -- generate full table of tiles
    for i = 1, 64 do
        table.insert(positions, gFrames['tiles'][math.random(18)][math.random(6)])
    end

    self.colorTimer = 0
end

function StartState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- add delta to our timer
    self.colorTimer = self.colorTimer + dt

    -- time for a color change if it's been half a second
    if self.colorTimer > 0.075 then
        self.colorTimer = 0

        self.colors[0] = self.colors[6]

        for i = 6, 1, -1 do
            self.colors[i] = self.colors[i - 1]
        end
    end

    -- change menu selection
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        self.currentMenuItem = self.currentMenuItem == 1 and 2 or 1
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if self.currentMenuItem == 1 then 
            gStateMachine:change('begin-game')
        else
            gStateMachine:change('high-scores')
        end
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
    love.graphics.printf('MATCH 3', 2, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')

    -- print "MATCH 3" in different colors
    love.graphics.setColor(self.colors[1])
    love.graphics.printf('M', 0, VIRTUAL_HEIGHT / 2 - 33, VIRTUAL_WIDTH - 108, 'center')
    love.graphics.setColor(self.colors[2])
    love.graphics.printf('A', 0, VIRTUAL_HEIGHT / 2 - 33, VIRTUAL_WIDTH - 64, 'center')
    love.graphics.setColor(self.colors[3])
    love.graphics.printf('T', 0, VIRTUAL_HEIGHT / 2 - 33, VIRTUAL_WIDTH - 28, 'center')
    love.graphics.setColor(self.colors[4])
    love.graphics.printf('C', 0, VIRTUAL_HEIGHT / 2 - 33, VIRTUAL_WIDTH + 2, 'center')
    love.graphics.setColor(self.colors[5])
    love.graphics.printf('H', 0, VIRTUAL_HEIGHT / 2 - 33, VIRTUAL_WIDTH + 40, 'center')
    love.graphics.setColor(self.colors[6])
    love.graphics.printf('3', 0, VIRTUAL_HEIGHT / 2 - 33, VIRTUAL_WIDTH + 112, 'center')

    -- draw Start text
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Start', 2, VIRTUAL_HEIGHT / 2 + 45, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Start', 1, VIRTUAL_HEIGHT / 2 + 45, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Start', 0, VIRTUAL_HEIGHT / 2 + 45, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Start', 1, VIRTUAL_HEIGHT / 2 + 46, VIRTUAL_WIDTH, 'center')
    
    if self.currentMenuItem == 1 then
        love.graphics.setColor(99, 155, 255, 255)
    else
        love.graphics.setColor(48, 96, 130, 255)
    end
    
    love.graphics.printf('Start', 0, VIRTUAL_HEIGHT / 2 + 44, VIRTUAL_WIDTH, 'center')

    -- draw High Scores text
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('High Scores', 2, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('High Scores', 1, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('High Scores', 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('High Scores', 1, VIRTUAL_HEIGHT / 2 + 71, VIRTUAL_WIDTH, 'center')
    
    if self.currentMenuItem == 2 then
        love.graphics.setColor(99, 155, 255, 255)
    else
        love.graphics.setColor(48, 96, 130, 255)
    end
    
    love.graphics.printf('High Scores', 0, VIRTUAL_HEIGHT / 2 + 69, VIRTUAL_WIDTH, 'center')
end