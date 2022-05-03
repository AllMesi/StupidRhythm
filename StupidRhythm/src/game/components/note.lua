local note = {}

function note:spawnNote(row, offset, type)
    Timer.after(offset / 1000, function()
        if row == 1 then
            table.insert(noteRow1, {
                x = circleStrum1.x,
                y = circleStrum1.y - GameConfig.songSettings.noteSpeed,
                alpha = 0.2,
                xoffset = 50,
                type = "normal"
            })
        end
        if row == 2 then
            table.insert(noteRow2, {
                x = circleStrum2.x,
                y = circleStrum2.y - GameConfig.songSettings.noteSpeed,
                alpha = 0.2,
                xoffset = 50,
                type = "normal"
            })
        end
        if row == 3 then
            table.insert(noteRow3, {
                x = circleStrum3.x,
                y = circleStrum3.y - GameConfig.songSettings.noteSpeed,
                alpha = 0.2,
                xoffset = 50,
                type = "normal"
            })
        end
        if row == 4 then
            table.insert(noteRow4, {
                x = circleStrum4.x,
                y = circleStrum4.y - GameConfig.songSettings.noteSpeed,
                alpha = 0.2,
                xoffset = 50,
                type = "normal"
            })
        end
    end)
end

function note:spawnSliderNote(row, time, offset)
    Timer.after(offset / 1000, function()
        note:spawnNote(row, 0)
        Timer.during(time / 1000, function()
            local sliderID = #noteSliderRow1 + 1
            local sliderID2 = #noteSliderRow2 + 1
            local sliderID3 = #noteSliderRow3 + 1
            local sliderID4 = #noteSliderRow4 + 1
            if row == 1 then
                noteSliderRow1[sliderID] = {
                    x = circleStrum1.x,
                    y = circleStrum1.y - GameConfig.songSettings.noteSpeed,
                    alpha = 0.2
                }
            end
            if row == 2 then
                noteSliderRow2[sliderID2] = {
                    x = circleStrum2.x,
                    y = circleStrum2.y - GameConfig.songSettings.noteSpeed,
                    alpha = 0.2
                }
            end
            if row == 3 then
                noteSliderRow3[sliderID3] = {
                    x = circleStrum3.x,
                    y = circleStrum3.y - GameConfig.songSettings.noteSpeed,
                    alpha = 0.2
                }
            end
            if row == 4 then
                noteSliderRow4[sliderID4] = {
                    x = circleStrum4.x,
                    y = circleStrum4.y - GameConfig.songSettings.noteSpeed,
                    alpha = 0.2
                }
            end
        end)
    end)
end

function note:spawnBar(offset)
    if GameConfig.songSettings.barNotes then
        local barID = #noteBarRow + 1
        noteBarRow[barID] = {
            y = circleStrum1.y - GameConfig.songSettings.barSpeed - offset
        }
    end
end

function note:draw()
    love.graphics.setColor(1, 1, 1, 1)
    noteRow1Cam:attach()
    for i, slider in ipairs(noteSliderRow1) do
        love.graphics.setColor(1, 1, 1, slider.alpha)
        gr.draw(NoteImageL, slider.x, slider.y - 30, 0, scaleXL, scaleYL, NoteImageL:getWidth() / 2, NoteImageL:getHeight() / 2)
    end
    noteRow1Cam:detach()
    noteRow2Cam:attach()
    for i, slider in ipairs(noteSliderRow2) do
        love.graphics.setColor(1, 1, 1, slider.alpha)
        gr.draw(NoteImageL, slider.x, slider.y - 30, 0, scaleXL, scaleYL, NoteImageL:getWidth() / 2, NoteImageL:getHeight() / 2)
    end
    noteRow2Cam:detach()
    noteRow3Cam:attach()
    for i, slider in ipairs(noteSliderRow3) do
        love.graphics.setColor(1, 1, 1, slider.alpha)
        gr.draw(NoteImageL, slider.x, slider.y - 30, 0, scaleXL, scaleYL, NoteImageL:getWidth() / 2, NoteImageL:getHeight() / 2)
    end
    noteRow3Cam:detach()
    noteRow4Cam:attach()
    for i, slider in ipairs(noteSliderRow4) do
        love.graphics.setColor(1, 1, 1, slider.alpha)
        gr.draw(NoteImageL, slider.x, slider.y - 30, 0, scaleXL, scaleYL, NoteImageL:getWidth() / 2, NoteImageL:getHeight() / 2)
    end
    noteRow4Cam:detach()
    noteRow1Cam:attach()
    for i, note in ipairs(noteRow1) do
        love.graphics.setColor(1, 1, 1, note.alpha)
        gr.draw(NoteImage1, note.x + note.xoffset, note.y, 0, scaleX1, scaleY1, NoteImage1:getWidth() / 2, NoteImage1:getHeight() / 2)
    end
    noteRow1Cam:detach()
    noteRow2Cam:attach()
    for i, note in ipairs(noteRow2) do
        love.graphics.setColor(1, 1, 1, note.alpha)
        gr.draw(NoteImage2, note.x + note.xoffset, note.y, 0, scaleX2, scaleY2, NoteImage2:getWidth() / 2, NoteImage2:getHeight() / 2)
    end
    noteRow2Cam:detach()
    noteRow3Cam:attach()
    for i, note in ipairs(noteRow3) do
        love.graphics.setColor(1, 1, 1, note.alpha)
        gr.draw(NoteImage3, note.x + note.xoffset, note.y, 0, scaleX3, scaleY4, NoteImage3:getWidth() / 2, NoteImage3:getHeight() / 2)
    end
    noteRow3Cam:detach()
    noteRow4Cam:attach()
    for i, note in ipairs(noteRow4) do
        love.graphics.setColor(1, 1, 1, note.alpha)
        gr.draw(NoteImage4, note.x + note.xoffset, note.y, 0, scaleX4, scaleY4, NoteImage4:getWidth() / 2, NoteImage4:getHeight() / 2)
    end
    noteRow4Cam:detach()
    if GameConfig.songSettings.barNotes then
        for i, bar in ipairs(noteBarRow) do
            love.graphics.line(circleStrum1.x, bar.y, circleStrum4.x,
                bar.y)
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function note:update(dt)
    if not GameConfig.songSettings.paused then
        for i, note in ipairs(noteRow1) do
            note.x = circleStrum1.x
            note.y = note.y + GameConfig.songSettings.noteSpeed * dt
            if note.y >= 0 then
                note.alpha = 0.9
            end
            if note.alpha == 0.9 then
                if note.xoffset > 0 then
                    note.xoffset = note.xoffset - 3000 * dt
                end
            end
            if note.xoffset <= 0 then
                note.xoffset = 0
            end
            if chartingMode then
                if note.y >= circleStrum1.y then
                    coolNoteHit(10)
                    Flux.to(circleStrum1, 0.05, {
                        curRadius = circleStrum1.radiusPressed
                    }):ease("quartout"):after(circleStrum1, 0.5, {
                        curRadius = circleStrum1.radiusReleased
                    }):ease("quartout")
                    table.remove(noteRow1, i)
                end
            end
            if note.y >= circleStrum1.y + 200 then
                table.remove(noteRow1, i)
                miss(1)
            end
        end
        for i, note in ipairs(noteRow2) do
            note.x = circleStrum2.x
            note.y = note.y + GameConfig.songSettings.noteSpeed * dt
            if note.y >= 0 then
                note.alpha = 0.9
            end
            if note.alpha == 0.9 then
                if note.xoffset > 0 then
                    note.xoffset = note.xoffset - 3000 * dt
                end
            end
            if note.xoffset <= 0 then
                note.xoffset = 0
            end
            if chartingMode then
                if note.y >= circleStrum2.y then
                    coolNoteHit(10)
                    Flux.to(circleStrum2, 0.05, {
                        curRadius = circleStrum2.radiusPressed
                    }):ease("quartout"):after(circleStrum2, 0.5, {
                        curRadius = circleStrum2.radiusReleased
                    }):ease("quartout")
                    table.remove(noteRow2, i)
                end
            end
            if note.y >= circleStrum2.y + 200 then
                table.remove(noteRow2, i)
                miss(1)
            end
        end
        for i, note in ipairs(noteRow3) do
            note.x = circleStrum3.x
            note.y = note.y + GameConfig.songSettings.noteSpeed * dt
            if note.y >= 0 then
                note.alpha = 0.9
            end
            if note.alpha == 0.9 then
                if note.xoffset > 0 then
                    note.xoffset = note.xoffset - 3000 * dt
                end
            end
            if note.xoffset <= 0 then
                note.xoffset = 0
            end
            if chartingMode then
                if note.y >= circleStrum3.y then
                    coolNoteHit(10)
                    Flux.to(circleStrum3, 0.05, {
                        curRadius = circleStrum3.radiusPressed
                    }):ease("quartout"):after(circleStrum3, 0.5, {
                        curRadius = circleStrum3.radiusReleased
                    }):ease("quartout")
                    table.remove(noteRow3, i)
                end
            end
            if note.y >= circleStrum3.y + 200 then
                table.remove(noteRow3, i)
                miss(1)
            end
        end
        for i, note in ipairs(noteRow4) do
            note.x = circleStrum4.x
            note.y = note.y + GameConfig.songSettings.noteSpeed * dt
            if note.y >= 0 then
                note.alpha = 0.9
            end
            if note.alpha == 0.9 then
                if note.xoffset > 0 then
                    note.xoffset = note.xoffset - 3000 * dt
                end
            end
            if note.xoffset <= 0 then
                note.xoffset = 0
            end
            if chartingMode then
                if note.y >= circleStrum4.y then
                    coolNoteHit(10)
                    Flux.to(circleStrum4, 0.05, {
                        curRadius = circleStrum4.radiusPressed
                    }):ease("quartout"):after(circleStrum4, 0.5, {
                        curRadius = circleStrum4.radiusReleased
                    }):ease("quartout")
                    table.remove(noteRow4, i)
                end
            end
            if note.y >= circleStrum4.y + 200 then
                table.remove(noteRow4, i)
                miss(1)
            end
        end
        for i, slider in ipairs(noteSliderRow1) do
            slider.y = slider.y + GameConfig.songSettings.noteSpeed * dt
            if slider.y >= 0 then
                slider.alpha = 1
            end
        end
        for i, slider in ipairs(noteSliderRow2) do
            slider.y = slider.y + GameConfig.songSettings.noteSpeed * dt
            if slider.y >= 0 then
                slider.alpha = 1
            end
        end
        for i, slider in ipairs(noteSliderRow3) do
            slider.y = slider.y + GameConfig.songSettings.noteSpeed * dt
            if slider.y >= 0 then
                slider.alpha = 1
            end
        end
        for i, slider in ipairs(noteSliderRow4) do
            slider.y = slider.y + GameConfig.songSettings.noteSpeed * dt
            if slider.y >= 0 then
                slider.alpha = 1
            end
        end
        for i, slider in ipairs(noteSliderRow1) do
            if not chartingMode then
                if love.keyboard.isDown(GameConfig.songSettings.key1, GameConfig.songSettings.key1alt) then
                    if slider.y >= circleStrum1.y then
                        table.remove(noteSliderRow1, i)
                    end
                end
            else
                if slider.y >= circleStrum1.y then
                    table.remove(noteSliderRow1, i)
                end
            end
            if slider.y >= circleStrum1.y + 200 then
                table.remove(noteSliderRow1, i)
            end
        end
        for i, slider in ipairs(noteSliderRow2) do
            if not chartingMode then
                if love.keyboard.isDown(GameConfig.songSettings.key2, GameConfig.songSettings.key2alt) then
                    if slider.y >= circleStrum2.y then
                        table.remove(noteSliderRow2, i)
                    end
                end
            else
                if slider.y >= circleStrum2.y then
                    table.remove(noteSliderRow2, i)
                end
            end
            if slider.y >= circleStrum2.y + 200 then
                table.remove(noteSliderRow2, i)
            end
        end
        for i, slider in ipairs(noteSliderRow3) do
            if not chartingMode then
                if love.keyboard.isDown(GameConfig.songSettings.key3, GameConfig.songSettings.key3alt) then
                    if slider.y >= circleStrum3.y then
                        table.remove(noteSliderRow3, i)
                    end
                end
            else
                if slider.y >= circleStrum3.y then
                    table.remove(noteSliderRow3, i)
                end
            end
            if slider.y >= circleStrum3.y + 200 then
                table.remove(noteSliderRow3, i)
            end
        end
        for i, slider in ipairs(noteSliderRow4) do
            if not chartingMode then
                if love.keyboard.isDown(GameConfig.songSettings.key4, GameConfig.songSettings.key4alt) then
                    if slider.y >= circleStrum4.y then
                        table.remove(noteSliderRow4, i)
                    end
                end
            else
                if slider.y >= circleStrum4.y then
                    table.remove(noteSliderRow4, i)
                end
            end
            if slider.y >= circleStrum1.y + 200 then
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
                    if bar.y >= circleStrum1.y - 50 then

                        table.remove(noteBarRow, i)
                    end
                end
            end
        end
    end
end

return note
