local options = {}

function options:enter()
    Components.button:clear()
    Components.button:new("keybinds", function()
        bruh.buttonAlpha = 0
    -- Scene.switch(Scenes.menu)
    end)
    Components.button:new("back", function()
        Scene.switch(Scenes.menu)
    end)
end

function options:keypressed(key)
end

function options:draw()
    gr.setBackgroundColor(0.1, 0.1, 0.1)
    Components.stars:draw()
    Components.button:draw()
end

return options
