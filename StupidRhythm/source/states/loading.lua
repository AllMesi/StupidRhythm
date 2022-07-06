local loading = {}

local circles = {}

local spin = 0
local finished = false
local multiLoad

function loading.enter()
    multiLoad = lily.loadMulti({{"newImage", "images/logo.png"}, {"newImage", "images/sb.png"},
                                {"newImage", "images/grid.png"}, {"newImage", "images/grid2.png"},
                                {"newImage", "images/thing.png"}, {"newImage", "images/gradient.png"},
                                {"newImage", "images/transparent.png"}, {"newImage", "images/notes/note1.png"},
                                {"newImage", "images/notes/note2.png"}, {"newImage", "images/notes/note3.png"},
                                {"newImage", "images/notes/note4.png"}, {"newImage", "images/notes/note1-hurt.png"},
                                {"newImage", "images/notes/note2-hurt.png"},
                                {"newImage", "images/notes/note3-hurt.png"}, {"newImage", "images/notes/note4-hurt.png"},
                                {"newImage", "images/notes/noten.png"}})
    multiLoad:onComplete(function(_, stuff)
        images.notes = {}
        images.logo = stuff[1][1]
        images.sb = stuff[2][1]
        images.thing = stuff[5][1]
        images.gradient = stuff[6][1]
        images.notes.n1 = stuff[8][1]
        images.notes.n2 = stuff[9][1]
        images.notes.n3 = stuff[10][1]
        images.notes.n4 = stuff[11][1]
        images.notes.n1h = stuff[12][1]
        images.notes.n2h = stuff[13][1]
        images.notes.n3h = stuff[14][1]
        images.notes.n4h = stuff[15][1]
        images.notes.nn = stuff[16][1]
        finished = true
        stateManager:switch("main")
        love.window.setAlpha(1)
        print = function(...)
            love.filesystem.createDirectory("/logfiles/" .. gameStarted)
            for i, v in ipairs({...}) do
                io.write("[" .. os.date("%H:%M %p") .. " | StupidRhythm] " .. tostring(v) .. "\n")
                love.filesystem.append("logfiles/" .. gameStarted .. "/log.log",
                    "[" .. os.date("%H:%M %p") .. " | StupidRhythm] " .. tostring(v) .. "\n")
            end
        end
    end)
end

function loading.update(dt)
    if not finished then
        spin = spin + 400 * dt
        for i, v in ipairs(circles) do
            v.alpha = v.alpha - dt * 2000
            v.rad = 10
            if v.alpha < 0 then
                table.remove(circles, i)
            end
        end
        for i = 0, 3 do
            local angle = i * (math.pi * 2 / 3) + math.rad(spin)
            local x = love.graphics.getWidth() / 2 + math.cos(angle) * 50
            local y = love.graphics.getHeight() / 2 + math.sin(angle) * 50
            local circle = {}
            circle.x, circle.y = x, y
            circle.alpha = 255
            circle.rad = 10
            table.insert(circles, circle)
        end
    end
    love.window.setAlpha(multiLoad:getLoadedCount() / multiLoad:getCount())
end

function loading.draw()
    love.graphics.circle("line", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 50)
    for i, v in ipairs(circles) do
        local r, g, b, a = love.graphics.getColor()
        love.graphics.setColor(255, 255, 255, v.alpha)
        love.graphics.circle("fill", v.x, v.y, v.rad)
        love.graphics.setColor(r, g, b, a)
    end
    if not finished then
        local percent = 0
        if multiLoad:getCount() ~= 0 then
            percent = multiLoad:getLoadedCount() / multiLoad:getCount()
        end
        love.graphics.setColor(255, 255, 255)
        love.graphics.print(("Loading .. %d%%"):format(percent * 100), revamped12, love.graphics.getWidth() / 2 -
            revamped12:getWidth(("Loading .. %d%%"):format(percent * 100)) / 2, love.graphics.getHeight() / 2 +
            revamped12:getHeight(("Loading .. %d%%"):format(percent * 100)) + 170)
        love.graphics.rectangle("line", love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 + 200, 200,
            10, 5)
        if percent * 100 > 5 then
            love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 + 200,
                percent * 200, 10, 5)
        end
    end
end

return loading
