local state = {}

local selects = {}
local curSelect = 1

local saveCurSelect = 1

local yMenuStart = 0
local yOffset = 0

function state.preenter()
    local files = love.filesystem.getDirectoryItems("assets/songs")
    for i, v in ipairs(files) do
        table.insert(selects, v)
    end
    table.insert(selects, "back")
    curSelect = saveCurSelect
    presence = {
        state = "in game",
        details = "looking for a song...",
        startTimestamp = 0,
        endTimestamp = os.time()
    }
end

function state.update(dt)
    grid.update(dt)
    yMenuStart = love.graphics.getHeight() / 2
    yOffset = yMenuStart - revamped32:getHeight(selects[curSelect])
end

function state.draw()
    grid.draw()
    for i, v in ipairs(selects) do
        if i == curSelect then
            love.graphics.setColor(50, 153, 187)
        else
            love.graphics.setColor(255, 255, 255)
        end
        love.graphics.print(v, revamped50, 10, yMenuStart + revamped50:getHeight(v) * (#selects - 1) / 2 + i *
            revamped50:getHeight(v) + yOffset)
    end
    love.graphics.setColor(0, 0, 0)
    if curSelect ~= #selects then
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), revamped32:getHeight("Choose A Song."))
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("Choose A Song.", revamped32,
            love.graphics.getWidth() * 0.5 - revamped32:getWidth("Choose A Song.") / 2, 0)
    else
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), revamped32:getHeight("..Or go back"))
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("..Or go back", revamped32,
            love.graphics.getWidth() * 0.5 - revamped32:getWidth("..Or go back") / 2, 0)
    end
end

function state.exit()
    saveCurSelect = curSelect
    selects = {}
    curSelect = 1
end

function state.keypressed(key)
    if key == "up" then
        if curSelect > 1 then
            curSelect = curSelect - 1
        else
            curSelect = #selects
        end
    end
    if key == "down" then
        if curSelect < #selects then
            curSelect = curSelect + 1
        else
            curSelect = 1
        end
    end
    if key == "return" or key == "kpenter" then
        -- thanks github copilot for being smarter than me
        if curSelect == #selects then
            stateManager:switch("main", true)
        else
            print("Loading song: " .. selects[curSelect])
            curSong.name = selects[curSelect]
            stateManager:switch("game", true)
        end
    end
end

function state.wheelmoved(x, y)
    yOffset = yOffset + y * 40
end

return state
