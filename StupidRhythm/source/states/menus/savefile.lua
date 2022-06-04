local state = {}

local y = 0
local x = 0

local saveFileNum = 0

function state.enter()
    love.keyboard.setKeyRepeat(true)
    love.window.setMode(1920 / 2, 1080 / 2, {
        resizable = true,
        fullscreen = false,
        vsync = true,
        borderless = false
    })
end

function state.update(dt)
    y = y - 50 * dt
    x = x - 50 * dt
end

function state.draw()
    grid_quad:setViewport(x, y, love.graphics:getWidth(), love.graphics:getHeight())
    love.graphics.draw(grid, grid_quad, 0, 0)
    love.graphics.print("< save" .. saveFileNum .. ".dat >", revamped32,
        love.graphics.getWidth() * 0.5 - revamped32:getWidth("save" .. saveFileNum .. ".dat") / 2,
        love.graphics.getHeight() * 0.5 - revamped32:getHeight("save" .. saveFileNum .. ".dat"))
end

function state.keypressed(key)
    if key == "left" then
        saveFileNum = saveFileNum - 1
    end
    if key == "right" then
        saveFileNum = saveFileNum + 1
    end
    if key == "return" or key == "kpenter" then
        saveFile = "save" .. saveFileNum .. ".dat"
        load()
    end
end

function state.exit()
    love.keyboard.setKeyRepeat(false)
end

function load()
    
end

return state
