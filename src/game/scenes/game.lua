local game = {}

local sb = {}

sb.y = 0
sb.x = 0

local cameraStuff = {}

cameraStuff.angle = 0
cameraStuff.x = 0
cameraStuff.y = 0
cameraStuff.zoom = 1

local count = 0

function game:init()
end

function game:enter()
    local x = os.clock()
    camera = Camera(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    GameConfig.songSettings.circleStrum1.x = love.graphics.getWidth() / 2 - 110
    GameConfig.songSettings.circleStrum2.x = love.graphics.getWidth() / 2 - 110 + 70
    GameConfig.songSettings.circleStrum3.x = love.graphics.getWidth() / 2 - 110 + 70 + 70
    GameConfig.songSettings.circleStrum4.x = love.graphics.getWidth() / 2 - 110 + 70 + 70 + 70
    if GameConfig.songSettings.upscroll1 then
        GameConfig.songSettings.circleStrum1.y = 50
    else
        GameConfig.songSettings.circleStrum1.y = love.graphics.getHeight() - 50
    end
    if GameConfig.songSettings.upscroll2 then
        GameConfig.songSettings.circleStrum2.y = 50
    else
        GameConfig.songSettings.circleStrum2.y = love.graphics.getHeight() - 50
    end
    if GameConfig.songSettings.upscroll3 then
        GameConfig.songSettings.circleStrum3.y = 50
    else
        GameConfig.songSettings.circleStrum3.y = love.graphics.getHeight() - 50
    end
    if GameConfig.songSettings.upscroll4 then
        GameConfig.songSettings.circleStrum4.y = 50
    else
        GameConfig.songSettings.circleStrum4.y = love.graphics.getHeight() - 50
    end
    bg_image = love.graphics.newImage("images/sb.png")
    bg_image:setWrap("repeat", "repeat")
    bg_quad =
        love.graphics.newQuad(
            0,
            0,
            love.graphics.getWidth(),
            love.graphics.getHeight() + love.graphics.getHeight(),
            bg_image:getWidth(),
            bg_image:getHeight()
    )
    up()
    if GameConfig.songSettings.drawGrid then
        gridcanvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
        for i = 0, 200 do
            love.graphics.setCanvas(gridcanvas)
            local precolor = love.graphics.getColor()
            love.graphics.setColor(1, 1, 1, 50 / 255)
            for i2 = 0, 200 do
                love.graphics.rectangle(
                    "line",
                    i * 40,
                    i2 * 40,
                    GameConfig.songSettings.gridSquareWidth,
                    GameConfig.songSettings.gridSquareHeight
            )
            end
        end
    end
    love.graphics.setCanvas()
    if GameConfig.songSettings.circleStrumsFlying then
        Flux.to(GameConfig.songSettings.circleStrum1, 2, {y = -201}):ease("quartout")
        Flux.to(GameConfig.songSettings.circleStrum2, 2, {y = love.graphics.getHeight() + 201}):ease("quartout")
        Flux.to(GameConfig.songSettings.circleStrum3, 2, {y = -201}):ease("quartout")
        Flux.to(GameConfig.songSettings.circleStrum4, 2, {y = love.graphics.getHeight() + 201}):ease("quartout")
    end
    if GameConfig.songSettings.circleStrumsFloating then
        floatUp()
    end
    file = love.filesystem.read("songs/" .. song .. "/chart.lua")
    data = Lume.deserialize(file)
    -- music = LoveBPM.newTrack()
    -- music:load("songs/" .. song .. "/song.ogg")
    -- music:setBPM(data.bpm)
    -- music:on(
    --     "beat",
    --     function(n)
    --         count = count + 1
    --         if count == 4 then
    --             -- cameraStuff.zoom = 0.99
    --             -- Flux.to(cameraStuff, 1, {zoom = 1}):ease("quartout")
    --             count = 0
    --         end
    --     end
    -- )
    -- music:play()
    presence = {
        state = "",
        details = StupidRhythm.fullname .. " | in game",
        startTimestamp = now,
        endTimestamp = now + 1290190
    }
    print(string.format("load time: %.2fs", os.clock() - x))
-- end
end

function floatUp()
    Flux.to(GameConfig.songSettings.circleStrum1, 1, {y = love.graphics.getHeight() - 150}):ease("quartout")
    Flux.to(GameConfig.songSettings.circleStrum2, 1, {y = love.graphics.getHeight() - 150}):ease("quartout"):delay(0.1)
    Flux.to(GameConfig.songSettings.circleStrum3, 1, {y = love.graphics.getHeight() - 150}):ease("quartout"):delay(0.2)
    Flux.to(GameConfig.songSettings.circleStrum4, 1, {y = love.graphics.getHeight() - 150}):ease("quartout"):delay(0.3):oncomplete(
        floatDown
)
end

function floatDown()
    Flux.to(GameConfig.songSettings.circleStrum1, 1, {y = love.graphics.getHeight() - 50}):ease("quartout")
    Flux.to(GameConfig.songSettings.circleStrum2, 1, {y = love.graphics.getHeight() - 50}):ease("quartout"):delay(0.1)
    Flux.to(GameConfig.songSettings.circleStrum3, 1, {y = love.graphics.getHeight() - 50}):ease("quartout"):delay(0.2)
    Flux.to(GameConfig.songSettings.circleStrum4, 1, {y = love.graphics.getHeight() - 50}):ease("quartout"):delay(0.3):oncomplete(
        floatUp
)
end

function up()
    if GameConfig.songSettings.tweenSB then
        Flux.to(
            sb,
            5,
            {
                y = love.graphics.getHeight() - love.graphics.getHeight() - love.graphics.getHeight()
            }
        ):ease("quartinout"):oncomplete(down)
    end
end

function down()
    if GameConfig.songSettings.tweenSB then
        Flux.to(sb, 5, {y = 0}):ease("quartinout"):oncomplete(up)
    end
end

function game:update(dt)
    camera:zoomTo(cameraStuff.zoom)
    Components.note:update(dt)
    music:update(dt)
    camera:rotateTo(cameraStuff.angle)
    if GameConfig.songSettings.circleStrumsFlying then
        if GameConfig.songSettings.circleStrum4.y > love.graphics.getHeight() + 200 then
            GameConfig.songSettings.circleStrum4.y = -200
            Flux.to(GameConfig.songSettings.circleStrum4, 2, {y = love.graphics.getHeight() + 201}):ease("quartout")
        end
        if GameConfig.songSettings.circleStrum3.y < -200 then
            GameConfig.songSettings.circleStrum3.y = love.graphics.getHeight() + 200
            Flux.to(GameConfig.songSettings.circleStrum3, 2, {y = -201}):ease("quartout")
        end
        if GameConfig.songSettings.circleStrum2.y > love.graphics.getHeight() + 200 then
            GameConfig.songSettings.circleStrum2.y = -200
            Flux.to(GameConfig.songSettings.circleStrum2, 2, {y = love.graphics.getHeight() + 201}):ease("quartout")
        end
        if GameConfig.songSettings.circleStrum1.y < -200 then
            GameConfig.songSettings.circleStrum1.y = love.graphics.getHeight() + 200
            Flux.to(GameConfig.songSettings.circleStrum1, 2, {y = -201}):ease("quartout")
        end
    end
    if dumb then
        if love.keyboard.isDown(GameConfig.songSettings.key1, GameConfig.songSettings.key1alt) then
            Components.note:spawnNote(1, 0)
        end
        if love.keyboard.isDown(GameConfig.songSettings.key2, GameConfig.songSettings.key2alt) then
            Components.note:spawnNote(2, 0)
        end
        if love.keyboard.isDown(GameConfig.songSettings.key3, GameConfig.songSettings.key3alt) then
            Components.note:spawnNote(3, 0)
        end
        if love.keyboard.isDown(GameConfig.songSettings.key4, GameConfig.songSettings.key4alt) then
            Components.note:spawnNote(4, 0)
        end
        if GameConfig.songSettings.barNotes then
            if love.keyboard.isDown("space") then
                Components.note:spawnBar(0)
            end
        end
    end
end

function game:keypressed(key, code)
    if not GameConfig.songSettings.paused then
        if not chartingMode then
            if key == GameConfig.songSettings.key1 or key == GameConfig.songSettings.key1alt then
                
                for i, note in ipairs(noteRow1) do
                    if note.y >= GameConfig.songSettings.circleStrum1.y - 150 then
                        table.remove(noteRow1, i)
                    end
                end
                Flux.to(
                    GameConfig.songSettings.circleStrum1,
                    0.05,
                    {curRadius = GameConfig.songSettings.circleStrum1.radiusPressed}
                ):ease("quartout"):after(
                    GameConfig.songSettings.circleStrum1,
                    0.5,
                    {curRadius = GameConfig.songSettings.circleStrum1.radiusReleased}
                ):ease("quartout")
            end
            if key == GameConfig.songSettings.key2 or key == GameConfig.songSettings.key2alt then
                
                for i, note in ipairs(noteRow2) do
                    if note.y >= GameConfig.songSettings.circleStrum2.y - 150 then
                        table.remove(noteRow2, i)
                    end
                end
                Flux.to(
                    GameConfig.songSettings.circleStrum2,
                    0.05,
                    {curRadius = GameConfig.songSettings.circleStrum2.radiusPressed}
                ):ease("quartout"):after(
                    GameConfig.songSettings.circleStrum2,
                    0.5,
                    {curRadius = GameConfig.songSettings.circleStrum2.radiusReleased}
                ):ease("quartout")
            end
            if key == GameConfig.songSettings.key3 or key == GameConfig.songSettings.key3alt then
                
                for i, note in ipairs(noteRow3) do
                    if note.y >= GameConfig.songSettings.circleStrum3.y - 150 then
                        table.remove(noteRow3, i)
                    end
                end
                Flux.to(
                    GameConfig.songSettings.circleStrum3,
                    0.05,
                    {curRadius = GameConfig.songSettings.circleStrum3.radiusPressed}
                ):ease("quartout"):after(
                    GameConfig.songSettings.circleStrum3,
                    0.5,
                    {curRadius = GameConfig.songSettings.circleStrum3.radiusReleased}
                ):ease("quartout")
            end
            if key == GameConfig.songSettings.key4 or key == GameConfig.songSettings.key4alt then
                
                for i, note in ipairs(noteRow4) do
                    if note.y >= GameConfig.songSettings.circleStrum4.y - 150 then
                        table.remove(noteRow4, i)
                    end
                end
                Flux.to(
                    GameConfig.songSettings.circleStrum4,
                    0.05,
                    {curRadius = GameConfig.songSettings.circleStrum4.radiusPressed}
                ):ease("quartout"):after(
                    GameConfig.songSettings.circleStrum4,
                    0.5,
                    {curRadius = GameConfig.songSettings.circleStrum4.radiusReleased}
                ):ease("quartout")
            end
            if key == "space" then
                if GameConfig.songSettings.barNotes then
                    
                    for i, bar in ipairs(noteBarRow) do
                        if bar.y >= GameConfig.songSettings.circleStrum1.y - 150 then
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
        if key == GameConfig.songSettings.key1 or key == GameConfig.songSettings.key1alt then
            Components.note:spawnNote(1, 0)
        -- Components.note:spawnSliderNote(1, 1)
        end
        if key == GameConfig.songSettings.key2 or key == GameConfig.songSettings.key2alt then
            Components.note:spawnNote(2, 0)
        -- Components.note:spawnSliderNote(2, 1)
        end
        if key == GameConfig.songSettings.key3 or key == GameConfig.songSettings.key3alt then
            Components.note:spawnNote(3, 0)
        -- Components.note:spawnSliderNote(3, 1)
        end
        if key == GameConfig.songSettings.key4 or key == GameConfig.songSettings.key4alt then
            Components.note:spawnNote(4, 0)
        -- Components.note:spawnSliderNote(4, 1)
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
        MenuSong:play()
        Scene.switch(Scenes.menu)
    end
end

function game:mousepressed(x, y, mbutton)
end

function game:draw()
    love.graphics.setBackgroundColor(unpack(GameConfig.songSettings.bgColour))
    if GameConfig.songSettings.drawSB then
        love.graphics.draw(bg_image, bg_quad, sb.x, sb.y)
    end
    if GameConfig.songSettings.drawGrid then
        love.graphics.draw(gridcanvas)
    end
    camera:attach()
    Components.hud:draw()
    Components.note:draw()
    camera:detach()
    if chartingMode then
        gr.setColour(1, 1, 1)
        love.graphics.roundrectangle("fill", 4, 4, 402, wh - 8, 30)
        gr.setColour(0, 0, 0)
        love.graphics.roundrectangle("fill", 5, 5, 400, wh - 10, 30)
    end
end

function game:resize()
    bg_quad =
        love.graphics.newQuad(
            0,
            0,
            love.graphics.getWidth(),
            love.graphics.getHeight() + love.graphics.getHeight(),
            bg_image:getWidth(),
            bg_image:getHeight()
    )
    camera = Camera(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    if GameConfig.songSettings.upscroll1 then
        GameConfig.songSettings.circleStrum1.y = 50
    else
        GameConfig.songSettings.circleStrum1.y = love.graphics.getHeight() - 50
    end
    if GameConfig.songSettings.upscroll2 then
        GameConfig.songSettings.circleStrum2.y = 50
    else
        GameConfig.songSettings.circleStrum2.y = love.graphics.getHeight() - 50
    end
    if GameConfig.songSettings.upscroll3 then
        GameConfig.songSettings.circleStrum3.y = 50
    else
        GameConfig.songSettings.circleStrum3.y = love.graphics.getHeight() - 50
    end
    if GameConfig.songSettings.upscroll4 then
        GameConfig.songSettings.circleStrum4.y = 50
    else
        GameConfig.songSettings.circleStrum4.y = love.graphics.getHeight() - 50
    end
end

return game
