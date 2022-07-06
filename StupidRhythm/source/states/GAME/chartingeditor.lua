local chart = {}
local offset = {
    y = 0,
    x = 300,
    yLines = 0
}
local bpm = 0
local music
local notes = {}

function chart.enter(songName, songbpm, audio)
    love.graphics.setLineWidth(3)
    bpm = songbpm
    music = audio
end

function chart.update(dt)
    if offset.yLines > 60 then
        offset.yLines = 0 
    end
    for i, v in ipairs(notes) do
        v.y = love.graphics.getHeight() - 80 + music:tell() * 1000 - v.time
        if v.data == 0 then
            v.x = offset.x + 30
        end
        if v.data == 1 then
            v.x = 60 + offset.x
        end
        if v.data == 2 then
            v.x = 60 * 2 + offset.x
        end
        if v.data == 3 then
            v.x = 60 * 3 + offset.x
        end
    end
end

function chart.draw()
    love.graphics.line(offset.x, love.graphics.getHeight() / 2 - 1.5, 60 * 4 + offset.x, love.graphics.getHeight() / 2 - 1.5)
    love.graphics.line(offset.x, 0, offset.x, love.graphics.getHeight())
    love.graphics.line(60 * 4 + offset.x, 0, 60 * 4 + offset.x, love.graphics.getHeight())
    for i, v in ipairs(notes) do
        love.graphics.circle("fill", v.x, v.y, 30)
    end
end

function chart.keypressed(key)
    if key == "space" then
        if music:isPlaying() then
            music:pause()
        else
            music:play()
        end
    end
    if key == "1" then
        table.insert(notes, {
            x = 0,
            y = 0,
            time = music:tell() * 1000
        })
    end
end

return chart
