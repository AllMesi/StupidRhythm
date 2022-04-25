local stars = {}
local _star = {}

local going = false

function stars:update(dt)
    if going then
        _addStar()
        for i, v in ipairs(_star) do
            if v.y > love.graphics.getHeight() + 50 then
                table.remove(_star, i)
            end
            if v.y < 0 then
                table.remove(_star, i)
            end
            v.y = v.y + v.speed * dt
            v.angle = v.angle + v.angleSpeed * dt
            if v.alpha < v.endAlpha then
                v.alpha = v.alpha + 0.05
            end
        end
    end
end

function _addStar()
    table.insert(_star, {
        x = love.math.random(0, love.graphics.getWidth()),
        y = 10,
        speed = love.math.random(100, 200),
        colour = {love.math.random(0, 255) / 255, love.math.random(0, 255) / 255, love.math.random(0, 255) / 255},
        angle = 0,
        radius = love.math.random(5, 15),
        angleSpeed = love.math.random(-5, 5),
        alpha = 0,
        endAlpha = math.random(0.5, 1)
    })
end

function stars:init(angleSpeed)
    Timer.after(2, function()
        going = true
    end)
end

function stars:uninit(angleSpeed)
    going = false
    _clear()
end

function stars:draw()
    for i, v in ipairs(_star) do
        love.graphics.setColor(1, 1, 1, v.alpha)
        _drawRotatedRectangle("fill", v.x, v.y, v.radius, v.radius, v.angle)
    end
end

function _clear()
    _star = {}
end

function _drawRotatedRectangle(mode, x, y, width, height, angle)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(angle)
    love.graphics.rectangle(mode, -width / 2, -height / 2, width, height)
    love.graphics.pop()
end

return stars
