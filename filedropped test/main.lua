local music = nil
local fileName = ""

love.window.setMode(1000, 500, {
    borderless = true
})

function love.filedropped(file)
    print("Detected filedropped!\nFileName: " .. file:getFilename())
    fileName = file:getFilename()
    if music ~= nil then
        music:stop()
    end
    music = love.audio.newSource(file, "stream")
    music:play()
    love.window.setMode(love.graphics.getFont():getWidth("Playing: " .. fileName) + 40, 100, {
        borderless = true
    })
    if love.graphics.getFont():getWidth("Playing: " .. fileName) <= music:getDuration() then
        love.window.setMode(music:getDuration() + 40, 100, {
            borderless = true
        })
    end
end

function love.draw()
    if music ~= nil then
        love.graphics.rectangle("line", 10, 10, music:getDuration(), 30)
        love.graphics.rectangle("fill", 10, 10, music:tell(), 30)
        love.graphics.print("Playing: " .. fileName .. "...\nTime: " .. math.floor(music:tell()) .. " / " ..
                                math.floor(music:getDuration()), 10, 50)
    elseif music == nil then
        love.graphics.print("Drop any music file!",
            love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth("Drop a music file!") / 2,
            love.graphics.getHeight() / 2 - love.graphics.getFont():getHeight() / 2)
    end
end

function love.keypressed(key)
    if key == "escape" then
        if music ~= nil and music:isPlaying() then
            love.window.setMode(1000, 500, {
                borderless = true
            })
            music:stop()
            music = nil
        end
    end
    if key == "space" then
        if music ~= nil then
            if music:isPlaying() then
                music:pause()
            else
                music:play()
            end
        end
    end
end
