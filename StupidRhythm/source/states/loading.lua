local loading = {}

local circles = {}

local spin = 0

function loading.enter()
    finishedLoading = false
    loadingFunction()

    LoveLoader.start(function()
        loadingFunctionAfter()
        finishedLoading = true
    end)
end

function loading.update(dt)
    if not finishedLoading then
        LoveLoader.update()
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
end

function loading.draw()
    love.graphics.circle("line", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 50)
    for i, v in ipairs(circles) do
        local r, g, b, a = love.graphics.getColor()
        love.graphics.setColor(50, 153, 187, v.alpha)
        love.graphics.circle("fill", v.x, v.y, v.rad)
        love.graphics.setColor(r, g, b, a)
    end
    local percent = 0
    if LoveLoader.resourceCount ~= 0 then
        percent = LoveLoader.loadedCount / LoveLoader.resourceCount
    end
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(("Loading .. %d%%"):format(percent * 100), love.graphics.getWidth() / 2 -
        revamped12:getWidth(("Loading .. %d%%"):format(percent * 100)) / 2, love.graphics.getHeight() / 2 +
        revamped12:getHeight(("Loading .. %d%%"):format(percent * 100)) + 170)
    love.graphics.rectangle("line", love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 + 200, 200, 10, 5)
    if percent * 100 > 5 then
        love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 + 200,
            percent * 200, 10, 5)
    end
end

return loading
