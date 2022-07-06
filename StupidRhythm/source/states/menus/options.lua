local state = {}

local y = 0
local x = 0

local utf8 = require "utf8"

local selects = {"Toggle VSync - " .. tostring(love.window.getVSync()), "Back"}
local selectsExplain = {"More frames at the cost of stableness", "Go back to the main menu"}
local curSelect = 1

function state.enter()
    presence.details = "in options menu"
end

function state.update(dt)
    grid.update(dt)
end

function state.draw()
    grid.draw()
    for i, v in ipairs(selects) do
        if i == curSelect then
            love.graphics.setColor(255, 255, 255)
        else
            love.graphics.setColor(255, 255, 255, 127.5)
        end
        love.graphics.printf(v, vcr50, 10,
            love.graphics.getHeight() / 2 - 30 - vcr50:getHeight(v) * (#selects - 1) / 2 + i * vcr50:getHeight(v) -
                vcr50:getHeight(v) / 2, love.graphics.getWidth())
    end
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(),
        revamped32:getHeight(selectsExplain[curSelect] or "There is currently no text here"))
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(selectsExplain[curSelect] or "There is currently no text here", revamped32, love.graphics
        .getWidth() / 2 - revamped32:getWidth(selectsExplain[curSelect] or "There is currently no text here") / 2, 0)
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
        if curSelect == 1 then
            local _, _2, _3, _4 = readSave()
            local newVSync = not love.window.getVSync()
            saveGame(_, newVSync, _3, _4)
            setSave()
        elseif curSelect == 2 then
            stateManager:switch("main", true)
        end
        selects = {"Toggle VSync - " .. tostring(love.window.getVSync()), "Back"}
    end
end

return state
