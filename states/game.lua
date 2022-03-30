local game = {}

local notes = {}
local notes2 = {}
local notes3 = {}
local notes4 = {}

local alpha = {}

alpha.alpha = 0

function game:init()
    camera = Camera(GameVars.inputPlace.x, GameVars.inputPlace.y)
end

function game:enter()
    GameVars.inputPlace.y = love.graphics.getHeight() - 50
    GameVars.inputPlace2.y = love.graphics.getHeight() - 50
    GameVars.inputPlace3.y = love.graphics.getHeight() - 50
    GameVars.inputPlace4.y = love.graphics.getHeight() - 50
    GameVars.inputPlace.x = love.graphics.getWidth() / 2 - 110
    GameVars.inputPlace2.x = love.graphics.getWidth() / 2 - 40
    GameVars.inputPlace3.x = love.graphics.getWidth() / 2 + 40
    GameVars.inputPlace4.x = love.graphics.getWidth() / 2 + 110
    GameVars.inputPlace.size = 30
    GameVars.inputPlace2.size = 30
    GameVars.inputPlace3.size = 30
    GameVars.inputPlace4.size = 30
    Timer.tween(1, alpha, {alpha = 1}, 'in-out-quad')
end

function game:update(dt)
    Components.note:update(dt)
    Components.inputs:update(dt)
end

function game:keypressed(key, code) Components.inputs:keypressed(key, code) end

function game:mousepressed(x, y, mbutton) end

function game:draw()
    Graphics.setColor(1, 1, 1, alpha.alpha)
    Components.note:draw()
    Components.strums:draw()
end

function game:resize(w, h)
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    GameVars.inputPlace.y = love.graphics.getHeight() - 50
    GameVars.inputPlace.x = love.graphics.getWidth() / 2 - 110
    GameVars.inputPlace2.y = love.graphics.getHeight() - 50
    GameVars.inputPlace2.x = love.graphics.getWidth() / 2 - 40
    GameVars.inputPlace3.y = love.graphics.getHeight() - 50
    GameVars.inputPlace3.x = love.graphics.getWidth() / 2 + 40
    GameVars.inputPlace4.y = love.graphics.getHeight() - 50
    GameVars.inputPlace4.x = love.graphics.getWidth() / 2 + 110
    print('game was resized... | ' .. w .. " | " .. h)
end

return game
