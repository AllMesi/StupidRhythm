local game = {}

local notes = {}
local notes2 = {}
local notes3 = {}
local notes4 = {}

local alpha = {}

alpha.alpha = 0

local isHot = false

function game:init()
    camera = Camera(GameVars.inputPlace.x, GameVars.inputPlace.y)
end

function game:enter()
    GameVars.inputPlace.y = love.graphics.getHeight() - 50
    GameVars.inputPlace2.y = love.graphics.getHeight() - 50
    GameVars.inputPlace3.y = love.graphics.getHeight() - 50
    GameVars.inputPlace4.y = love.graphics.getHeight() - 50
    GameVars.inputPlace.x = love.graphics.getWidth() / 2 - 110
    GameVars.inputPlace2.x = love.graphics.getWidth() / 2 - 40
    GameVars.inputPlace3.x = love.graphics.getWidth() / 2 + 40
    GameVars.inputPlace4.x = love.graphics.getWidth() / 2 + 110
    GameVars.inputPlace.size = 30
    GameVars.inputPlace2.size = 30
    GameVars.inputPlace3.size = 30
    GameVars.inputPlace4.size = 30
    Timer.tween(1, alpha, {alpha = 1}, 'in-out-quad')
end

function game:update(dt)
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
    for i, note in ipairs(notes) do
        note.y = note.y + 500 * dt
        note.x = GameVars.inputPlace.x
        if note.y >= GameVars.inputPlace.y then table.remove(notes, i) end
    end
    for i, note in ipairs(notes2) do
        note.y = note.y + 500 * dt
        note.x = GameVars.inputPlace2.x
        if note.y >= GameVars.inputPlace.y then table.remove(notes2, i) end
    end
    for i, note in ipairs(notes3) do
        note.y = note.y + 500 * dt
        note.x = GameVars.inputPlace3.x
        if note.y >= GameVars.inputPlace.y then table.remove(notes3, i) end
    end
    for i, note in ipairs(notes4) do
        note.y = note.y + 500 * dt
        note.x = GameVars.inputPlace4.x
        if note.y >= GameVars.inputPlace.y then table.remove(notes4, i) end
    end
end

function game:keypressed(key, code)
    if key == love.filesystem.read("key1") or key == "left" then
        Timer.script(function(wait)
            isHot = true
            wait(1)
            isHot = false
        end)
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
    if key == "1" then newNote(1, 0) end
    if key == "2" then newNote(2, 0) end
    if key == "3" then newNote(3, 0) end
    if key == "4" then newNote(4, 0) end
end

function game:mousepressed(x, y, mbutton) end

function game:draw()
    Graphics.setColor(1, 1, 1, alpha.alpha)
    love.graphics.circle("line", GameVars.inputPlace.x, GameVars.inputPlace.y,
                         GameVars.inputPlace.size)
    love.graphics.circle("line", GameVars.inputPlace2.x, GameVars.inputPlace2.y,
                         GameVars.inputPlace2.size)
    love.graphics.circle("line", GameVars.inputPlace3.x, GameVars.inputPlace3.y,
                         GameVars.inputPlace3.size)
    love.graphics.circle("line", GameVars.inputPlace4.x, GameVars.inputPlace3.y,
                         GameVars.inputPlace4.size)
    love.graphics.line(love.graphics.getWidth() / 2 - 150, 0,
                       love.graphics.getWidth() / 2 - 150,
                       love.graphics.getHeight())
    love.graphics.line(love.graphics.getWidth() / 2 + 150, 0,
                       love.graphics.getWidth() / 2 + 150,
                       love.graphics.getHeight())
    love.graphics.line(love.graphics.getWidth() / 2 - 150, 0,
                       love.graphics.getWidth() / 2 + 150, 0)
    love.graphics.line(love.graphics.getWidth() / 2 - 150,
                       love.graphics.getHeight(),
                       love.graphics.getWidth() / 2 + 150,
                       love.graphics.getHeight())
    for i, note in ipairs(notes) do
        Graphics.setColor(1, 1, 1, math.random(0.4, 1))
        love.graphics.line(note.x, note.y, 0, 0)
        Graphics.setColor(1, 1, 1)
        love.graphics.circle("fill", GameVars.inputPlace.x, note.y, 30)
        if isHot then
            love.graphics.circle("fill", GameVars.inputPlace.x,
                                 GameVars.inputPlace.y, GameVars.inputPlace.size)
        end
    end
    for i, note in ipairs(notes2) do
        love.graphics.circle("fill", GameVars.inputPlace2.x, note.y, 30)
    end
    for i, note in ipairs(notes3) do
        love.graphics.circle("fill", GameVars.inputPlace3.x, note.y, 30)
    end
    for i, note in ipairs(notes4) do
        love.graphics.circle("fill", GameVars.inputPlace4.x, note.y, 30)
    end
end

function game:resize(w, h)
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    GameVars.inputPlace.y = love.graphics.getHeight() - 50
    GameVars.inputPlace.x = love.graphics.getWidth() / 2 - 110
    GameVars.inputPlace2.y = love.graphics.getHeight() - 50
    GameVars.inputPlace2.x = love.graphics.getWidth() / 2 - 40
    GameVars.inputPlace3.y = love.graphics.getHeight() - 50
    GameVars.inputPlace3.x = love.graphics.getWidth() / 2 + 40
    GameVars.inputPlace4.y = love.graphics.getHeight() - 50
    GameVars.inputPlace4.x = love.graphics.getWidth() / 2 + 110
    print('game was resized... | ' .. w .. " | " .. h)
end

function newNote(row, offset)
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
            y = 0
            -- y = GameVars.inputPlace2.y + offset + 1000
        }
    end
    if row == 3 then
        notes3[noteID3] = {
            x = GameVars.inputPlace3.x,
            y = 0
            -- y = GameVars.inputPlace3.y + offset + 1000
        }
    end
    if row == 4 then
        notes4[noteID4] = {
            x = GameVars.inputPlace4.x,
            y = 0
            -- y = GameVars.inputPlace4.y + offset + 1000
        }
    end
end

return game, note
