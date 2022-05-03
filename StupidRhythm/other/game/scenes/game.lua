local game = {}

local sb = {}

local utf8 = require("utf8")

sb.y = 0
sb.x = 0

local cameraStuff = {}

cameraStuff.angle = 0
cameraStuff.x = 0
cameraStuff.y = 0
cameraStuff.zoom = 1

local count = 0

local tweenGroup = Flux.group()

function game:init()
end

function game:enter()
    cameraStuff.angle = 0
    cameraStuff.x = 0
    cameraStuff.y = 0
    cameraStuff.zoom = 1
    local x = os.clock()
    camera = Camera()
    noteRow1Cam = Camera(love.graphics.getWidth() / 2 - 120)
    noteRow2Cam = Camera(love.graphics.getWidth() / 2 - 120 - 70)
    noteRow3Cam = Camera(love.graphics.getWidth() / 2 - 120 - 70 - 70)
    noteRow4Cam = Camera(love.graphics.getWidth() / 2 - 120 - 70 - 70 - 70)
    -- circleStrum1.x = 0
    -- circleStrum2.x = 0
    -- circleStrum3.x = 0
    -- circleStrum4.x = 0
    if GameConfig.songSettings.upscroll1 then
        circleStrum1.y = 50
    else
        circleStrum1.y = love.graphics.getHeight() - 50
    end
    if GameConfig.songSettings.upscroll2 then
        circleStrum2.y = 50
    else
        circleStrum2.y = love.graphics.getHeight() - 50
    end
    if GameConfig.songSettings.upscroll3 then
        circleStrum3.y = 50
    else
        circleStrum3.y = love.graphics.getHeight() - 50
    end
    if GameConfig.songSettings.upscroll4 then
        circleStrum4.y = 50
    else
        circleStrum4.y = love.graphics.getHeight() - 50
    end
    bg_image:setWrap("repeat", "repeat")
    bg_quad = love.graphics.newQuad(0, 0, love.graphics.getWidth(),
        love.graphics.getHeight() + love.graphics.getHeight(), bg_image:getWidth(), bg_image:getHeight())
    tweenSB()
    if GameConfig.songSettings.drawGrid then
        gridcanvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
        for i = 0, 200 do
            love.graphics.setCanvas(gridcanvas)
            local precolor = love.graphics.getColor()
            love.graphics.setColor(1, 1, 1, 50 / 255)
            for i2 = 0, 200 do
                love.graphics.rectangle("line", i * 40, i2 * 40, GameConfig.songSettings.gridSquareWidth,
                    GameConfig.songSettings.gridSquareHeight)
            end
        end
    end
    love.graphics.setCanvas()
    if circleStrumsFlying then
        tweenGroup:to(circleStrum1, 2, {
            y = -201
        }):ease("quartout")
        tweenGroup:to(circleStrum2, 2, {
            y = love.graphics.getHeight() + 201
        }):ease("quartout")
        tweenGroup:to(circleStrum3, 2, {
            y = -201
        }):ease("quartout")
        tweenGroup:to(circleStrum4, 2, {
            y = love.graphics.getHeight() + 201
        }):ease("quartout")
    end
    if circleStrumsFloating then
        floatUp()
    end
    -- data = love.filesystem.load("songs/" .. song .. "/song.lua")
    bg = love.graphics.newImage("songs/" .. song .. "/bg.png")
    music = LoveBPM.newTrack()
    music:load("songs/" .. song .. "/song.ogg")
    -- music:setBPM(data.bpm)
    music:on("beat", function(n)
        count = count + 1
        if count == 4 then
            cameraStuff.zoom = 0.99
            tweenGroup:to(cameraStuff, 1, {zoom = 1}):ease("quartout")
            count = 0
        end
    end)
    music:play()
    presence = {
        state = "",
        details = StupidRhythm.fullname .. " | in game",
        startTimestamp = now,
        endTimestamp = now + 1290190
    }
    Components.logger.log(string.format("load time: %.2fs", os.clock() - x))
end

function tweenSB()
    function up()
        if GameConfig.songSettings.tweenSB then
            tweenGroup:to(sb, 5, {
                y = love.graphics.getHeight() - love.graphics.getHeight() - love.graphics.getHeight()
            }):ease("quartinout"):oncomplete(down)
        end
    end

    function down()
        if GameConfig.songSettings.tweenSB then
            tweenGroup:to(sb, 5, {
                y = 0
            }):ease("quartinout"):oncomplete(up)
        end
    end
    up()
end

function game:update(dt)
    if love.keyboard.isDown("6") and love.keyboard.isDown("lctrl") then
        cameraStuff.angle = cameraStuff.angle - 5 * dt
    end
    if love.keyboard.isDown("7") and love.keyboard.isDown("lctrl") then
        cameraStuff.angle = cameraStuff.angle + 5 * dt
    end
    scaleXBG, scaleYBG = getImageScaleForNewDimensions(bg, love.graphics.getWidth(), love.graphics.getHeight())
    for i, v in ipairs(ratingThing) do
        v.y = v.y - v.speed * dt
        v.x = v.x + 1
        v.speed = v.speed - 1500 * dt
        if v.y > love.graphics.getHeight() then
            table.remove(ratingThing, i)
        end
    end
    tweenGroup:update(dt)
    camera:move(cameraStuff.x, cameraStuff.y):rotateTo(cameraStuff.angle):zoomTo(cameraStuff.zoom)
    if health >= 50 then
        health = health - 100 * dt
    end
    circleStrum1.y = love.graphics.getHeight() - 50
    circleStrum2.y = love.graphics.getHeight() - 50
    circleStrum3.y = love.graphics.getHeight() - 50
    circleStrum4.y = love.graphics.getHeight() - 50
    if health <= 0 then
        health = 19
        presence = {
            state = "",
            details = StupidRhythm.fullname .. " | in menus | " .. #noteRow1 .. " | " .. #noteRow2 .. " | " .. #noteRow3 ..
                " | " .. #noteRow4,
            startTimestamp = now,
            endTimestamp = now + 1290190
        }
        love.audio.stop()
        noteRow1 = {}
        noteRow2 = {}
        noteRow3 = {}
        noteRow4 = {}
        noteSliderRow1 = {}
        noteSliderRow2 = {}
        noteSliderRow3 = {}
        noteSliderRow4 = {}
        -- MenuSong:play()
        Timer.clear()
        Flux.remove()
        love.timer.sleep(2)
        Scene.switch(Scenes.gameOver)
    end
    if health >= healthMax then
        health = healthMax
    end
    Components.note:update(dt)
    music:update(dt)
    if circleStrumsFlying then
        if circleStrum4.y > love.graphics.getHeight() + 200 then
            circleStrum4.y = -200
            tweenGroup:to(circleStrum4, 2, {
                y = love.graphics.getHeight() + 201
            }):ease("quartout")
        end
        if circleStrum3.y < -200 then
            circleStrum3.y = love.graphics.getHeight() + 200
            tweenGroup:to(circleStrum3, 2, {
                y = -201
            }):ease("quartout")
        end
        if circleStrum2.y > love.graphics.getHeight() + 200 then
            circleStrum2.y = -200
            tweenGroup:to(circleStrum2, 2, {
                y = love.graphics.getHeight() + 201
            }):ease("quartout")
        end
        if circleStrum1.y < -200 then
            circleStrum1.y = love.graphics.getHeight() + 200
            tweenGroup:to(circleStrum1, 2, {
                y = -201
            }):ease("quartout")
        end
    end
    if dumb then
        if love.keyboard.isDown(GameConfig.songSettings.key1, GameConfig.songSettings.key1alt, "left") then
            Components.note:spawnNote(1, 0)
        end
        if love.keyboard.isDown(GameConfig.songSettings.key2, GameConfig.songSettings.key2alt, "down") then
            Components.note:spawnNote(2, 0)
        end
        if love.keyboard.isDown(GameConfig.songSettings.key3, GameConfig.songSettings.key3alt, "up") then
            Components.note:spawnNote(3, 0)
        end
        if love.keyboard.isDown(GameConfig.songSettings.key4, GameConfig.songSettings.key4alt, "right") then
            Components.note:spawnNote(4, 0)
        end
        if GameConfig.songSettings.barNotes then
            if love.keyboard.isDown("space") then
                Components.note:spawnBar(0)
            end
        end
    else
        -- if love.keyboard.isDown(GameConfig.songSettings.key1, GameConfig.songSettings.key1alt) then
        --     Components.note:spawnSliderNote(1, 0, 0)
        --     -- key1 = "left", -- key to press for noteRow1
        --     -- key2 = "down", -- key to press for noteRow2
        --     -- key3 = "up", -- key to press for noteRow3
        --     -- key4 = "right", -- key to press for noteRow4
        --     -- key1alt = "a", -- key to press for noteRow1
        --     -- key2alt = "s", -- key to press for noteRow2
        --     -- key3alt = "w", -- key to press for noteRow3,
        --     -- key4alt = "d", -- key to press for noteRow4
        -- end
        -- if love.keyboard.isDown(GameConfig.songSettings.key2, GameConfig.songSettings.key2alt) then
        --     Components.note:spawnSliderNote(2, 0, 0)
        -- end
        -- if love.keyboard.isDown(GameConfig.songSettings.key3, GameConfig.songSettings.key3alt) then
        --     Components.note:spawnSliderNote(3, 0, 0)
        -- end
        -- if love.keyboard.isDown(GameConfig.songSettings.key4, GameConfig.songSettings.key4alt) then
        --     Components.note:spawnSliderNote(4, 0, 0)
        -- end
    end
end

function game:keypressed(key, code)
    if not GameConfig.songSettings.paused then
        if not RELEASE then
            if key == GameConfig.songSettings.key1s or key == GameConfig.songSettings.key1salt then
                Components.note:spawnNote(1, 0)
            end
            if key == GameConfig.songSettings.key2s or key == GameConfig.songSettings.key2salt then
                Components.note:spawnNote(2, 0)
            end
            if key == GameConfig.songSettings.key3s or key == GameConfig.songSettings.key3salt then
                Components.note:spawnNote(3, 0)
            end
            if key == GameConfig.songSettings.key4s or key == GameConfig.songSettings.key4salt then
                Components.note:spawnNote(4, 0)
            end
        end
        if not chartingMode then
            if key == GameConfig.songSettings.key1 or key == GameConfig.songSettings.key1alt or key == "left" then
                for i, note in ipairs(noteRow1) do
                    if note.y >= circleStrum1.y - 150 then
                        table.remove(noteRow1, i)
                        coolNoteHit(10)
                    end
                end
                tweenGroup:to(circleStrum1, 0.05, {
                    curRadius = circleStrum1.radiusPressed
                }):ease("quartout"):after(circleStrum1, 0.5, {
                    curRadius = circleStrum1.radiusReleased
                }):ease("quartout")
            end
            if key == GameConfig.songSettings.key2 or key == GameConfig.songSettings.key2alt or key == "down" then
                for i, note in ipairs(noteRow2) do
                    if note.y >= circleStrum2.y - 150 then
                        table.remove(noteRow2, i)
                        coolNoteHit(10)
                    end
                end
                tweenGroup:to(circleStrum2, 0.05, {
                    curRadius = circleStrum2.radiusPressed
                }):ease("quartout"):after(circleStrum2, 0.5, {
                    curRadius = circleStrum2.radiusReleased
                }):ease("quartout")
            end
            if key == GameConfig.songSettings.key3 or key == GameConfig.songSettings.key3alt or key == "up" then
                for i, note in ipairs(noteRow3) do
                    if note.y >= circleStrum3.y - 150 then
                        table.remove(noteRow3, i)
                        coolNoteHit(10)
                    end
                end
                tweenGroup:to(circleStrum3, 0.05, {
                    curRadius = circleStrum3.radiusPressed
                }):ease("quartout"):after(circleStrum3, 0.5, {
                    curRadius = circleStrum3.radiusReleased
                }):ease("quartout")
            end
            if key == GameConfig.songSettings.key4 or key == GameConfig.songSettings.key4alt or key == "right" then
                for i, note in ipairs(noteRow4) do
                    if note.y >= circleStrum4.y - 150 then
                        table.remove(noteRow4, i)
                        coolNoteHit(10)
                    end
                end
                tweenGroup:to(circleStrum4, 0.05, {
                    curRadius = circleStrum4.radiusPressed
                }):ease("quartout"):after(circleStrum4, 0.5, {
                    curRadius = circleStrum4.radiusReleased
                }):ease("quartout")
            end
            if key == "space" then
                if GameConfig.songSettings.barNotes then
                    for i, bar in ipairs(noteBarRow) do
                        if bar.y >= circleStrum1.y - 150 then
                            table.remove(noteBarRow, i)
                        end
                    end
                end
            end
        end
    end
    if key == "i" then
        if not chartingMode then
            chartingMode = true
        else
            chartingMode = false
        end
        dumb = false
    end
    if key == "return" then
        if not GameConfig.songSettings.paused then
            music:pause()
            GameConfig.songSettings.paused = true
        else
            music:play(false)
            GameConfig.songSettings.paused = false
        end
    end
    if key == "p" then
        if chartingMode then
            if not dumb then
                dumb = true
            else
                dumb = false
            end
        end
    end
    if chartingMode then
        if key == GameConfig.songSettings.key1 or key == GameConfig.songSettings.key1alt or key == "left" then
            Components.note:spawnNote(1, 0)
        end
        if key == GameConfig.songSettings.key2 or key == GameConfig.songSettings.key2alt or key == "down" then
            Components.note:spawnNote(2, 0)
        end
        if key == GameConfig.songSettings.key3 or key == GameConfig.songSettings.key3alt or key == "up" then
            Components.note:spawnNote(3, 0)
        end
        if key == GameConfig.songSettings.key4 or key == GameConfig.songSettings.key4alt or key == "right" then
            Components.note:spawnNote(4, 0)
        end
        if key == "space" then
            if GameConfig.songSettings.barNotes then
                Components.note:spawnBar(0)
            end
        end
    end
    if key == "b" then
        presence = {
            state = "",
            details = StupidRhythm.fullname .. " | in menus",
            startTimestamp = now,
            endTimestamp = now + 1290190
        }
        love.audio.stop()
        noteRow1 = {}
        noteRow2 = {}
        noteRow3 = {}
        noteRow4 = {}
        noteSliderRow1 = {}
        noteSliderRow2 = {}
        noteSliderRow3 = {}
        noteSliderRow4 = {}
        -- MenuSong:play()
        Timer.clear()
        Flux.remove()
        switchScene(Scenes.menus.menu)
    end
    if key == "r" then
        love.audio.stop()
        noteRow1 = {}
        noteRow2 = {}
        noteRow3 = {}
        noteRow4 = {}
        noteSliderRow1 = {}
        noteSliderRow2 = {}
        noteSliderRow3 = {}
        noteSliderRow4 = {}
        Timer.clear()
        startGame(song)
    end
end

function game:mousepressed(x, y, mbutton)
end

function game:draw()
    love.graphics.setBackgroundColor(unpack(GameConfig.songSettings.bgColour))
    -- effect(function()
    if GameConfig.songSettings.drawSB then
        love.graphics.draw(bg_image, bg_quad, sb.x, sb.y)
    end
    love.graphics.draw(bg, 0, 0, 0, scaleXBG, scaleYBG)
    love.graphics.setColor(0, 0, 0, 0.9)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1)
    if GameConfig.songSettings.drawGrid then
        love.graphics.draw(gridcanvas)
    end
    camera:attach()
    Components.playPlace:draw()
    for i, v in ipairs(ratingThing) do
        love.graphics.setColor(v.colour, v.alpha)
        if v.type == "miss" then
            love.graphics.draw(MissImage, v.x, v.y, 0, scaleXM, scaleYM)
        elseif v.type == "cool" then
            love.graphics.draw(CoolImage, v.x, v.y, 0, scaleXC, scaleYC)
        end
        love.graphics.setColor(1, 1, 1, 1)
    end
    camera:detach()
    -- end)
    -- if chartingMode then
    --     love.graphics.circle("line", GameConfig.songSettings.circleNoteSpawn1.x,
    --         GameConfig.songSettings.circleNoteSpawn1.y, 30)
    --     love.graphics.circle("line", circleStrum2.x, circleStrum2.y,
    --         circleStrum2.curRadius)
    --     love.graphics.circle("line", circleStrum3.x, circleStrum3.y,
    --         circleStrum3.curRadius)
    --     love.graphics.circle("line", circleStrum4.x, circleStrum4.y,
    --         circleStrum4.curRadius)
    --     gr.setColour(1, 1, 1)
    --     love.graphics.rectangle("fill", 4, 4, 402, wh - 8, 30)
    --     gr.setColour(0, 0, 0)
    --     love.graphics.rectangle("fill", 5, 5, 400, wh - 10, 30)
    --     gr.setColour(1, 1, 1)
    --     love.graphics.printf("CHARTING MODE", 400, 20, 200, "center")
    --     love.graphics.line(5, 40, 402, 40)
    -- end
end

function game:resize()
    bg_quad = love.graphics.newQuad(0, 0, love.graphics.getWidth(),
        love.graphics.getHeight() + love.graphics.getHeight(), bg_image:getWidth(), bg_image:getHeight())
    camera = Camera()
    noteRow1Cam = Camera(love.graphics.getWidth() / 2 - 120)
    noteRow2Cam = Camera(love.graphics.getWidth() / 2 - 120 - 70)
    noteRow3Cam = Camera(love.graphics.getWidth() / 2 - 120 - 70 - 70)
    noteRow4Cam = Camera(love.graphics.getWidth() / 2 - 120 - 70 - 70 - 70)
end

return game
