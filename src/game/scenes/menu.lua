local menu = {}

local circle = {}

local settingsMenu = {
    x = 0,
    y = 0,
    visible = false
}

function menu:enter()
    Timer.after(1, function()
        Components.stars:init()
    end)
end

function menu:draw()
    Components.stars:draw()
    Components.button:draw()
end

function menu:keypressed(key)
    if key == "c" then
        end
end

return menu
