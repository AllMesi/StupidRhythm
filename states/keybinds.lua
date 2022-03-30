local keybinds = {}
local k1 = true
local k2 = false
local k3 = false
local k4 = false

function keybinds:init()
    k1 = true
    k2 = false
    k3 = false
    k4 = false
end

function keybinds:enter() end

function keybinds:update(dt) end

function keybinds:keypressed(key, code)
    if not k1 or not k2 or not k3 or not k4 then k1 = true end
    if k1 then
        love.filesystem.write("key1", key)
        k1 = false
        k2 = true
    elseif k2 then
        love.filesystem.write("key2", key)
        k2 = false
        k3 = true
    elseif k3 then
        love.filesystem.write("key3", key)
        k3 = false
        k4 = true
    elseif k4 then
        love.filesystem.write("key4", key)
        k4 = false
        State.switch(States.menu)
    end
end

function keybinds:mousepressed(x, y, mbutton) end

function keybinds:draw()
    color1 = {0, 0, 0}
    color2 = {1, 1, 1}
    local x, y = 0, 0
    local width, height = love.graphics.getWidth(), love.graphics.getHeight()
    love.gradient.draw(function()
        love.graphics.rectangle("fill", x, y, width, height)
    end, "square", x + width / 2, y + height / 2, width / 2, height / 2, color1,
                       color2)
    Graphics.setColor(0, 0, 0)
    love.graphics.print(
        "key1: " .. love.filesystem.read('key1') .. "\nkey2: " ..
            love.filesystem.read('key2') .. "\nkey3: " ..
            love.filesystem.read('key3') .. "\nkey4: " ..
            love.filesystem.read('key4'), love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2)
end

return keybinds
