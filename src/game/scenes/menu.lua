local menu = {}

local circle = {}

local settingsMenu = {
    x = 0,
    y = 0,
    visible = false
}

function menu:enter()

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
