return {
    songSettings = {
        barStrum = {},
        noteSpeed = 1000, -- changes the note speed
        barSpeed = 1000, -- stupid
        noFail = false, -- no effect right now
        key1 = "x", -- key to press for noteRow1
        key2 = "c", -- key to press for noteRow2
        key3 = ",", -- key to press for noteRow3
        key4 = ".", -- key to press for noteRow4
        key1alt = "a", -- key to press for noteRow1
        key2alt = "s", -- key to press for noteRow2
        key3alt = "w", -- key to press for noteRow3
        key4alt = "d", -- key to press for noteRow4
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
        strumLine = false, -- strum line
        gridSquareWidth = 40,
        gridSquareHeight = 40,
        paused = false,
        barNotes = false, -- experimental
        bgColour = {0.1, 0.1, 0.1, 1},
        foreColour = {0.5, 0.5, 0.5, 1},
        circleThickness = 2, -- thickness of the strum circles
        lineThickness = 0, -- thickness of the line besides the strum circles
        upscroll1 = false, -- very experimental
        upscroll2 = false, -- very experimental
        upscroll3 = false, -- very experimental
        upscroll4 = false -- very experimental
    },
    fps = 120, -- ultra disables vsync if set to 0 lol
    vsync = false, -- disables fps option above if true
    grabCursor = false, -- grabs the cursor in the window
    windowIcon = "images/icon.png", -- that image you see on the window
    title = "Default Title", -- the title of the window
    extraInfoInTitle = true, -- adds extra info to the title
    maximiseOnStart = true, -- maximises the window on start
    minimizeOnStart = false, -- minimises the window on start
    loadFuncInMain = function(arg)
        love.filesystem.setIdentity("StupidRhythm-Rewritten", true)
        love.window.setTitle("StupidRhythm")

        love.graphics.setDefaultFilter("nearest", "nearest")

        Components.logger.init(StupidRhythm.name, false, "#123456")

        love.graphics.setDefaultFilter(CONFIG.graphics.filter.down, CONFIG.graphics.filter.up,
            CONFIG.graphics.filter.anisotropy)

        window = {
            translate = {
                x = 0,
                y = 0
            },
            zoom = 1
        }
        dscale = 2 ^ (1 / 6)
        k = 0
    end,
    drawFunc = function()
        local drawTimeStart = love.timer.getTime()
        gr.push()
        gr.translate(window.translate.x, window.translate.y)
        gr.scale(window.zoom)
        Components.stars:draw()
        Components.button:draw()
        Scene.current():draw()
        gr.setLineWidth(1)
        gr.pop()
        love.graphics.setFont(revamped12)
        local drawTimeEnd = love.timer.getTime()
        local drawTime = drawTimeEnd - drawTimeStart
        gr.setColour(0, 0, 0)
        if sceneThing.switching then
            love.graphics.rectangle("fill", 0, sceneThing.y, love.graphics.getWidth(),
                sceneThing.y + love.graphics.getHeight())
        end
        gr.setColour(1, 1, 1)
        if showStats then
            love.graphics.print("FPS: " .. fps(false), 5, 5)
        end
        Components.logger.draw()
    end,
    updateFunc = function(dt)
        fps(true, GameConfig.fps)
        math.randomseed(os.clock() ^ love.math.random(1, 500))
        ww = gr.getWidth()
        wh = gr.getHeight()
        mx, my = mo.getX(), mo.getY()
        if GameConfig.extraInfoInTitle then
            love.window.setTitle(GameConfig.title .. StupidRhythm.addToTitle .. " | " .. fps(false))
        else
            love.window.setTitle(GameConfig.title)
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
    end,
    loadfunction = function()
    end,
    error = {
        font = nil,
        fontSize = 16,
        background = {.1, .31, .5},
        foreground = {1, 1, 1},
        shadow = {0, 0, 0, .88},
        shadowOffset = {
            x = 1,
            y = 1
        },
        position = {
            x = 70,
            y = 70
        }
    }
}
