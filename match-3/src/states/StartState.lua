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
    -- currently selected menu item
    self.currentMenuItem = 1

    -- quad we'll use to scroll our background over time
    self.backgroundX = 0
    self.backgroundScrollSpeed = 80

    -- colors we'll use to change the title text
    self.colors = {
        [1] = {217, 87, 99, 255},
        [2] = {95, 205, 228, 255},
        [3] = {251, 242, 54, 255},
        [4] = {118, 66, 138, 255},
        [5] = {153, 229, 80, 255},
        [6] = {223, 113, 38, 255}
    }

    -- letters of MATCH 3 and their spacing relative to the center
    self.letterTable = {
        {'M', -108},
        {'A', -64},
        {'T', -28},
        {'C', 2},
        {'H', 40},
        {'3', 112}
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

    -- scroll background
    self.backgroundX = self.backgroundX - self.backgroundScrollSpeed * dt

    -- if we've scrolled the entire image, reset it to 0
    if self.backgroundX <= -1024 + VIRTUAL_WIDTH - 4 + 51 then
        self.backgroundX = 0
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
        gSounds['select']:play()
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
    love.graphics.setShader()
    love.graphics.draw(gTextures['background'], self.backgroundX, -5)

    -- render all tiles and their drop shadows
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

    self:drawMatch3Text(-60)
    self:drawOptions(12)
end

--[[
    Draw the centered MATCH-3 text with background rect, placed along the Y
    axis as needed, relative to the center.
]]
function StartState:drawMatch3Text(y)
    -- draw semi-transparent rect behind MATCH 3
    love.graphics.setColor(255, 255, 255, 128)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 + y - 11, 150, 58, 6)

    -- draw MATCH 3 text shadows
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('MATCH 3', 2, VIRTUAL_HEIGHT / 2 + y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('MATCH 3', 1, VIRTUAL_HEIGHT / 2 + y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('MATCH 3', 0, VIRTUAL_HEIGHT / 2 + y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('MATCH 3', 1, VIRTUAL_HEIGHT / 2 + y + 2, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('MATCH 3', 2, VIRTUAL_HEIGHT / 2 + y + 3, VIRTUAL_WIDTH, 'center')

    -- print MATCH 3 letters in their corresponding current colors
    for i = 1, 6 do
        love.graphics.setColor(self.colors[i])
        love.graphics.printf(self.letterTable[i][1], 0, VIRTUAL_HEIGHT / 2 + y,
            VIRTUAL_WIDTH + self.letterTable[i][2], 'center')
    end
end

--[[
    Draws "Start" and "High Scores" text over semi-transparent rectangles.
]]
function StartState:drawOptions(y)
    -- draw rect behind start and high scores text
    love.graphics.setColor(255, 255, 255, 128)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 + y, 150, 58, 6)

    -- draw Start text
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.printf('Start', 2, VIRTUAL_HEIGHT / 2 + y + 9, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Start', 1, VIRTUAL_HEIGHT / 2 + y + 9, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Start', 0, VIRTUAL_HEIGHT / 2 + y + 9, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Start', 1, VIRTUAL_HEIGHT / 2 + y + 10, VIRTUAL_WIDTH, 'center')
    
    if self.currentMenuItem == 1 then
        love.graphics.setColor(99, 155, 255, 255)
    else
        love.graphics.setColor(48, 96, 130, 255)
    end
    
    love.graphics.printf('Start', 0, VIRTUAL_HEIGHT / 2 + y + 8, VIRTUAL_WIDTH, 'center')

    -- draw High Scores text
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.printf('High Scores', 2, VIRTUAL_HEIGHT / 2 + y + 34, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('High Scores', 1, VIRTUAL_HEIGHT / 2 + y + 34, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('High Scores', 0, VIRTUAL_HEIGHT / 2 + y + 34, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('High Scores', 1, VIRTUAL_HEIGHT / 2 + y + 35, VIRTUAL_WIDTH, 'center')
    
    if self.currentMenuItem == 2 then
        love.graphics.setColor(99, 155, 255, 255)
    else
        love.graphics.setColor(48, 96, 130, 255)
    end
    
    love.graphics.printf('High Scores', 0, VIRTUAL_HEIGHT / 2 + y + 33, VIRTUAL_WIDTH, 'center')
end