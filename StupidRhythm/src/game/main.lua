loadTimeStart = love.timer.getTime()

local mouse = {
    x = love.mouse.getX(),
    y = love.mouse.getY()
}

local showingLogs = false

local debugStuff = false

function love.load(arg)
    love.filesystem.mount(love.filesystem.getSourceBaseDirectory(), "")

    require "globals"

    GameConfig.loadFuncInMain(arg)

    local callbacks = {"update"}
    for k in pairs(love.handlers) do
        callbacks[#callbacks + 1] = k
    end

    -- love.filesystem.write("test.lua", test)

    -- local data = Lume.deserialize("test.lua")

    -- print(data.song.paused)

    local serializedString = Bitser.dumps({
        menu = {
            buttons = {
                normal = {
                    bg = {0, 0, 0},
                    fg = {1, 1, 1}
                },
                hot = {
                    bg = {1, 1, 1},
                    fg = {0, 0, 0}
                }
            }
        },
        game = {
            barStrum = {},
            noteSpeed = 1500,
            barSpeed = 1500,
            noFail = false,
            key1 = "x",
            key2 = "c",
            key3 = ",",
            key4 = ".",
            key1alt = "a",
            key2alt = "s",
            key3alt = "w",
            key4alt = "d",
            key1s = "1",
            key2s = "2",
            key3s = "3",
            key4s = "4",
            key1salt = "1",
            key2salt = "2",
            key3salt = "3",
            key4salt = "4",
            drawSB = false,
            tweenSB = false,
            drawGrid = false,
            circlesFlying = false,
            circlesFloating = false,
            strumLine = false,
            gridSquareWidth = 40,
            gridSquareHeight = 40,
            paused = false,
            barNotes = false,
            bgColour = {0.1, 0.1, 0.1, 1},
            foreColour = {0.5, 0.5, 0.5, 1},
            circleThickness = 2,
            lineThickness = 0,
            upscroll1 = false,
            upscroll2 = false,
            upscroll3 = false,
            upscroll4 = false
        }
    })
    local someValue = Bitser.loads(serializedString)

    print(someValue.game.key1)

    love.filesystem.write("StupidRhythm.save", serializedString)

    Scene.registerEvents(callbacks)
    Scene.switch(Scenes.beforeMenu)
end

function love.update(dt)
    GameConfig.updateFunc(dt)
end

function love.draw()
    GameConfig.drawFunc()
end

function love.keypressed(key, code, isRepeat)
    if not showingLogs then
        if key == "6" then
            screenshot()
        end
        if key == "-" then
            window.zoom = 1
            window.translate.x = 0
            window.translate.y = 0
        end
        if key == "5" then
            error("manually initiated crash")
        end
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
            else
                wasMaximized = false
            end
            if love.window.getFullscreen() then
                wasFullscreened = true
            else
                wasFullscreened = false
            end
            wi.setMode(1280, 720, {
                vsync = GameConfig.vsync,
                resizable = true
            })
            if wasMaximized then
                love.window.maximize()
            end
            if wasFullscreened then
                love.window.setFullscreen(not love.window.getFullscreen())
                love.window.setVSync(love.window.getFullscreen())
            end
        end
        if key == "1" then
            love.window.setFullscreen(not love.window.getFullscreen())
            love.window.setVSync(love.window.getFullscreen())
        end
    end
    if key == "7" then
        debugStuff = not debugStuff
    end
    if key == "9" then
        showingLogs = not showingLogs
    end
    if key == "f3" then

    end
end

function love.mousereleased(x, y, button)
end

function love.wheelmoved(x, y)
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
        Components.logger.log("wheel x: " .. x .. " y: " .. y)
    end
end

function love.threaderror(thread, errorMessage)
    Components.logger.log("Thread error!\n" .. errorMessage)
end

local utf8 = require("utf8")

local function error_printer(msg, layer)
    Components.logger.log((debug.traceback("Error: " .. tostring(msg), 1 + (layer or 1)):gsub("\n[^\n]+$", "")))
end

function love.run()
    if love.math then
        love.math.setRandomSeed(os.time())
        for i = 1, 3 do
            love.math.random()
        end
    end

    if love.event then
        love.event.pump()
    end

    if love.load then
        love.load(love.arg.parseGameArguments(arg), arg)
    end

    if love.timer then
        love.timer.step()
    end

    local dt = 0

    return function()
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

        if love.timer then
            dt = love.timer.step()
        end

        if love.update then
            love.update(dt)
        end

        if love.graphics and love.graphics.isActive() then
            love.graphics.origin()
            love.graphics.clear(love.graphics.getBackgroundColor())

            if love.draw then
                love.draw()
            end

            love.graphics.present()
        end

        if love.timer then
            love.timer.sleep(1 / GameConfig.fps)
        end
    end
end

function love.quit()
    Components.logger.log("game closed at " .. fps(false))
    Components.logger.log("game closed at " .. os.date("%I:%M%p"))
    discordRPC.shutdown()
end
