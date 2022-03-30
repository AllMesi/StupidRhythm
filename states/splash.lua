local splash = {}

local first = true

local alpha = {}

alpha.alpha = 0

function splash:init() end

function splash:enter()
    Timer.script(function(wait)
        Timer.tween(0.5, alpha, {alpha = 1}, 'in-out-quad')
        wait(0.6)
        Timer.tween(0.5, alpha, {alpha = 0}, 'in-out-quad')
        wait(0.6)
        first = false
        Timer.tween(0.5, alpha, {alpha = 1}, 'in-out-quad')
        wait(0.6)
        Timer.tween(0.5, alpha, {alpha = 0}, 'in-out-quad')
        wait(0.6)
        State.switch(States.menu)
    end)
end

function splash:update(dt) end

function splash:keypressed(key, code) end

function splash:mousepressed(x, y, mbutton) end

function splash:draw()
    Graphics.setColor(1, 1, 1, alpha.alpha)
    if first then
        love.graphics.print("Made with LÖVE2D", love.graphics.getWidth() / 2,
                            love.graphics.getHeight() / 2)
    else
        love.graphics.print("Made by AllMesi", love.graphics.getWidth() / 2,
                            love.graphics.getHeight() / 2)
    end
end

return splash
