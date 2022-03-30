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
    if row == 1 then
        notes[noteID] = {
            x = GameVars.inputPlace.x,
            y = 0
            -- y = GameVars.inputPlace.y + offset + 1000
        }
    end
    if row == 2 then
        notes2[noteID2] = {
            x = GameVars.inputPlace2.x,
            y = GameVars.inputPlace2.y + offset + 1000
        }
    end
    if row == 3 then
        notes3[noteID3] = {
            x = GameVars.inputPlace3.x,
            y = GameVars.inputPlace3.y + offset + 1000
        }
    end
    if row == 4 then
        notes4[noteID4] = {
            x = GameVars.inputPlace4.x,
            y = GameVars.inputPlace4.y + offset + 1000
        }
    end
end

function note:update()
    for i, note in ipairs(notes) do
        note.y = note.y + 10
        note.x = GameVars.inputPlace.x
    end
end

function note:draw()
    for i, note in ipairs(notes) do
        love.graphics.circle("fill", GameVars.inputPlace.x, note.y, 30)
    end
end

return note
