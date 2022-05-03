local beforeMenu = {}

local test = ""

function beforeMenu:update(dt)

end

function beforeMenu:enter()
    Components.button:clear()
    if currentOS ~= "Windows" then
        Components.button:new("continue", function()
            switchScene(Scenes.menu)
        end)
        Components.button:new("quit", function()
            love.event.quit()
        end)
    else
        showingLogs = false
        love.window.setMode(revamped50:getWidth(loadingText) + 100, revamped50:getHeight(loadingText) + 50, {
            vsync = true,
            resizable = false,
            borderless = true
        })
        love.mouse.setCursor(love.mouse.getSystemCursor("wait"))
        Timer.after(0.1, function()
            LogoImage = love.graphics.newImage("images/logo.png")
            screenshotThread = love.thread.newThread([[
            require("love.filesystem")
            require("love.graphics")

            love.filesystem.createDirectory("screenshots")
            if not love.filesystem.getInfo("screenshots/screenshot-" .. os.time() .. ".png") then
                love.graphics.captureScreenshot("screenshots/screenshot-" .. os.time() .. ".png")
            end
        ]])
            Components.logger.log("loaded LogoImage")
            NoteImage1 = love.graphics.newImage("images/notes/note1.png")
            Components.logger.log("loaded NoteImage1")
            NoteImage2 = love.graphics.newImage("images/notes/note2.png")
            Components.logger.log("loaded NoteImage2")
            NoteImage3 = love.graphics.newImage("images/notes/note3.png")
            Components.logger.log("loaded NoteImage3")
            NoteImage4 = love.graphics.newImage("images/notes/note4.png")
            Components.logger.log("loaded NoteImage4")
            NoteImageL = love.graphics.newImage("images/notes/notel.png")
            Components.logger.log("loaded NoteImageL")
            NoteImageH = love.graphics.newImage("images/notes/noteh.png")
            Components.logger.log("loaded NoteImageH")
            NoteImageN = love.graphics.newImage("images/notes/noten.png")
            Components.logger.log("loaded NoteImageN")
            MissImage = love.graphics.newImage("images/miss.png")
            Components.logger.log("loaded MissImage")
            CoolImage = love.graphics.newImage("images/cool.png")
            Components.logger.log("loaded CoolImage")
            scaleX1, scaleY1 = getImageScaleForNewDimensions(NoteImage1, 60, 60)
            Components.logger.log("loaded scaleX1, scaleY1")
            scaleX2, scaleY2 = getImageScaleForNewDimensions(NoteImage2, 60, 60)
            Components.logger.log("loaded scaleX2, scaleY2")
            scaleX3, scaleY3 = getImageScaleForNewDimensions(NoteImage3, 60, 60)
            Components.logger.log("loaded scaleX3, scaleY3")
            scaleX4, scaleY4 = getImageScaleForNewDimensions(NoteImage4, 60, 60)
            Components.logger.log("loaded scaleX4, scaleY4")
            scaleXL, scaleYL = getImageScaleForNewDimensions(NoteImageL, 60, 60)
            Components.logger.log("loaded scaleXL, scaleYL")
            scaleXH, scaleYH = getImageScaleForNewDimensions(NoteImageH, 60, 60)
            Components.logger.log("loaded scaleXH, scaleYH")
            scaleXN, scaleYN = getImageScaleForNewDimensions(NoteImageN, 60, 60)
            Components.logger.log("loaded scaleXN, scaleYN")
            scaleXM, scaleYM = getImageScaleForNewDimensions(MissImage, 150, 150)
            Components.logger.log("loaded scaleXM, scaleYM")
            scaleXC, scaleYC = getImageScaleForNewDimensions(CoolImage, 150, 150)
            Components.logger.log("loaded scaleXC, scaleYC")
            bg_image = love.graphics.newImage("images/sb.png")
            Components.logger.log("loaded bg_image")
            shader1 = love.graphics.newShader [[
            extern Image bgimg;

            vec4 effect(vec4 clr, Image img, vec2 imgpos, vec2 scrpos)
            {
              float alpha = Texel(img, imgpos).w * clr.w;
              vec4 bgpixel = Texel(bgimg, vec2(scrpos.x / love_ScreenSize.x, 1. - scrpos.y/love_ScreenSize.y));
              return vec4(vec3(1., 1., 1.) - bgpixel.xyz, alpha);
            }
        ]]
            Components.logger.log("loaded shader1")
            MenuSong = LoveBPM.newTrack()
            MenuSong:load("music/Press Start.ogg")
            MenuSong:on("end", function()
                MenuSong:play()
            end)
            Components.logger.log("loaded MenuSong")
            -- love.mouse.setCursor(love.mouse.newCursor("images/cursor.png",
            --     love.graphics.newImage("images/cursor.png"):getWidth() / 2,
            --     love.graphics.newImage("images/cursor.png"):getHeight() / 2))
            Components.logger.log("changed cursor")
            love.window.setIcon(love.image.newImageData(GameConfig.windowIcon))
            Components.logger.log("set icon")
            discordRPC.initialize(appId, true)
            Components.logger.log("initialized discordrpc")
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
            Timer.after(0.5, function()
                love.window.requestAttention(true)
            end)
            love.window.setMode(1280, 720, {
                vsync = GameConfig.vsync,
                resizable = true,
                borderless = false,
                fullscreen = false
            })
            Components.logger.log("window no longer borderless")
            Components.logger.log("check maximizeOnStart")
            if GameConfig.maximiseOnStart then
                love.window.maximize()
            end
            Components.logger.log("check minimizeOnStart")
            if GameConfig.minimizeOnStart then
                love.window.minimize()
            end

            Components.logger.log("check grabCursor")
            if GameConfig.grabCursor then
                love.mouse.setGrabbed(true)
            end

            Components.logger.log("check vsync")
            if GameConfig.vsync then
                love.window.setVSync(true)
            end
            Timer.after(1, function()
                switchScene(Scenes.menus.menu)
            end)
            love.window.maximize()
            showStats = true
            Components.logger.log("finished!")
            local loadTimeEnd = love.timer.getTime()
            local loadTime = (loadTimeEnd - loadTimeStart)
            Components.logger.log(("Loaded game in %.3f seconds."):format(loadTime))
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
        love.graphics.setFont(revamped50)
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(revamped32)
        love.graphics.print("Hello " .. os.getenv("USERNAME") .. "!")
        love.graphics.setColor(1, 1, 1)
    end
    Components.button:draw()
    love.graphics.setFont(revamped12)
end

return beforeMenu
