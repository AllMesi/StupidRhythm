local game = require "states.GAME.game"
local shakeDuration = 0
local shakeMagnitude = 0
return {
    setMousePosition = function(x, y)
        x = x or 100
        y = y or 100
        love.mouse.setPosition(x, y)
    end,
    addMousePosition = function(x, y)
        x = x or 1
        y = y or 1
        local mx, my = love.mouse.getPosition()
        love.mouse.setPosition(mx + x, my + y)
    end,
    getMousePosition = function()
        return love.mouse.getPosition()
    end,
    setWindowPosition = function(x, y)
        x = x or 100
        y = y or 100
        love.window.setPosition(x, y)
    end,
    shakeWindow = function(duration, magnitude)
        magnitude = magnitude or 1
        duration = duration or 1
        local wx, wy = love.window.getPosition()
        timer.during(duration, function()
            love.window.setPosition(wx + love.math.random(-magnitude, magnitude), wy + love.math.random(-magnitude, magnitude))
        end)
    end,
    addWindowPosition = function(x, y)
        x = x or 1
        y = y or 1
        local wx, wy = love.window.getPosition()
        love.window.setPosition(wx + x, wy + y)
    end,
    resizeWindow = function(w, h)
        local ww, wh = love.window.getWidth(), love.window.getHeight()
        w = w or 1000
        h = h or 720
        love.window.setMode(w, h)
        love.window.setPosition(ww, wh)
    end,
    getWindowPosition = function()
        return love.window.getPosition()
    end,
    getWindowDimensions = function()
        return love.window.getWidth(), love.window.getHeight()
    end,
    getWindowHeight = function()
        return love.window.getHeight()
    end,
    getWindowWidth = function()
        return love.window.getWidth()
    end,
    setStrumPosition = function(s1, s2, s3, s4)
        game.setStrumPosition(s1, s2, s3, s4)
    end,
    print = function(...)
        for i, v in ipairs({...}) do
            io.write("[" .. os.date("%H:%M %p") .. " | StupidRhythm] " .. tostring(v) .. "\n")
        end
    end,
    Conductor = require "states.GAME.conductor",
    Game = require "states.GAME.game",
    flux = Flux
}
