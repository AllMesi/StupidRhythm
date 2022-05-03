local options = {};
local optionStuff = {
    volume = 1,
    volSlider = {
        value = 1,
        min = 0,
        max = 2
    }
};

function options:enter()
    Components.button:clear();
    Components.button:new("back", function()
        switchScene(Scenes.menus.menu);
    end);
end

function options:keypressed(key)
end

function options:draw()
    gr.setBackgroundColor(0.1, 0.1, 0.1);
    suit.draw();
end

function options:update(dt)
    love.audio.setVolume(optionStuff.volume);
end

return options;
