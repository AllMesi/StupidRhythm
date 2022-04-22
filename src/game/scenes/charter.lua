local charter = {}


function charter:enter()
    Components.button:clear()
end

function charter:keypressed(key)
end

function charter:draw()
    gr.setBackgroundColor(0, 0, 0)
    Components.stars:draw()
    Components.button:draw()
end

return charter
