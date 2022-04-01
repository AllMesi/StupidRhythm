local inputs = {}

function inputs:update(dt)
    if not GameVars.chartingMode then
        if love.keyboard.isDown(love.filesystem.read("key1"), "left") then
            GameVars.inputPlace.size = 20
        end
        if love.keyboard.isDown(love.filesystem.read("key2"), "down") then
            GameVars.inputPlace2.size = 20
        end
        if love.keyboard.isDown(love.filesystem.read("key3"), "up") then
            GameVars.inputPlace3.size = 20
        end
        if love.keyboard.isDown(love.filesystem.read("key4"), "right") then
            GameVars.inputPlace4.size = 20
        end
    end
    if GameVars.chartingMode and GameVars.bruh then
        if love.keyboard.isDown(love.filesystem.read("key1"), "left") then
            Components.note:newNote(1, 0)
        end
        if love.keyboard.isDown(love.filesystem.read("key2"), "down") then
            Components.note:newNote(2, 0)
        end
        if love.keyboard.isDown(love.filesystem.read("key3"), "up") then
            Components.note:newNote(3, 0)
        end
        if love.keyboard.isDown(love.filesystem.read("key4"), "right") then
            Components.note:newNote(4, 0)
        end
    end
end

function inputs:keypressed(key)
    if not GameVars.chartingMode then
        if key == love.filesystem.read("key1") or key == "left" then
            for i, note in ipairs(GameVars.notes) do
                if note.y >= GameVars.inputPlace.y - 100 then
                    onHitNote(1)
                end
                if note.y >= Graphics.getHeight() then
                    onMissNote()
                end
            end
        end
        if key == love.filesystem.read("key2") or key == "down" then
            for i, note in ipairs(GameVars.notes2) do
                if note.y >= GameVars.inputPlace.y - 100 then
                    onHitNote(2)
                end
                if note.y >= Graphics.getHeight() then
                    onMissNote()
                end
            end
        end
        if key == love.filesystem.read("key3") or key == "up" then
            for i, note in ipairs(GameVars.notes3) do
                if note.y >= GameVars.inputPlace.y - 100 then
                    onHitNote(3)
                end
                if note.y >= Graphics.getHeight() then
                    onMissNote()
                end
            end
        end
        if key == love.filesystem.read("key4") or key == "right" then
            for i, note in ipairs(GameVars.notes4) do
                if note.y >= GameVars.inputPlace.y - 100 then
                    onHitNote(4)
                end
                if note.y >= Graphics.getHeight() then
                    onMissNote()
                end
            end
        end
    else
        if key == love.filesystem.read("key1") or key == "left" then
            Components.note:newNote(1, 0)
        end
        if key == love.filesystem.read("key2") or key == "down" then
            Components.note:newNote(2, 0)
        end
        if key == love.filesystem.read("key3") or key == "up" then
            Components.note:newNote(3, 0)
        end
        if key == love.filesystem.read("key4") or key == "right" then
            Components.note:newNote(4, 0)
        end
    end
    if key == "i" then
        if not GameVars.chartingMode then
            GameVars.chartingMode = true
        else
            GameVars.chartingMode = false
            GameVars.bruh = false
        end
    end
    if key == "p" then
        if GameVars.chartingMode then
            if not GameVars.bruh then
                GameVars.bruh = true
            else
                GameVars.bruh = false
            end
        end
    end
end

function onHitNote(row)
    if GameVars.chartingMode then
        GameVars.rating = "AWESOME!"
    else
        GameVars.rating = "AWESOME!"
        if row == 1 then
            for i, note in ipairs(GameVars.notes) do
                table.remove(GameVars.notes, i)
            end
        end
        if row == 2 then
            for i, note in ipairs(GameVars.notes2) do
                table.remove(GameVars.notes2, i)
            end
        end
        if row == 3 then
            for i, note in ipairs(GameVars.notes3) do
                table.remove(GameVars.notes3, i)
            end
        end
        if row == 4 then
            for i, note in ipairs(GameVars.notes4) do
                table.remove(GameVars.notes4, i)
            end
        end
    end
end

function onMissNote(row)
    GameVars.rating = "MISS!"
    if row == 1 then table.remove(GameVars.notes, 1) end
    if row == 2 then table.remove(GameVars.notes2, 1) end
    if row == 3 then table.remove(GameVars.notes3, 1) end
    if row == 4 then table.remove(GameVars.notes4, 1) end
end

return inputs
