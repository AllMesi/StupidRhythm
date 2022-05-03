local menu = {}

local circle = {}

local settingsMenu = {
    x = -505,
    y = 5,
    visible = false,
    open = false,
    animationActive = false
}

local show_message = false

function menu:enter()
    Components.button:clear()
    Components.stars:init()
    Components.button:new("Song Select", function()
        switchScene(Scenes.menus.songSelect)
    end)
    Components.button:new("Options", function()
        switchScene(Scenes.menus.options)
    end)
    Components.button:new("Quit", function()
        switchScene(Scenes.l)
    end)
end

function menu:draw()
    gr.setBackgroundColor(0.1, 0.1, 0.1)
    if settingsMenu.visible then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", settingsMenu.x, settingsMenu.y, 400,
            love.graphics.getHeight() - settingsMenu.y * 2, 10)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 100, 100, 150, 120, 10)
        love.graphics.setColor(1, 1, 1)
    end
    love.graphics.setColor(0, 0, 0)
end

function menu:update(dt)
end

function menu:keypressed(key)
    if key == "c" then
        if not settingsMenu.animationActive then
            if not settingsMenu.open then
                settingsMenu.animationActive = true
                settingsMenu.visible = true
                Flux.to(settingsMenu, 1, {
                    x = 5
                }):ease("quartout"):oncomplete(function()
                    settingsMenu.open = true
                    settingsMenu.animationActive = false
                end)
            elseif settingsMenu.open then
                settingsMenu.animationActive = true
                Flux.to(settingsMenu, 1, {
                    x = -400
                }):ease("quartout"):oncomplete(function()
                    settingsMenu.open = false
                    settingsMenu.visible = false
                    settingsMenu.animationActive = false
                end)
            end
        end
    end
end

return menu
