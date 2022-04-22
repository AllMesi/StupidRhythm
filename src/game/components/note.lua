local note = {}

function note:spawnNote(row, offset)
    if row == 1 then
        table.insert(noteRow1, {
            x = GameConfig.songSettings.circleStrum1.x,
            y = GameConfig.songSettings.circleStrum1.y - offset - GameConfig.songSettings.noteSpeed1
        })
    end
    if row == 2 then
        table.insert(noteRow2, {
            x = GameConfig.songSettings.circleStrum2.x,
            y = GameConfig.songSettings.circleStrum2.y - offset - GameConfig.songSettings.noteSpeed2
        })
    end
    if row == 3 then
        table.insert(noteRow3, {
            x = GameConfig.songSettings.circleStrum3.x,
            y = GameConfig.songSettings.circleStrum3.y - offset - GameConfig.songSettings.noteSpeed3
        })
    end
    if row == 4 then
        table.insert(noteRow4, {
            x = GameConfig.songSettings.circleStrum4.x,
            y = GameConfig.songSettings.circleStrum4.y - offset - GameConfig.songSettings.noteSpeed4
        })
    end
end

function note:spawnSliderNote(row, time)
    Timer.during(time, function()
        local sliderID = #noteSliderRow1 + 1
        local sliderID2 = #noteSliderRow2 + 1
        local sliderID3 = #noteSliderRow3 + 1
        local sliderID4 = #noteSliderRow4 + 1
        if row == 1 then
            noteSliderRow1[sliderID] = {
                x = GameConfig.songSettings.circleStrum1.x,
                y = GameConfig.songSettings.circleStrum1.y - GameConfig.songSettings.noteSpeed1
            }
        end
        if row == 2 then
            noteSliderRow2[sliderID2] = {
                x = GameConfig.songSettings.circleStrum2.x,
                y = GameConfig.songSettings.circleStrum2.y - GameConfig.songSettings.noteSpeed2
            }
        end
        if row == 3 then
            noteSliderRow3[sliderID3] = {
                x = GameConfig.songSettings.circleStrum3.x,
                y = GameConfig.songSettings.circleStrum3.y - GameConfig.songSettings.noteSpeed3
            }
        end
        if row == 4 then
            noteSliderRow4[sliderID4] = {
                x = GameConfig.songSettings.circleStrum4.x,
                y = GameConfig.songSettings.circleStrum4.y - GameConfig.songSettings.noteSpeed4
            }
        end
    end)
end

function note:spawnBar(offset)
    if GameConfig.songSettings.barNotes then
        local barID = #noteBarRow + 1
        noteBarRow[barID] = {
            y = GameConfig.songSettings.circleStrum1.y - GameConfig.songSettings.barSpeed - offset
        }
    end
end

function note:draw()
    for i, note in ipairs(noteRow1) do
        gr.draw(NoteImage1, note.x, note.y, 0, scaleX1, scaleY1, NoteImage1:getWidth() / 2, NoteImage1:getHeight() / 2)
    end
    for i, note in ipairs(noteRow2) do
        gr.draw(NoteImage2, note.x, note.y, 0, scaleX2, scaleY2, NoteImage2:getWidth() / 2, NoteImage2:getHeight() / 2)
    end
    for i, note in ipairs(noteRow3) do
        gr.draw(NoteImage1, note.x, note.y, 0, scaleX3, scaleY4, NoteImage3:getWidth() / 2, NoteImage3:getHeight() / 2)
    end
    for i, note in ipairs(noteRow4) do
        gr.draw(NoteImage1, note.x, note.y, 0, scaleX4, scaleY4, NoteImage4:getWidth() / 2, NoteImage4:getHeight() / 2)
    end
    for i, slider in ipairs(noteSliderRow1) do
        love.graphics.circle("fill", GameConfig.songSettings.circleStrum1.x, slider.y - 30, 30)
    end
    for i, slider in ipairs(noteSliderRow2) do
        love.graphics.circle("fill", GameConfig.songSettings.circleStrum2.x, slider.y - 30, 30)
    end
    for i, slider in ipairs(noteSliderRow3) do
        love.graphics.circle("fill", GameConfig.songSettings.circleStrum3.x, slider.y - 30, 30)
    end
    for i, slider in ipairs(noteSliderRow4) do
        love.graphics.circle("fill", GameConfig.songSettings.circleStrum4.x, slider.y - 30, 30)
    end
    if GameConfig.songSettings.barNotes then
        for i, bar in ipairs(noteBarRow) do
            love.graphics.line(GameConfig.songSettings.circleStrum1.x, bar.y, GameConfig.songSettings.circleStrum4.x,
                bar.y)
        end
    end
end

function note:update(dt)
    if not GameConfig.songSettings.paused then
        for i, note in ipairs(noteRow1) do
            if GameConfig.songSettings.upscroll1 then
                note.y = note.y - GameConfig.songSettings.noteSpeed1 * dt
            else
                note.y = note.y + GameConfig.songSettings.noteSpeed1 * dt
            end
            if chartingMode then
                if note.y >= GameConfig.songSettings.circleStrum1.y then
                    Flux.to(GameConfig.songSettings.circleStrum1, 0.05, {
                        curRadius = GameConfig.songSettings.circleStrum1.radiusPressed
                    }):ease("quartout"):after(GameConfig.songSettings.circleStrum1, 0.5, {
                        curRadius = GameConfig.songSettings.circleStrum1.radiusReleased
                    }):ease("quartout")
                    table.remove(noteRow1, i)
                end
            end
        end
        for i, note in ipairs(noteRow2) do
            note.y = note.y + GameConfig.songSettings.noteSpeed2 * dt
            if chartingMode then
                if note.y >= GameConfig.songSettings.circleStrum2.y then
                    Flux.to(GameConfig.songSettings.circleStrum2, 0.05, {
                        curRadius = GameConfig.songSettings.circleStrum2.radiusPressed
                    }):ease("quartout"):after(GameConfig.songSettings.circleStrum2, 0.5, {
                        curRadius = GameConfig.songSettings.circleStrum2.radiusReleased
                    }):ease("quartout")
                    table.remove(noteRow2, i)
                end
            end
        end
        for i, note in ipairs(noteRow3) do
            note.y = note.y + GameConfig.songSettings.noteSpeed3 * dt
            if chartingMode then
                if note.y >= GameConfig.songSettings.circleStrum3.y then
                    Flux.to(GameConfig.songSettings.circleStrum3, 0.05, {
                        curRadius = GameConfig.songSettings.circleStrum3.radiusPressed
                    }):ease("quartout"):after(GameConfig.songSettings.circleStrum3, 0.5, {
                        curRadius = GameConfig.songSettings.circleStrum3.radiusReleased
                    }):ease("quartout")
                    table.remove(noteRow3, i)
                end
            end
        end
        for i, note in ipairs(noteRow4) do
            note.y = note.y + GameConfig.songSettings.noteSpeed4 * dt
            if chartingMode then
                if note.y >= GameConfig.songSettings.circleStrum4.y then
                    Flux.to(GameConfig.songSettings.circleStrum4, 0.05, {
                        curRadius = GameConfig.songSettings.circleStrum4.radiusPressed
                    }):ease("quartout"):after(GameConfig.songSettings.circleStrum4, 0.5, {
                        curRadius = GameConfig.songSettings.circleStrum4.radiusReleased
                    }):ease("quartout")
                    table.remove(noteRow4, i)
                end
            end
        end
        for i, slider in ipairs(noteSliderRow1) do
            slider.y = slider.y + GameConfig.songSettings.noteSpeed1 * dt
        end
        for i, slider in ipairs(noteSliderRow2) do
            slider.y = slider.y + GameConfig.songSettings.noteSpeed2 * dt
        end
        for i, slider in ipairs(noteSliderRow3) do
            slider.y = slider.y + GameConfig.songSettings.noteSpeed3 * dt
        end
        for i, slider in ipairs(noteSliderRow4) do
            slider.y = slider.y + GameConfig.songSettings.noteSpeed4 * dt
        end
        for i, slider in ipairs(noteSliderRow1) do
            if not chartingMode then
                if love.keyboard.isDown(GameConfig.songSettings.key1, GameConfig.songSettings.key1alt) then
                    if slider.y >= GameConfig.songSettings.circleStrum1.y then
                        table.remove(noteSliderRow1, i)
                    end
                end
            else
                if slider.y >= GameConfig.songSettings.circleStrum1.y then
                    table.remove(noteSliderRow1, i)
                end
            end
            if slider.y >= GameConfig.songSettings.circleStrum1.y + 200 then
                table.remove(noteSliderRow1, i)
            end
        end
        for i, slider in ipairs(noteSliderRow2) do
            if not chartingMode then
                if love.keyboard.isDown(GameConfig.songSettings.key2, GameConfig.songSettings.key2alt) then
                    if slider.y >= GameConfig.songSettings.circleStrum2.y then
                        table.remove(noteSliderRow2, i)
                    end
                end
            else
                if slider.y >= GameConfig.songSettings.circleStrum2.y then
                    table.remove(noteSliderRow2, i)
                end
            end
            if slider.y >= GameConfig.songSettings.circleStrum2.y + 200 then
                table.remove(noteSliderRow2, i)
            end
        end
        for i, slider in ipairs(noteSliderRow3) do
            if not chartingMode then
                if love.keyboard.isDown(GameConfig.songSettings.key3, GameConfig.songSettings.key3alt) then
                    if slider.y >= GameConfig.songSettings.circleStrum3.y then
                        table.remove(noteSliderRow3, i)
                    end
                end
            else
                if slider.y >= GameConfig.songSettings.circleStrum3.y then
                    table.remove(noteSliderRow3, i)
                end
            end
            if slider.y >= GameConfig.songSettings.circleStrum3.y + 200 then
                table.remove(noteSliderRow3, i)
            end
        end
        for i, slider in ipairs(noteSliderRow4) do
            if not chartingMode then
                if love.keyboard.isDown(GameConfig.songSettings.key4, GameConfig.songSettings.key4alt) then
                    if slider.y >= GameConfig.songSettings.circleStrum4.y then
                        table.remove(noteSliderRow4, i)
                    end
                end
            else
                if slider.y >= GameConfig.songSettings.circleStrum4.y then
                    table.remove(noteSliderRow4, i)
                end
            end
            if slider.y >= GameConfig.songSettings.circleStrum1.y + 200 then
                table.remove(noteSliderRow4, i)
            end
        end
        if GameConfig.songSettings.barNotes then
            for i, bar in ipairs(noteBarRow) do
                bar.y = bar.y + GameConfig.songSettings.barSpeed * dt
                if bar.y >= love.graphics.getHeight() - 30 then
                    table.remove(noteBarRow, i)
                end
                if chartingMode then
                    if bar.y >= GameConfig.songSettings.circleStrum1.y - 50 then

                        table.remove(noteBarRow, i)
                    end
                end
            end
        end
    end
end

return note
