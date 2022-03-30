local note = {}

local notes = {}
local notes2 = {}
local notes3 = {}
local notes4 = {}

function note:newNote(row, offset)
    local noteID = #notes + 1
    local noteID2 = #notes2 + 1
    local noteID3 = #notes3 + 1
    local noteID4 = #notes4 + 1
    if row == 1 then notes[noteID] = {x = GameVars.inputPlace.x, y = 0} end
    if row == 2 then notes2[noteID2] = {x = GameVars.inputPlace2.x, y = 0} end
    if row == 3 then notes3[noteID3] = {x = GameVars.inputPlace3.x, y = 0} end
    if row == 4 then notes4[noteID4] = {x = GameVars.inputPlace4.x, y = 0} end
end

function note:update(dt)
    for i, note in ipairs(notes) do
        note.y = note.y + GameVars.speed * dt
        note.x = GameVars.inputPlace.x
        if note.y >= GameVars.inputPlace.y then table.remove(notes, i) end
    end
    for i, note in ipairs(notes2) do
        note.y = note.y + GameVars.speed * dt
        note.x = GameVars.inputPlace2.x
        if note.y >= GameVars.inputPlace.y then table.remove(notes2, i) end
    end
    for i, note in ipairs(notes3) do
        note.y = note.y + GameVars.speed * dt
        note.x = GameVars.inputPlace3.x
        if note.y >= GameVars.inputPlace.y then table.remove(notes3, i) end
    end
    for i, note in ipairs(notes4) do
        note.y = note.y + GameVars.speed * dt
        note.x = GameVars.inputPlace4.x
        if note.y >= GameVars.inputPlace.y then table.remove(notes4, i) end
    end
end

function note:draw()
    for i, note in ipairs(notes) do
        Graphics.setColor(1, 1, 1, math.random(0.4, 1))
        love.graphics.line(note.x, note.y, 0, 0)
        Graphics.setColor(1, 1, 1)
        love.graphics.circle("fill", GameVars.inputPlace.x, note.y, 30)
    end
    for i, note in ipairs(notes2) do
        Graphics.setColor(1, 1, 1, math.random(0.4, 1))
        love.graphics.line(note.x, note.y, 0, 0)
        Graphics.setColor(1, 1, 1)
        love.graphics.circle("fill", GameVars.inputPlace2.x, note.y, 30)
    end
    for i, note in ipairs(notes3) do
        Graphics.setColor(1, 1, 1, math.random(0.4, 1))
        love.graphics.line(note.x, note.y, 0, 0)
        Graphics.setColor(1, 1, 1)
        love.graphics.circle("fill", GameVars.inputPlace3.x, note.y, 30)
    end
    for i, note in ipairs(notes4) do
        Graphics.setColor(1, 1, 1, math.random(0.4, 1))
        love.graphics.line(note.x, note.y, 0, 0)
        Graphics.setColor(1, 1, 1)
        love.graphics.circle("fill", GameVars.inputPlace4.x, note.y, 30)
    end
end

return note
