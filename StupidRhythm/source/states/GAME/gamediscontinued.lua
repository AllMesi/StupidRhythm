local state = {}

local moonshine = require "libs.moonshine"

local combo = 0

local misses = 0

local auto = true

local squares = {}

local paused = false

local area = {
    s = 10,
    e = love.graphics.getHeight() - 10
}

local glowEffect = moonshine(moonshine.effects.glow)

local time = 0.5

function state.enter()
    combo = 0
    misses = 0
    glowEffect = moonshine(moonshine.effects.glow)
end

function state.update(dt)
    if not paused then
        if love.mouse.getX() < love.graphics.getWidth() / 2 - 500 + area.s then
            love.mouse.setPosition(love.graphics.getWidth() / 2 - 500 + area.s, love.mouse.getY())
        end
        if love.mouse.getX() > love.graphics.getWidth() / 2 + 500 - area.s then
            love.mouse.setPosition(love.graphics.getWidth() / 2 + 500 - area.s, love.mouse.getY())
        end
        if love.mouse.getY() < area.s * 2 then
            love.mouse.setPosition(love.mouse.getX(), area.s * 2)
        end
        if love.mouse.getY() > love.graphics.getHeight() - area.s * 2 then
            love.mouse.setPosition(love.mouse.getX(), love.graphics.getHeight() - area.s * 2)
        end
        if auto then
            gameCam:lookAt(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
            love.mouse.setPosition(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
        end
        for i, square in ipairs(squares) do
            square.alpha = square.alpha + dt * 255
            square.size = square.size + dt * 100
            if square.size > 100 then
                square.size = 100
            end
            if square.alpha > 255 then
                square.alpha = 255
                if auto then
                    love.mouse.setPosition(square.x + 50, square.y + 50)
                end
            end
            if square.alpha >= 255 and love.mouse.getX() >= square.x and love.mouse.getX() <= square.x + square.size and
                love.mouse.getY() >= square.y and love.mouse.getY() <= square.y + square.size then
                table.remove(squares, i)
                combo = combo + 1
            elseif square.alpha >= 255 and love.mouse.getX() ~= square.x and love.mouse.getX() ~= square.x + square.size and
                love.mouse.getY() ~= square.y and love.mouse.getY() ~= square.y + square.size then
                table.remove(squares, i)
                combo = 0
                misses = misses + 1
            end
        end
    end
end

function state.draw()
    gameCam:attach()
    if auto then
        love.graphics.print("AutoPlay", revamped32, love.graphics.getWidth() / 2 - revamped32:getWidth("AutoPlay") / 2,
            love.graphics.getHeight() / 1.5)
    end
    love.graphics.setLineWidth(5)
    for i, square in ipairs(squares) do
        love.graphics.setColor(255, 255, 255, square.alpha)
        love.graphics
            .rectangle("line", square.x - square.size / 2, square.y - square.size / 2, square.size, square.size)
    end
    love.graphics.setColor(255, 255, 255)
    love.graphics.setLineWidth(1)
    love.graphics.linerectangle(love.graphics.getWidth() / 2 - 500, 10, love.graphics.getWidth() / 2 + 500,
        love.graphics.getHeight() - 10)
    love.graphics.rectangle("line", love.mouse.getX() - 10, love.mouse.getY() - 10, 20, 20)
    gameCam:detach()
    love.graphics.print("Combo: " .. combo .. "\nMisses: " .. misses, 100, 100)
end

function state.keypressed(key)
    if key == "escape" then
        stateManager:switch(states.main)
    end
    if key == "tab" then
        love.mouse.setVisible(not love.mouse.isVisible())
    end
    if key == "space" then
        paused = not paused
    end
    if key == "a" then
        auto = not auto
        if not auto then
            love.mouse.setPosition(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
        end
    end
    if key == "l" then
        table.insert(squares, {
            x = math.random(love.graphics.getWidth() / 2 - 500 + 10, love.graphics.getWidth() / 2 + 500 - 110),
            y = math.random(10, love.graphics.getHeight() - 100),
            alpha = 0,
            size = 0
        })
    end
end

function love.resize()
    glowEffect = moonshine(moonshine.effects.glow)
end

return state
