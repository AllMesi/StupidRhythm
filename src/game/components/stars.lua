local stars = {}
local star = {}

function stars:update(dt)
    table.insert(star, {
        x = love.math.random(0, love.graphics.getWidth()),
        y = 0,
        speed = love.math.random(100, 200),
        colour = {love.math.random(0, 255) / 255, love.math.random(0, 255) / 255, love.math.random(0, 255) / 255},
        angle = 0,
        radius = love.math.random(5, 15),
        angleSpeed = love.math.random(-5, 5),
        alpha = math.random(0.5, 1)
    })
    for i, v in ipairs(star) do
        if v.y > love.graphics.getHeight() then
            table.remove(star, i)
        end
        if v.x < 0 then
            table.remove(star, i)
        end
        if v.x > love.graphics.getWidth() then
            table.remove(star, i)
        end
        if v.y < 0 then
            table.remove(star, i)
        end
        v.y = v.y + v.speed * dt
        v.angle = v.angle + v.angleSpeed * dt
    end
end

function stars:draw()
    for i, v in ipairs(star) do
        love.graphics.setColor(1, 1, 1, v.alpha)
        drawRotatedRectangle("fill", v.x, v.y, v.radius, v.radius, v.angle)
    end
    -- Components.loading:draw()
end

function stars:clear()
    star = {}
end

function drawRotatedRectangle(mode, x, y, width, height, angle)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(angle)
    love.graphics.rectangle(mode, -width / 2, -height / 2, width, height)
    love.graphics.pop()
end

return stars
