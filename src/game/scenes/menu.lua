local menu = {}

local circle = {}

local settingsMenu = {
    x = 0,
    y = 0,
    visible = false
}

function menu:enter()
    Components.button:clear()
    Components.stars:init()
    Components.button:new("Song Select", function()
        Scene.switch(Scenes.songSelect)
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
