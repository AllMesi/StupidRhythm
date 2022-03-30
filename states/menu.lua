local menu = {}

local alpha = {}

alpha.alpha = 0

function menu:init() end

function menu:enter() Timer.tween(1, alpha, {alpha = 1}, 'in-out-quad') end

function menu:update(dt) end

function menu:keypressed(key, code)
    if key == 'return' then
        Timer.script(function(wait)
            Timer.tween(1, alpha, {alpha = 0}, 'in-out-quad')
            wait(1)
            State.switch(States.game)
        end)
    end
    if key == 'escape' then State.switch(States.keybinds) end
end

function menu:mousepressed(x, y, mbutton) end

function menu:draw()
    color1 = {0, 0, 0, alpha.alpha}
    color2 = {1, 1, 1, alpha.alpha}
    local x, y = 0, 0
    local width, height = love.graphics.getWidth(), love.graphics.getHeight()
    love.gradient.draw(function()
        love.graphics.rectangle("fill", x, y, width, height)
    end, "square", x + width / 2, y + height / 2, width / 2, height / 2, color1,
                       color2)
    Graphics.setColor(0, 0, 0, alpha.alpha)
    love.graphics.print("Press Enter to play, Press Esc to change keybinds",
                        love.graphics.getWidth() / 2,
                        love.graphics.getHeight() / 2)
end

return menu
