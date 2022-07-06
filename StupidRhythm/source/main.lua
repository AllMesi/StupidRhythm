io.stdout:setvbuf("no")

local memory = 0

local cameraZoom = 1

local plugins = {}
local loaded = false

function love.load()
    love.filesystem.mount(love.filesystem.getSourceBaseDirectory(), "")

    if systemOS() == "Windows" then
        if not love.filesystem.getInfo("discordrpc.dll") then
            love.window.showMessageBox("love.exe - System Error",
                "The code execution cannot proceed because discordrpc.dll\nwas not found. Reninstalling the program may fix this problem.",
                "error")
            love.event.quit(1)
        end
    end
    love.graphics.setDefaultFilter("nearest", "nearest")

    require "StupidRhythm"
    utf8 = require("utf8")

    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    love.window.setTitle("StupidRhythm")

    love.keyboard.setKeyRepeat(true)

    love.filesystem.write("testChart.json", json.encode({
        bpm = 100,
        speed = 1.3,
        song = "testingChart",
        audio = "audio.ogg",
        notes = {
            {500, 0, 100, 1, 0},
            {1000, 0, 100, 1, 0},
            {1500, 0, 100, 1, 0},
            {2000, 0, 100, 1, 0},
        }
    }))

    love.window.setIcon(love.image.newImageData("images/icon.png"))
    love.window.setMode(1000, 720, {
        fullscreen = false,
        vsync = true,
        borderless = false
    })

    if systemOS() == "Windows" then
        discordRPC.initialize("956876051252920320", true)
    end

    presence = {
        state = "",
        details = "Booting...",
        startTimestamp = 0,
        endTimestamp = 0
    }

    nextPresenceUpdate = 0

    love.graphics.setDefaultFilter("nearest", "nearest")

    grid.init()

    revamped12 = love.graphics.newFont("fonts/Revamped.otf", 12)
    revamped32 = love.graphics.newFont("fonts/Revamped.otf", 32)
    pixel12 = love.graphics.newFont("fonts/pixel.otf", 12)
    pixel32 = love.graphics.newFont("fonts/pixel.otf", 32)
    pixel50 = love.graphics.newFont("fonts/pixel.otf", 50)
    pixel100 = love.graphics.newFont("fonts/pixel.otf", 100)
    vcr12 = love.graphics.newFont("fonts/vcr osd mono.ttf", 12)
    vcr15 = love.graphics.newFont("fonts/vcr osd mono.ttf", 15)
    vcr20 = love.graphics.newFont("fonts/vcr osd mono.ttf", 20)
    vcr32 = love.graphics.newFont("fonts/vcr osd mono.ttf", 32)
    vcr50 = love.graphics.newFont("fonts/vcr osd mono.ttf", 50)
    vcr100 = love.graphics.newFont("fonts/vcr osd mono.ttf", 100)
    revamped50 = love.graphics.newFont("fonts/Revamped.otf", 50)
    default = love.graphics.newFont(14)
    basicSans = love.graphics.newFont("fonts/Basic-Regular.ttf", 14)
    love.graphics.setFont(vcr15)

    globalCam = camera()
    gameCam = camera()

    stateManager:addState(states.main, "main")
    stateManager:addState(states.options, "options")
    stateManager:addState(states.game, "game")
    stateManager:addState(states.songSelect, "songSelect")
    stateManager:addState(states.chartingeditor, "chartingeditor")
    stateManager:addState(states.loading, "loading")
    stateManager:switch("loading", true)
    love.window.setVSync(false)
end

function love.quit()
    for i, v in ipairs(plugins) do
        v.quit()
    end
    if systemOS() == "Windows" then
        discordRPC.shutdown()
    end
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
        love.graphics.print("FPS: " .. love.timer.getFPS() .. "\nMemory: " .. memory .. "MB" .. "\nLÖVE Version: " ..
                                love.getVersion() .. "\nLily Version: " .. lily._VERSION .. "\nFlux Version: " ..
                                Flux._version .. "\nLume Version: " .. lume._version .. "\n" ..
                                formatTime(love.timer.getTime()), 10, 5)
    else
        love.graphics.print(formatTime(love.timer.getTime()), 10, 5)
    end
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

    if systemOS() == "Windows" then
        if nextPresenceUpdate < love.timer.getTime() then
            discordRPC.updatePresence(presence)
            nextPresenceUpdate = love.timer.getTime() + 2.0
        end
        discordRPC.runCallbacks()
    end

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
        if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
            error("Manually initiated crash")
        end
    end
    if key == "r" then
        if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
            love.event.quit("restart", 0)
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

function love.mousepressed(x, y, b)
    stateManager:mousepressed(x, y, b)
end

function love.wheelmoved(x, y)
    if love.keyboard.isDown("lctrl", "rctrl") then
        cameraZoom = cameraZoom + y * 0.05
    end
    if love.keyboard.isDown("lalt", "ralt") then
        -- cameraZoom = cameraZoom + y * 0.05
        love.window.setAlpha(love.window.getAlpha() + y * 0.05)
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

function love.errorhandler(msg)
    msg = tostring(msg)

    error_printer(msg, 2)

    if not love.window or not love.graphics or not love.event then
        return
    end

    if not love.graphics.isCreated() or not love.window.isOpen() then
        local success, status = pcall(love.window.setMode, 800, 600)
        if not success or not status then
            return
        end
    end

    -- Reset state.
    if love.mouse then
        love.mouse.setVisible(true)
        love.mouse.setGrabbed(false)
        love.mouse.setRelativeMode(false)
        if love.mouse.isCursorSupported() then
            love.mouse.setCursor()
        end
    end
    if love.joystick then
        -- Stop all joystick vibrations.
        for i, v in ipairs(love.joystick.getJoysticks()) do
            v:setVibration()
        end
    end
    if love.audio then
        love.audio.stop()
    end

    love.graphics.reset()
    local font = love.graphics.setNewFont(14)

    love.graphics.setColor(255, 255, 255)

    local trace = debug.traceback()

    love.graphics.origin()

    local sanitizedmsg = {}
    for char in msg:gmatch(utf8.charpattern) do
        table.insert(sanitizedmsg, char)
    end
    sanitizedmsg = table.concat(sanitizedmsg)

    local err = {}

    table.insert(err, "Error\n")
    table.insert(err, sanitizedmsg)

    if #sanitizedmsg ~= #msg then
        table.insert(err, "Invalid UTF-8 string in error message.")
    end

    table.insert(err, "\n")

    for l in trace:gmatch("(.-)\n") do
        if not l:match("boot.lua") then
            l = l:gsub("stack traceback:", "Traceback\n")
            table.insert(err, l)
        end
    end

    local p = table.concat(err, "\n")

    images.gradient:setWrap('repeat', 'clamp')
    local newQuad = love.graphics.newQuad(0, 0, love.graphics.getWidth(), love.graphics.getHeight(),
        images.gradient:getWidth(), images.gradient:getHeight())

    p = p:gsub("\t", "")
    p = p:gsub("%[string \"(.-)\"%]", "%1")

    local function draw()
        if not love.graphics.isActive() then
            return
        end
        local pos = 70
        newQuad = love.graphics.newQuad(0, 0, love.graphics.getWidth(), love.graphics.getHeight(),
            images.gradient:getWidth(), images.gradient:getHeight())
        love.graphics.clear()
        love.graphics.draw(images.gradient, newQuad, 0, 0)
        love.graphics.printf(p, 0, 10, love.graphics.getWidth(), "center")
        love.graphics.present()
    end

    local fullErrorText = p
    local function copyToClipboard()
        if not love.system then
            return
        end
        love.system.setClipboardText(fullErrorText)
        p = p .. "\nCopied to clipboard!"
    end

    if love.system then
        p = p .. "\n\nPress Ctrl+C or tap to copy this error"
    end

    return function()
        love.event.pump()

        for e, a, b, c in love.event.poll() do
            if e == "quit" then
                return 1
            elseif e == "keypressed" and a == "escape" then
                return 1
            elseif e == "keypressed" and a == "c" and love.keyboard.isDown("lctrl", "rctrl") then
                copyToClipboard()
            elseif e == "touchpressed" then
                local name = love.window.getTitle()
                if #name == 0 or name == "Untitled" then
                    name = "Game"
                end
                local buttons = {"OK", "Cancel"}
                if love.system then
                    buttons[3] = "Copy to clipboard"
                end
                local pressed = love.window.showMessageBox("Quit " .. name .. "?", "", buttons)
                if pressed == 1 then
                    return 1
                elseif pressed == 3 then
                    copyToClipboard()
                end
            end
        end

        draw()

        if love.timer then
            love.timer.sleep(0.1)
        end
    end

end

function systemOS()
    return love.system.getOS()
end

function getTimer()
    return love.timer.getTime() * 1000
end
