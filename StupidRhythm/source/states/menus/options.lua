local state = {}

local y = 0
local x = 0

local selects = {"Toggle VSync - " .. tostring(love.window.getVSync()),
                 "Toggle Fullscreen - " .. tostring(love.window.getFullscreen()), "Back"}
local selectsExplain = {"More frames at the cost of stableness", "Fullscreen mode", "Go back to the main menu"}
local curSelect = 1

function state.enter()
    presence = {
        state = "in game",
        details = "in options menu",
        startTimestamp = 0,
        endTimestamp = os.time()
    }
end

function state.update(dt)
    grid.update(dt)
end

function state.draw()
    grid.draw()
    for i, v in ipairs(selects) do
        if i == curSelect then
            love.graphics.setColor(50, 153, 187)
        else
            love.graphics.setColor(255, 255, 255)
        end
        love.graphics.print(v, revamped50, 10, love.graphics.getHeight() / 2 - 30 - revamped50:getHeight(v) *
            (#selects - 1) / 2 + i * revamped50:getHeight(v))
    end
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(),
        revamped32:getHeight(selectsExplain[curSelect] or "There is currently no text here"))
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(selectsExplain[curSelect] or "There is currently no text here", revamped32, love.graphics
        .getWidth() / 2 - revamped32:getWidth(selectsExplain[curSelect] or "There is currently no text here") / 2, 0)
end

function state.keypressed(key)
    if key == "up" then
        if curSelect > 1 then
            curSelect = curSelect - 1
        else
            curSelect = #selects
        end
    end
    if key == "down" then
        if curSelect < #selects then
            curSelect = curSelect + 1
        else
            curSelect = 1
        end
    end
    if key == "return" or key == "kpenter" then
        if curSelect == 1 then
            settings = bitser.loads(love.filesystem.read(saveFile))
            love.window.setVSync(not settings.vsync)
            local settingsSave = bitser.dumps({
                fullscreen = settings.fullscreen,
                vsync = not settings.vsync,
                bot = settings.bot
            })
            love.filesystem.write(saveFile, settingsSave)
        elseif curSelect == 2 then
            settings = bitser.loads(love.filesystem.read(saveFile))
            love.window.setFullscreen(not settings.fullscreen)
            local settingsSave = bitser.dumps({
                fullscreen = not settings.fullscreen,
                vsync = settings.vsync,
                bot = settings.bot
            })
            love.filesystem.write(saveFile, settingsSave)
        elseif curSelect == 3 then
            stateManager:switch("main", true)
        end
        selects = {"Toggle VSync - " .. tostring(love.window.getVSync()),
                   "Toggle Fullscreen - " .. tostring(love.window.getFullscreen()), "Back"}
    end
    if key == "f11" then
        selects = {"Toggle VSync - " .. tostring(love.window.getVSync()),
                   "Toggle Fullscreen - " .. tostring(love.window.getFullscreen()), "Back"}
    end
end

return state
