local songSelect = {}

function songSelect:enter()
    Components.button:clear()
    local files = love.filesystem.getDirectoryItems("songs")
    for k, file in ipairs(files) do
        Components.button:new(file, function()
            startGame(file)
        end)
    end
    Components.button:new("back", function()
        Scene.switch(Scenes.menu)
    end)
end

function songSelect:keypressed(key)
end

function songSelect:draw()
    gr.setBackgroundColor(0, 0, 0)
    Components.stars:draw()
    Components.button:draw()
end

return songSelect
