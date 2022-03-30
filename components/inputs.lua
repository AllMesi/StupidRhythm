local inputs = {}

function inputs:update(dt)
    if love.keyboard.isDown(love.filesystem.read("key1"), "left") then
        GameVars.inputPlace.size = 20
    else
        GameVars.inputPlace.size = 30
    end
    if love.keyboard.isDown(love.filesystem.read("key2"), "down") then
        GameVars.inputPlace2.size = 20
    else
        GameVars.inputPlace2.size = 30
    end
    if love.keyboard.isDown(love.filesystem.read("key3"), "up") then
        GameVars.inputPlace3.size = 20
    else
        GameVars.inputPlace3.size = 30
    end
    if love.keyboard.isDown(love.filesystem.read("key4"), "right") then
        GameVars.inputPlace4.size = 20
    else
        GameVars.inputPlace4.size = 30
    end
end

function inputs:keypressed(key, code)
    if not GameVars.chartingMode then
        if key == love.filesystem.read("key1") or key == "left" then
            Sounds.hitsound:play()
        end
        if key == love.filesystem.read("key2") or key == "down" then
            Sounds.hitsound2:play()
        end
        if key == love.filesystem.read("key3") or key == "up" then
            Sounds.hitsound3:play()
        end
        if key == love.filesystem.read("key4") or key == "right" then
            Sounds.hitsound4:play()
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
end

return inputs
