local beforeMenu = {}

local test = ""

function beforeMenu:update(dt)

end

function beforeMenu:enter()
    Components.button:clear()
    if currentOS ~= "Windows" then
        Components.button:new("continue", function()
            Scene.switch(Scenes.menu)
        end)
        Components.button:new("quit", function()
            exitGame()
        end)
    else
        showingLogs = false
        Timer.after(0.5, function()
            LogoImage = love.graphics.newImage("images/logo.png")
            NoteImage1 = love.graphics.newImage("images/note1.png")
            NoteImage2 = love.graphics.newImage("images/note2.png")
            NoteImage3 = love.graphics.newImage("images/note3.png")
            NoteImage4 = love.graphics.newImage("images/note4.png")
            scaleX1, scaleY1 = getImageScaleForNewDimensions(NoteImage1, 60, 60)
            scaleX2, scaleY2 = getImageScaleForNewDimensions(NoteImage2, 60, 60)
            scaleX3, scaleY3 = getImageScaleForNewDimensions(NoteImage3, 60, 60)
            scaleX4, scaleY4 = getImageScaleForNewDimensions(NoteImage4, 60, 60)
            MenuSong = LoveBPM.newTrack()
            MenuSong:load("music/Kaiolyn – Press Start [Synthwave] 🎵 from Royalty Free Planet™.ogg")
            MenuSong:on("end", function()
                MenuSong:play()
            end)
            love.window.setIcon(love.image.newImageData(GameConfig.windowIcon))
            discordRPC.initialize(appId, true)
            now = os.time(os.date("*t"))
            presence = {
                state = "",
                details = StupidRhythm.fullname .. " | in menus",
                startTimestamp = now,
                endTimestamp = now + 1290190
            }
            nextPresenceUpdate = 0
            if currentOS == "Android" or currentOS == "iOS" then
                onMobile = true
                love.window.setFullscreen(true)
            end
            if DEBUG then
                if not onMobile then
                    love._openConsole()
                end
            end
            Timer.after(0.5, function()
                love.window.requestAttention(true)
            end)
            if GameConfig.maximiseOnStart then
                love.window.maximize()
            end

            if GameConfig.minimizeOnStart then
                love.window.minimize()
            end

            if GameConfig.grabCursor then
                love.mouse.setGrabbed(true)
            end

            if GameConfig.vsync then
                love.window.setVSync(true)
            end
            local files = getFiles('music')
            for i, file in ipairs(files) do
                if not love.filesystem.isDirectory(file) then
                    if not string.find(file, ".lua") then
                        music = LoveBPM.newTrack()
                        music:load(file)
                        music:play()
                    end
                end
            end
            song = "A Fool Moon Night"
            bpm = 138
            Scene.switch(Scenes.game)
            for i = 1, 10 do
                wi.setMode(1280, 720, {
                    vsync = false,
                    resizable = true
                })
            end
            love.window.maximize()
        end)
    end
end

function getFiles(rootPath, tree)
    tree = tree or {}
    local lfs = love.filesystem
    local filesTable = lfs.getDirectoryItems(rootPath)
    for i, v in ipairs(filesTable) do
        local path = rootPath .. "/" .. v
        if lfs.isFile(path) then
            tree[#tree + 1] = path
        elseif lfs.isDirectory(path) then
            fileTree = getFiles(path, tree)
        end
    end
    return tree
end

function beforeMenu:keypressed(key)
end

function beforeMenu:draw()
    gr.setBackgroundColor(0.1, 0.1, 0.1)
    if currentOS ~= "Windows" then
        Components.stars:draw()
        gr.print("Warning!\nYou are on " .. currentOS .. "." .. " And " .. StupidRhythm.name ..
                     " may not be compatible with your current OS!", ww / 2 - 100, 300)
    else
        Components.loading:draw()
    end
    Components.button:draw()
end

return beforeMenu
