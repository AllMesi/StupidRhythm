io.stdout:setvbuf("no")

local memory = 0

local cameraZoom = 1

local hi = false

local plugins = {}

function love.load()
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

    love.window.setTitle(WindowTitle)

    love.keyboard.setKeyRepeat(true)

    discordRPC.initialize("956876051252920320", true)
    presence = {
        state = "booting",
        details = "",
        startTimestamp = 0,
        endTimestamp = os.time()
    }

    nextPresenceUpdate = 0

    love.filesystem.setIdentity(".StupidRhythm")

    love.graphics.setDefaultFilter("nearest", "nearest")

    love.window.setIcon(love.image.newImageData("assets/images/icon.png"))

    revamped12 = love.graphics.newFont("assets/fonts/Revamped.otf", 12)
    revamped32 = love.graphics.newFont("assets/fonts/Revamped.otf", 32)
    revamped50 = love.graphics.newFont("assets/fonts/Revamped.otf", 50)
    default = love.graphics.newFont(32)
    basicSans = love.graphics.newFont("assets/fonts/Basic-Regular.ttf", 14)

    images.cool = love.graphics.newImage('assets/images/cool.png')
    images.miss = love.graphics.newImage('assets/images/miss.png')
    images.c1 = love.graphics.newImage('assets/images/colours/1.png')
    images.c2 = love.graphics.newImage('assets/images/colours/2.png')
    images.c3 = love.graphics.newImage('assets/images/colours/3.png')
    images.c4 = love.graphics.newImage('assets/images/colours/4.png')
    images.logo = love.graphics.newImage('assets/images/logo.png')
    images.n1 = love.graphics.newImage('assets/images/notes/note1.png')
    images.n2 = love.graphics.newImage('assets/images/notes/note2.png')
    images.n3 = love.graphics.newImage('assets/images/notes/note3.png')
    images.n4 = love.graphics.newImage('assets/images/notes/note4.png')
    images.n1a = love.graphics.newImage('assets/images/notes/note1a.png')
    images.n2a = love.graphics.newImage('assets/images/notes/note2a.png')
    images.n3a = love.graphics.newImage('assets/images/notes/note3a.png')
    images.n4a = love.graphics.newImage('assets/images/notes/note4a.png')
    images.nl = love.graphics.newImage('assets/images/notes/notel.png')
    images.nh = love.graphics.newImage('assets/images/notes/noteh.png')
    images.nn = love.graphics.newImage('assets/images/notes/noten.png')
    images.nk = love.graphics.newImage('assets/images/notes/notekey.png')
    images.nko = love.graphics.newImage('assets/images/notes/notekey-overlay.png')
    images.sb = love.graphics.newImage('assets/images/sb.png')
    images.thing = love.graphics.newImage('assets/images/thing.png')

    if not hi then
        if not love.filesystem.getInfo(saveFile) then
            local settingsSave = bitser.dumps({
                fullscreen = false,
                vsync = true,
                bot = false
            })
            love.filesystem.write(saveFile, settingsSave)
            local settings = bitser.loads(love.filesystem.read(saveFile))

            love.window.setMode(WindowWidth, WindowHeight, {
                resizable = true,
                fullscreen = settings.fullscreen,
                vsync = settings.vsync,
                borderless = false
            })
        else
            local settings = bitser.loads(love.filesystem.read(saveFile))

            love.window.setMode(WindowWidth, WindowHeight, {
                resizable = true,
                fullscreen = settings.fullscreen,
                vsync = settings.vsync,
                borderless = false
            })
        end
    end

    noteSize1X, noteSize1Y = getImageScaleForNewDimensions(images.n1, NoteSize, NoteSize)
    noteSize2X, noteSize2Y = getImageScaleForNewDimensions(images.n2, NoteSize, NoteSize)
    noteSize3X, noteSize3Y = getImageScaleForNewDimensions(images.n3, NoteSize, NoteSize)
    noteSize4X, noteSize4Y = getImageScaleForNewDimensions(images.n4, NoteSize, NoteSize)
    noteSizeK1X, noteSizeK1Y = getImageScaleForNewDimensions(images.nk, NoteSize, NoteSize)
    noteSizeK2X, noteSizeK2Y = getImageScaleForNewDimensions(images.nk, NoteSize, NoteSize)
    noteSizeK3X, noteSizeK3Y = getImageScaleForNewDimensions(images.nk, NoteSize, NoteSize)
    noteSizeK4X, noteSizeK4Y = getImageScaleForNewDimensions(images.nk, NoteSize, NoteSize)
    noteSizeKO1X, noteSizeK1Y = getImageScaleForNewDimensions(images.nko, NoteSize, NoteSize)
    noteSizeKO2X, noteSizeK2Y = getImageScaleForNewDimensions(images.nko, NoteSize, NoteSize)
    noteSizeKO3X, noteSizeK3Y = getImageScaleForNewDimensions(images.nko, NoteSize, NoteSize)
    noteSizeKO4X, noteSizeK4Y = getImageScaleForNewDimensions(images.nko, NoteSize, NoteSize)
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

    love.graphics.setFont(revamped12)
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
        love.graphics.print("testingMode enabled.",
            love.graphics.getWidth() - revamped12:getWidth("testingMode enabled."), 0)
    end
    for i, v in ipairs(plugins) do
        if v.draw then
            v.draw()
        end
    end
    love.graphics.print("FPS: " .. math.floor(1 / love.timer.getDelta()) .. "\nMemory: " .. memory .. "MB", basicSans,
        10, 3)
    if love.mouse.getX() > 10 and love.mouse.getY() > 10 and love.mouse.getX() < love.graphics.getWidth() - 10 and
        love.mouse.getY() < love.graphics.getHeight() - 10 then
        love.graphics.setColor(0, 0, 0, 127.5)
        love.graphics.circle("fill", love.mouse.getX(), love.mouse.getY(), 10)
        love.graphics.setColor(255, 255, 255)
        love.graphics.circle("line", love.mouse.getX(), love.mouse.getY(), 10)
        love.graphics.circle("line", love.mouse.getX(), love.mouse.getY(), 1)
    end
end

function love.update(dt)
    if globalCam ~= null then
        globalCam:lookAt(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    end

    memory = math.floor(collectgarbage("count") * 0.1024 + love.graphics.getStats().texturememory / 1048576)

    stateManager:update(dt)
    Flux.update(dt)

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
    if key == "f11" then
        local settings = bitser.loads(love.filesystem.read(saveFile))
        love.window.setFullscreen(not settings.fullscreen)
        local settingsSave = bitser.dumps({
            fullscreen = not settings.fullscreen,
            vsync = settings.vsync,
            bot = false
        })
        love.filesystem.write(saveFile, settingsSave)
    end
    if key == "f3" then
        testingMode = not testingMode
    end
    if key == "f2" then
        screenshot.start(screenshot)
    end
    if key == "c" then
        if love.keyboard.isDown("lctrl") then
            error("Manually initiated crash")
        end
    end
    if key == "-" then
        OpenSaveDirectory()
    end
    if key == "r" then
        love.event.quit("restart")
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

local function error_printer(msg, layer)
    print((debug.traceback("Error: " .. tostring(msg), 1 + (layer or 1)):gsub("\n[^\n]+$", "")))
end

-- function love.errorhandler(msg)
--     quackMessageBox("bruh moment", "StupidRhythm Crashed! The error has been reported. \n\n" ..
--         debug.traceback(tostring(msg), 1 + (layer or 1)):gsub("\n[^\n]+$", ""), {}, true)
-- end

function quackMessageBox(title, description, buttons, isError)
    love.window.setFullscreen(false)
    local quacker = love.audio.newSource("assets/sounds/quack.ogg", "stream")
    quacker:play()

    if isError then
        love.audio.stop()
        local quacker = love.audio.newSource("assets/sounds/quack.ogg", "stream")
        quacker:play()
        love.window.showMessageBox(title, description, {"OK"}, "error")
        love.event.quit()
    else
        love.window.showMessageBox(title, description, buttons)
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

function love.threaderror(thread, errorstr)
    print("Thread error!\n" .. errorstr)
end
