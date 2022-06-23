io.stdout:setvbuf("no")

local memory = 0

local cameraZoom = 1

local hi = false

local plugins = {}
local blur

function love.load()
    love.filesystem.mount(love.filesystem.getSourceBaseDirectory(), "")
    if not love.filesystem.getInfo("discordrpc.dll") then
        love.window.close()
        love.window.showMessageBox("love.exe - System Error",
            "The code execution cannot proceed because discordrpc.dll\nwas not found. Reninstalling the program may fix this problem.",
            "error")
        love.event.quit(1)
    end
    if not hi then
        require "StupidRhythm"
    end
    utf8 = require("utf8")

    local files = getFiles("plugins")

    for i, file in ipairs(files) do
        local chunk = love.filesystem.load(file)()
        if chunk then
            table.insert(plugins, chunk)
        end
    end

    for i, v in ipairs(plugins) do
        if v.load then
            v.load()
        end
    end

    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    love.window.setTitle("StupidRhythm")

    love.keyboard.setKeyRepeat(true)

    discordRPC.initialize("956876051252920320", true)
    presence = {
        state = "In Menus",
        details = "",
        startTimestamp = 0,
        endTimestamp = 0
    }

    nextPresenceUpdate = 0

    love.graphics.setDefaultFilter("nearest", "nearest")

    love.window.setIcon(love.image.newImageData("assets/images/icon.png"))

    revamped12 = love.graphics.newFont("assets/fonts/Revamped.otf", 12)
    revamped32 = love.graphics.newFont("assets/fonts/Revamped.otf", 32)
    pixel12 = love.graphics.newFont("assets/fonts/pixel.otf", 12)
    pixel32 = love.graphics.newFont("assets/fonts/pixel.otf", 32)
    pixel50 = love.graphics.newFont("assets/fonts/pixel.otf", 50)
    pixel100 = love.graphics.newFont("assets/fonts/pixel.otf", 100)
    revamped50 = love.graphics.newFont("assets/fonts/Revamped.otf", 50)
    default = love.graphics.newFont(14)
    basicSans = love.graphics.newFont("assets/fonts/Basic-Regular.ttf", 14)

    images.thing = love.graphics.newImage('assets/images/thing.png')

    love.window.setMode(1280, 720, {
        resizable = true,
        fullscreen = false,
        vsync = true,
        borderless = false
    })

    noteCam1 = camera()
    noteCam2 = camera()
    noteCam3 = camera()
    noteCam4 = camera()
    globalCam = camera()
    gameCam = camera()
    stateManager:addState(states.main, "main")
    stateManager:addState(states.options, "options")
    stateManager:addState(states.game, "game")
    stateManager:addState(states.songSelect, "songSelect")
    stateManager:addState(states.chartingeditor, "chartingeditor")
    stateManager:switch("main", true)

    grid.init()

    love.graphics.setFont(pixel12)
end

function love.quit()
    for i, v in ipairs(plugins) do
        v.quit()
    end
    discordRPC.shutdown()
end

function love.draw()
    if stateManager:current() ~= states.game or stateManager:current() ~= states.nothing then
        if globalCam ~= null then
            globalCam:attach()
        end
    end
    stateManager:draw()
    if stateManager:current() ~= states.game or stateManager:current() ~= states.nothing then
        if globalCam ~= null then
            globalCam:detach()
        end
    end
    love.graphics.setColor(255, 255, 255)
    if testingMode then
        love.graphics.print("FPS: " .. math.floor(1 / love.timer.getDelta()) .. "\nMemory: " .. memory .. "MB" ..
                                "\nLOVE Version: " .. love.getVersion(), pixel12, 10, 5)
    end
    love.graphics.print("[..:..]", basicSans, love.graphics.getWidth() - basicSans:getWidth("[..:..]"),
        love.graphics.getHeight() - basicSans:getHeight())
    if wasScreenshot then
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("teststet", pixel12, 10, 5)
    end
    for i, v in ipairs(plugins) do
        if v.draw then
            v.draw()
        end
    end
end

function love.update(dt)
    if globalCam ~= null then
        globalCam:lookAt(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    end

    presence.startTimestamp = math.floor(presence.startTimestamp + dt)

    memory = math.floor(collectgarbage("count") / 1024 + love.graphics.getStats().texturememory / 1048576)

    stateManager:update(dt)
    Flux.update(dt)
    timer.update(dt)

    if nextPresenceUpdate < love.timer.getTime() then
        discordRPC.updatePresence(presence)
        nextPresenceUpdate = love.timer.getTime() + 2.0
    end
    discordRPC.runCallbacks()

    globalCam:zoomTo(cameraZoom)

    for i, v in ipairs(plugins) do
        if v.update then
            v.update(dt)
        end
    end
end

function love.keypressed(key)
    if key == "f3" then
        testingMode = not testingMode
    end
    if key == "f2" then
        screenshot:start()
    end
    if key == "c" then
        if love.keyboard.isDown("lctrl") then
            error("Manually initiated crash")
        end
    end
    stateManager:keypressed(key)
    for i, v in ipairs(plugins) do
        v.keypressed(key)
    end
end

function love.keyreleased(key)
    stateManager:keyreleased(key)
    for i, v in ipairs(plugins) do
        if v.keyreleased then
            v.keyreleased(key)
        end
    end
end

function love.mousepressed(x, y, button)
    stateManager:mousepressed(x, y, button)
end

function love.wheelmoved(x, y)
    if love.keyboard.isDown("lctrl", "rctrl") then
        cameraZoom = cameraZoom + y * 0.05
    end
    stateManager:wheelmoved(x, y)
    for i, v in ipairs(plugins) do
        if v.wheelmoved then
            v.wheelmoved(x, y)
        end
    end
end

function love.resize(w, h)
    stateManager:resize(w, h)
    for i, v in ipairs(plugins) do
        if v.resize then
            v.resize(w, h)
        end
    end
end

local function error_printer(msg, layer)
    print((debug.traceback("Error: " .. tostring(msg), 1 + (layer or 1)):gsub("\n[^\n]+$", "")))
end
function love.threaderror(thread, errorstr)
    print("Thread error!\n" .. errorstr)
end
