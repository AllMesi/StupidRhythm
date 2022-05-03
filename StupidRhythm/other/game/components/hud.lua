local hud = {}

function hud:update(dt)
end

function hud:draw()
    love.graphics.setColor(0, 0, 0)
    -- love.graphics.rectangle("fill", circleStrum1.x - 60, 0, circleStrum4.x + 60, love.graphics.getHeight())
    love.graphics.setColor(unpack(GameConfig.songSettings.foreColour))
    love.graphics.setLineWidth(GameConfig.songSettings.circleThickness)

    if GameConfig.songSettings.strumLine then
        love.graphics.line(circleStrum1.x - 60, circleStrum1.y + 30,
            circleStrum1.x + 60, circleStrum1.y + 30)
        love.graphics.line(circleStrum2.x - 60, circleStrum2.y + 30,
            circleStrum2.x + 60, circleStrum2.y + 30)
        love.graphics.line(circleStrum3.x - 60, circleStrum3.y + 30,
            circleStrum3.x + 60, circleStrum3.y + 30)
        love.graphics.line(circleStrum4.x - 60, circleStrum4.y + 30,
            circleStrum4.x + 60, circleStrum4.y + 30)
    end

    if GameConfig.songSettings.barNotes then
        love.graphics.line(circleStrum1.x, circleStrum1.y - 60,
            circleStrum4.x, circleStrum4.y - 60)
        love.graphics.line(circleStrum1.x, circleStrum1.y - 50,
            circleStrum4.x, circleStrum4.y - 50)
        love.graphics.line(circleStrum4.x, circleStrum4.y - 60,
            circleStrum4.x, circleStrum4.y - 50)
        love.graphics.line(circleStrum1.x, circleStrum1.y - 60,
            circleStrum1.x, circleStrum1.y - 50)
    end

    noteRow1Cam:attach()
    love.graphics.circle("line", circleStrum1.x, circleStrum1.y,
        circleStrum1.curRadius)
    noteRow1Cam:detach()
    noteRow2Cam:attach()
    love.graphics.circle("line", circleStrum2.x, circleStrum2.y,
        circleStrum2.curRadius)
    noteRow2Cam:detach()
    noteRow3Cam:attach()
    love.graphics.circle("line", circleStrum3.x, circleStrum3.y,
        circleStrum3.curRadius)
    noteRow3Cam:detach()
    noteRow4Cam:attach()
    love.graphics.circle("line", circleStrum4.x, circleStrum4.y,
        circleStrum4.curRadius)
    noteRow4Cam:detach()
    love.graphics.setLineWidth(GameConfig.songSettings.lineThickness)

    love.graphics.line(noteRow1Cam.x - 60, 0, noteRow1Cam.x - 60,
        love.graphics.getHeight())
    love.graphics.line(noteRow4Cam.x + 60, 0, noteRow4Cam.x + 60,
        love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1)
end

return hud
