local state = {}

local selects = {"Play", "Options", "Quit"}
local selectsExplain = {"Goes To The SongSelect Screen", "Options Menu", "Quit The Game"}
local curSelect = 1

function state.enter()
    presence.details = "in main menu"
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
            stateManager:switch("songSelect", true)
        elseif curSelect == 2 then
            stateManager:switch("options", true)
        elseif curSelect == 3 then
            stateManager:switch("quit", true)
        end
    end
    if key == "a" then
        stateManager:switch("quit", true)
    end
end

return state
