local game = require "states.GAME.game"
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
    shakeWindow = function(radius)
        radius = radius or 1
        local wx, wy = love.window.getPosition()
        love.window.setPosition(wx + love.math.random(-radius, radius), wy + love.math.random(-radius, radius))
    end,
    addWindowPosition = function(x, y)
        x = x or 1
        y = y or 1
        local wx, wy = love.window.getPosition()
        love.window.setPosition(wx + x, wy + y)
    end,
    resizeWindow = function(w, h)
        local ww, wh = love.window.getWidth(), love.window.getHeight()
        w = w or 1280
        h = h or 720
        love.window.setMode(w, h, {
            resizable = true
        })
        love.window.setPosition(ww, wh)
    end,
    getWindowPosition = function()
        return love.window.getPosition()
    end,
    getWindowDimensions = function()
        return love.window.getWidth(), love.window.getHeight()
    end,
    setStrumPosition = function(s1, s2, s3, s4)
        game.setStrumPosition(s1, s2, s3, s4)
    end,
    print = print,
    love = love
}