local loadTimeStart = love.timer.getTime()

local mouse = {
    x = love.mouse.getX(),
    y = love.mouse.getY()
}

local showingLogs = true

local updating = true

local updateWhileShowingLogs = false

function love.load()
    love.filesystem.mount(love.filesystem.getSourceBaseDirectory(), "")

    require "globals"
    print("Loading...")

    love.graphics.setDefaultFilter("nearest", "nearest")

    love.window.setMode(1280, 720, {
        vsync = false,
        resizable = true,
        borderless = false
    })

    love.graphics.setDefaultFilter(CONFIG.graphics.filter.down, CONFIG.graphics.filter.up,
        CONFIG.graphics.filter.anisotropy)
    fps(true, GameConfig.fps)

    window = {
        translate = {
            x = 0,
            y = 0
        },
        zoom = 1
    }
    dscale = 2 ^ (1 / 6)
    k = 0

    local callbacks = {"update"}
    for k in pairs(love.handlers) do
        callbacks[#callbacks + 1] = k
    end

    Scene.registerEvents(callbacks)
    Scene.switch(Scenes.beforeMenu)

    local loadTimeEnd = love.timer.getTime()
    local loadTime = (loadTimeEnd - loadTimeStart)
    print(("Loaded game in %.3f seconds."):format(loadTime))

    print("Press '9' to toggle logs.")

    showingLogs = false
end

function love.update(dt)
    math.randomseed(os.clock() ^ math.random(1, 500))
    ww = gr.getWidth()
    wh = gr.getHeight()
    mx, my = mo.getX(), mo.getY()
    if GameConfig.extraInfoInTitle then
        love.window.setTitle(GameConfig.title .. StupidRhythm.addToTitle .. " | " .. fps(false))
    else
        love.window.setTitle(GameConfig.title)
    end
    if not updating then
        return
    end
    Flux.update(dt)
    Timer.update(dt)
    Components.stars:update(dt)
    Components.button:update(dt)
    if nextPresenceUpdate then
        if nextPresenceUpdate < love.timer.getTime() then
            discordRPC.updatePresence(presence)
            nextPresenceUpdate = love.timer.getTime() + 2.0
        end
        discordRPC.runCallbacks()
    end
end

function love.focus(f)
    if not f and updating then
        updating = false
    elseif f and not updating then
        updating = true
    end
end

function love.draw()
    local drawTimeStart = love.timer.getTime()
    gr.push()
    if not showingLogs then
        gr.translate(window.translate.x, window.translate.y)
        gr.scale(window.zoom)
        Scene.current():draw()
    else
        gr.setBackgroundColor(0, 0, 0)
        for i = 1, #logs do
            gr.print(logs[i], 0, i * 15)
        end
    end
    gr.setLineWidth(1)
    gr.pop()
    local drawTimeEnd = love.timer.getTime()
    local drawTime = drawTimeEnd - drawTimeStart
    -- if DEBUG then
    --     love.graphics.push()
    --     local x, y = CONFIG.debug.stats.position.x, CONFIG.debug.stats.position.y
    --     local dy = CONFIG.debug.stats.lineHeight
    --     local stats = love.graphics.getStats()
    --     local memoryUnit = "KB"
    --     local ram = collectgarbage("count")
    --     local vram = stats.texturememory / 1024
    --     if not CONFIG.debug.stats.kilobytes then
    --         ram = ram / 1024
    --         vram = vram / 1024
    --         memoryUnit = "MB"
    --     end
    --     local info = {
    --         fps(false),
    --         "DRAW: " .. ("%7.3fms"):format(Lume.round(drawTime * 1000, .001)),
    --         "RAM: " .. string.format("%7.2f", Lume.round(ram, .01)) .. memoryUnit,
    --         os.date("%I:%M%p")
    --     }
    --     for i, text in ipairs(info) do
    --         local sx, sy = CONFIG.debug.stats.shadowOffset.x, CONFIG.debug.stats.shadowOffset.y
    --         love.graphics.setColor(CONFIG.debug.stats.shadow)
    --         love.graphics.print(text, x + sx, y + sy + (i - 1) * dy)
    --         love.graphics.setColor(CONFIG.debug.stats.foreground)
    --         love.graphics.print(text, x, y + (i - 1) * dy)
    --     end
    --     love.graphics.pop()
    -- else
    --     love.graphics.push()
    --     local x, y = CONFIG.debug.stats.position.x, CONFIG.debug.stats.position.y
    --     local dy = CONFIG.debug.stats.lineHeight
    --     local info = {
    --         fps(false),
    --         os.date("%I:%M%p")
    --     }
    --     for i, text in ipairs(info) do
    --         local sx, sy = CONFIG.debug.stats.shadowOffset.x, CONFIG.debug.stats.shadowOffset.y
    --         love.graphics.setColor(CONFIG.debug.stats.shadow)
    --         love.graphics.print(text, x + sx, y + sy + (i - 1) * dy)
    --         love.graphics.setColor(CONFIG.debug.stats.foreground)
    --         love.graphics.print(text, x, y + (i - 1) * dy)
    --     end
    --     love.graphics.pop()
    -- end
    gr.setColour(1, 1, 1)
end

function love.keypressed(key, code, isRepeat)
    if not updating then
        return
    end
    if not showingLogs then
        if not RELEASE and code == CONFIG.debug.key then
            CONFIG.DEBUG = not DEBUG
        end
        if key == "6" then
            screenshot()
        end
        if key == "d" then
            window.zoom = 1
            window.translate.x = 0
            window.translate.y = 0
        end
        -- if key == "-" then
        --     error("manually initiated crash")
        -- end
        if key == "=" then
            if love.window.isMaximized() then
                love.window.restore()
            else
                love.window.maximize()
            end
        end
        if key == "0" then
            if love.window.isMaximized() then
                wasMaximized = true
            end
            wi.setMode(1280, 720, {
                vsync = false,
                resizable = true
            })
            if wasMaximized then
                love.window.maximize()
            end
        end
    end
    if key == "9" then
        showingLogs = not showingLogs
    end
end

function love.wheelmoved(x, y)
    if not updating then
        return
    end
    local mx = love.mouse.getX()
    local my = love.mouse.getY()
    if not (y == 0) then -- mouse wheel moved up or down
        --		zoom in to point or zoom out of point
        local mouse_x = mx - window.translate.x
        local mouse_y = my - window.translate.y
        k = dscale ^ y
        window.zoom = window.zoom * k
        window.translate.x = math.floor(window.translate.x + mouse_x * (1 - k))
        window.translate.y = math.floor(window.translate.y + mouse_y * (1 - k))
    else
        print("wheel x: " .. x .. " y: " .. y)
    end
end

function love.threaderror(thread, errorMessage)
    print("Thread error!\n" .. errorMessage)
end

-----------------------------------------------------------
-- Error screen.
-----------------------------------------------------------
local utf8 = require("utf8")

local function error_printer(msg, layer)
    print((debug.traceback("Error: " .. tostring(msg), 1 + (layer or 1)):gsub("\n[^\n]+$", "")))
end

function exitGame()
    love.audio.stop()
    print("game closed at " .. fps(false))
    print("game closed at " .. os.date("%I:%M%p"))
    discordRPC.shutdown()
    showingLogs = true
    updateWhileShowingLogs = true
    Timer.after(1, function()
        love.event.quit()
    end)
end

function love.run()
    if love.load then
        love.load(love.arg.parseGameArguments(arg), arg)
    end

    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then
        love.timer.step()
    end

    local dt = 0

    -- Main loop time.
    return function()
        -- Process events.
        love.event.pump()
        if love.event then
            for name, a, b, c, d, e, f in love.event.poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        return a or 0
                    end
                end
                love.handlers[name](a, b, c, d, e, f)
            end
        end

        -- Update dt, as we'll be passing it to update
        if love.timer then
            dt = love.timer.step()
        end

        -- Call update and draw
        if love.update then
            love.update(dt)
        end -- will pass 0 if love.timer is disabled

        if love.graphics and love.graphics.isActive() then
            love.graphics.origin()
            love.graphics.clear(love.graphics.getBackgroundColor())

            if love.draw then
                love.draw()
            end

            love.graphics.present()
        end

        if love.timer then
            love.timer.sleep(1 / CONFIG.FPS)
        end
    end
end
