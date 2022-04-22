local hud = {}

function hud:update(dt)
end

function hud:draw()
    love.graphics.setColor(unpack(GameConfig.songSettings.foreColour))
    love.graphics.setLineWidth(GameConfig.songSettings.circleThickness)
    
    if GameConfig.songSettings.strumLine then
        love.graphics.line(
            GameConfig.songSettings.circleStrum1.x - 60,
            GameConfig.songSettings.circleStrum1.y + 30,
            GameConfig.songSettings.circleStrum1.x + 60,
            GameConfig.songSettings.circleStrum1.y + 30
        )
        love.graphics.line(
            GameConfig.songSettings.circleStrum2.x - 60,
            GameConfig.songSettings.circleStrum2.y + 30,
            GameConfig.songSettings.circleStrum2.x + 60,
            GameConfig.songSettings.circleStrum2.y + 30
        )
        love.graphics.line(
            GameConfig.songSettings.circleStrum3.x - 60,
            GameConfig.songSettings.circleStrum3.y + 30,
            GameConfig.songSettings.circleStrum3.x + 60,
            GameConfig.songSettings.circleStrum3.y + 30
        )
        love.graphics.line(
            GameConfig.songSettings.circleStrum4.x - 60,
            GameConfig.songSettings.circleStrum4.y + 30,
            GameConfig.songSettings.circleStrum4.x + 60,
            GameConfig.songSettings.circleStrum4.y + 30
    )
    end
    
    if GameConfig.songSettings.barNotes then
        love.graphics.line(
            GameConfig.songSettings.circleStrum1.x,
            GameConfig.songSettings.circleStrum1.y - 60,
            GameConfig.songSettings.circleStrum4.x,
            GameConfig.songSettings.circleStrum4.y - 60
        )
        love.graphics.line(
            GameConfig.songSettings.circleStrum1.x,
            GameConfig.songSettings.circleStrum1.y - 50,
            GameConfig.songSettings.circleStrum4.x,
            GameConfig.songSettings.circleStrum4.y - 50
        )
        love.graphics.line(
            GameConfig.songSettings.circleStrum4.x,
            GameConfig.songSettings.circleStrum4.y - 60,
            GameConfig.songSettings.circleStrum4.x,
            GameConfig.songSettings.circleStrum4.y - 50
        )
        love.graphics.line(
            GameConfig.songSettings.circleStrum1.x,
            GameConfig.songSettings.circleStrum1.y - 60,
            GameConfig.songSettings.circleStrum1.x,
            GameConfig.songSettings.circleStrum1.y - 50
    )
    end
    
    love.graphics.circle(
        "line",
        GameConfig.songSettings.circleStrum1.x,
        GameConfig.songSettings.circleStrum1.y,
        GameConfig.songSettings.circleStrum1.curRadius
    )
    love.graphics.circle(
        "line",
        GameConfig.songSettings.circleStrum2.x,
        GameConfig.songSettings.circleStrum2.y,
        GameConfig.songSettings.circleStrum2.curRadius
    )
    love.graphics.circle(
        "line",
        GameConfig.songSettings.circleStrum3.x,
        GameConfig.songSettings.circleStrum3.y,
        GameConfig.songSettings.circleStrum3.curRadius
    )
    love.graphics.circle(
        "line",
        GameConfig.songSettings.circleStrum4.x,
        GameConfig.songSettings.circleStrum4.y,
        GameConfig.songSettings.circleStrum4.curRadius
    )
    love.graphics.setLineWidth(GameConfig.songSettings.lineThickness)
    
    love.graphics.line(
        GameConfig.songSettings.circleStrum1.x - 60,
        0,
        GameConfig.songSettings.circleStrum1.x - 60,
        love.graphics.getHeight()
    )
    love.graphics.line(
        GameConfig.songSettings.circleStrum4.x + 60,
        0,
        GameConfig.songSettings.circleStrum4.x + 60,
        love.graphics.getHeight()
    )
    love.graphics.setColor(1, 1, 1)
end

return hud
