local note = {}

function note:newNote(row, offset)
    local noteID = #GameVars.notes + 1
    local noteID2 = #GameVars.notes2 + 1
    local noteID3 = #GameVars.notes3 + 1
    local noteID4 = #GameVars.notes4 + 1
    local noteID5 = #GameVars.notes5 + 1
    local noteID6 = #GameVars.notes6 + 1
    local noteID7 = #GameVars.notes7 + 1
    local noteID8 = #GameVars.notes8 + 1
    if row == 1 then
        GameVars.notes[noteID] = {
            x = GameVars.inputPlace.x,
            y = GameVars.inputPlace.y - 1000 - offset
        }
    end
    if row == 2 then
        GameVars.notes2[noteID2] = {
            x = GameVars.inputPlace2.x,
            y = GameVars.inputPlace2.y - 1000 - offset
        }
    end
    if row == 3 then
        GameVars.notes3[noteID3] = {
            x = GameVars.inputPlace3.x,
            y = GameVars.inputPlace3.y - 1000 - offset
        }
    end
    if row == 4 then
        GameVars.notes4[noteID4] = {
            x = GameVars.inputPlace4.x,
            y = GameVars.inputPlace4.y - 1000 - offset
        }
    end
    if row == 5 then
        GameVars.notes5[noteID5] = {
            x = GameVars.inputPlace5.x,
            y = GameVars.inputPlace5.y - 1000 - offset
        }
    end
    if row == 6 then
        GameVars.notes6[noteID6] = {
            x = GameVars.inputPlace6.x,
            y = GameVars.inputPlace6.y - 1000 - offset
        }
    end
    if row == 7 then
        GameVars.notes7[noteID7] = {
            x = GameVars.inputPlace7.x,
            y = GameVars.inputPlace7.y - 1000 - offset
        }
    end
    if row == 8 then
        GameVars.notes8[noteID8] = {
            x = GameVars.inputPlace8.x,
            y = GameVars.inputPlace8.y - 1000 - offset
        }
    end
end

function note:update(dt)
    for i, note in ipairs(GameVars.notes) do
        if not GameVars.paused then
            if not GameVars.paused then
                note.y = note.y + GameVars.speed * dt
            end
        end
        note.x = GameVars.inputPlace.x
        if GameVars.chartingMode then
            if note.y >= GameVars.inputPlace.y then
                GameVars.inputPlace.size = 20
                table.remove(GameVars.notes, i)
            end
        end
    end
    for i, note in ipairs(GameVars.notes2) do
        if not GameVars.paused then note.y = note.y + GameVars.speed * dt end
        note.x = GameVars.inputPlace2.x
        if GameVars.chartingMode then
            if note.y >= GameVars.inputPlace.y then
                GameVars.inputPlace2.size = 20
                table.remove(GameVars.notes2, i)
            end
        end
    end
    for i, note in ipairs(GameVars.notes3) do
        if not GameVars.paused then note.y = note.y + GameVars.speed * dt end
        note.x = GameVars.inputPlace3.x
        if GameVars.chartingMode then
            if note.y >= GameVars.inputPlace.y then
                GameVars.inputPlace3.size = 20
                table.remove(GameVars.notes3, i)
            end
        end
    end
    for i, note in ipairs(GameVars.notes4) do
        if not GameVars.paused then note.y = note.y + GameVars.speed * dt end
        note.x = GameVars.inputPlace4.x
        if GameVars.chartingMode then
            if note.y >= GameVars.inputPlace.y then
                GameVars.inputPlace4.size = 20
                table.remove(GameVars.notes4, i)
            end
        end
    end
    for i, note in ipairs(GameVars.notes5) do
        if not GameVars.paused then note.y = note.y + GameVars.speed * dt end
        note.x = GameVars.inputPlace5.x
        if note.y >= GameVars.inputPlace.y then
            table.remove(GameVars.notes5, i)
        end
    end
    for i, note in ipairs(GameVars.notes6) do
        if not GameVars.paused then note.y = note.y + GameVars.speed * dt end
        note.x = GameVars.inputPlace6.x
        if note.y >= GameVars.inputPlace.y then
            table.remove(GameVars.notes6, i)
        end
    end
    for i, note in ipairs(GameVars.notes7) do
        if not GameVars.paused then note.y = note.y + GameVars.speed * dt end
        note.x = GameVars.inputPlace7.x
        if note.y >= GameVars.inputPlace.y then
            table.remove(GameVars.notes7, i)
        end
    end
    for i, note in ipairs(GameVars.notes8) do
        if not GameVars.paused then note.y = note.y + GameVars.speed * dt end
        note.x = GameVars.inputPlace8.x
        if note.y >= GameVars.inputPlace.y then
            table.remove(GameVars.notes8, i)
        end
    end
end

function note:draw()
    for i, note in ipairs(GameVars.notes) do
        love.graphics.circle("fill", GameVars.inputPlace.x, note.y, 30)
    end
    for i, note in ipairs(GameVars.notes2) do
        love.graphics.circle("fill", GameVars.inputPlace2.x, note.y, 30)
    end
    for i, note in ipairs(GameVars.notes3) do
        love.graphics.circle("fill", GameVars.inputPlace3.x, note.y, 30)
    end
    for i, note in ipairs(GameVars.notes4) do
        love.graphics.circle("fill", GameVars.inputPlace4.x, note.y, 30)
    end
    for i, note in ipairs(GameVars.notes5) do
        love.graphics.circle("fill", GameVars.inputPlace5.x, note.y, 30)
    end
    for i, note in ipairs(GameVars.notes6) do
        love.graphics.circle("fill", GameVars.inputPlace6.x, note.y, 30)
    end
    for i, note in ipairs(GameVars.notes7) do
        love.graphics.circle("fill", GameVars.inputPlace7.x, note.y, 30)
    end
    for i, note in ipairs(GameVars.notes8) do
        love.graphics.circle("fill", GameVars.inputPlace8.x, note.y, 30)
    end
end

return note
