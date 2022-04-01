local game = {}

local cameraZoom = {}

local count = 0

local reverseBeat = true

cameraZoom.zoom = 1

function game:init() end

function game:enter()
    local start = love.timer.getTime()
    GameVars.inputPlace.y = love.graphics.getHeight() - 50
    GameVars.inputPlace2.y = love.graphics.getHeight() - 50
    GameVars.inputPlace3.y = love.graphics.getHeight() - 50
    GameVars.inputPlace4.y = love.graphics.getHeight() - 50
    GameVars.inputPlace5.y = love.graphics.getHeight() - 50
    GameVars.inputPlace6.y = love.graphics.getHeight() - 50
    GameVars.inputPlace7.y = love.graphics.getHeight() - 50
    GameVars.inputPlace8.y = love.graphics.getHeight() - 50
    GameVars.inputPlace.x = love.graphics.getWidth() / 2 - 110
    GameVars.inputPlace2.x = love.graphics.getWidth() / 2 - 40
    GameVars.inputPlace3.x = love.graphics.getWidth() / 2 + 40
    GameVars.inputPlace4.x = love.graphics.getWidth() / 2 + 110
    GameVars.inputPlace5.x = love.graphics.getWidth() / 2 - 110 - 500
    GameVars.inputPlace6.x = love.graphics.getWidth() / 2 - 40 - 500
    GameVars.inputPlace7.x = love.graphics.getWidth() / 2 + 40 - 500
    GameVars.inputPlace8.x = love.graphics.getWidth() / 2 + 110 - 500
    GameVars.inputPlace.size = 30
    GameVars.inputPlace2.size = 30
    GameVars.inputPlace3.size = 30
    GameVars.inputPlace4.size = 30
    GameVars.inputPlace5.size = 30
    GameVars.inputPlace6.size = 30
    GameVars.inputPlace7.size = 30
    GameVars.inputPlace8.size = 30
    camera = Camera()
    Song = LoveBPM.newTrack()
    Song:load("assets/songs/" .. GameVars.song.name .. "/song.mp3")
    Song:setBPM(GameVars.song.bpm)
    Song:play()
    Song:on("beat", function(n)
        -- print("step:", n, "count:", count)
        count = count + 1
        if count == 4 then
            count = 0
            if reverseBeat then
                cameraZoom.zoom = 0.99
                Timer.tween(0.5, cameraZoom, {zoom = 1}, 'out-quad')
            else
                cameraZoom.zoom = 1
                Timer.tween(0.5, cameraZoom, {zoom = 0.99}, 'out-quad')
            end
        end
    end)
    Song:on("end", function(n)
        Timer.clear()
        State.switch(States.menu)
    end)
    Result = love.timer.getTime() - start
end

function game:update(dt)
    Components.note:update(dt)
    Components.inputs:update(dt)
    camera:zoomTo(cameraZoom.zoom)
    Song:update()
    if GameVars.second then
        Components.note:newNote(5, 0)
        Components.note:newNote(6, 0)
        Components.note:newNote(7, 0)
        Components.note:newNote(8, 0)
    end
end

function game:keypressed(key)
    Components.inputs:keypressed(key)
    if key == "space" then
        if not GameVars.paused then
            GameVars.paused = true
            Song:pause()
        else
            GameVars.paused = false
            Song:play(false)
        end
    end
    if key == "b" then
        Song:stop()
        Timer.clear()
        GameVars.second = false
        GameVars.song.bpm = 0
        GameVars.song.name = ""
        State.switch(States.menu)
    end
end

function game:mousepressed(x, y, mbutton) end

function game:draw()
    Graphics.setColor(1, 1, 1)
    camera:attach()
    Components.note:draw()
    Components.huds.hudCircles:draw()
    Components.huds.hudOther:draw()
    Components.huds.hudLines:draw()
    camera:detach()
    Components.huds.hudLinesOutLines:draw()
    love.graphics.print(Song:getTime() .. " | " .. os.date("%X", os.time()),
                        love.graphics.getWidth() / 2, 0)
    love.graphics.draw(cursor, love.mouse.getX() - 7, love.mouse.getY() - 7)
    love.graphics.print(string.format("%.3f", Result * 1000), 343, 0)
end

function game:resize(w, h)
    camera = Camera()
    GameVars.inputPlace.y = love.graphics.getHeight() - 50
    GameVars.inputPlace2.y = love.graphics.getHeight() - 50
    GameVars.inputPlace3.y = love.graphics.getHeight() - 50
    GameVars.inputPlace4.y = love.graphics.getHeight() - 50
    GameVars.inputPlace5.y = love.graphics.getHeight() - 50
    GameVars.inputPlace6.y = love.graphics.getHeight() - 50
    GameVars.inputPlace7.y = love.graphics.getHeight() - 50
    GameVars.inputPlace8.y = love.graphics.getHeight() - 50
    GameVars.inputPlace.x = love.graphics.getWidth() / 2 - 110
    GameVars.inputPlace2.x = love.graphics.getWidth() / 2 - 40
    GameVars.inputPlace3.x = love.graphics.getWidth() / 2 + 40
    GameVars.inputPlace4.x = love.graphics.getWidth() / 2 + 110
    GameVars.inputPlace5.x = love.graphics.getWidth() / 2 - 110 - 500
    GameVars.inputPlace6.x = love.graphics.getWidth() / 2 - 40 - 500
    GameVars.inputPlace7.x = love.graphics.getWidth() / 2 + 40 - 500
    GameVars.inputPlace8.x = love.graphics.getWidth() / 2 + 110 - 500
end

return game
