local flash = {
    start = function(self, x, y, initialRadius)
        x = x or love.math.random(0, love.graphics.getWidth())
        y = y or love.math.random(0, love.graphics.getHeight())
        initialRadius = initialRadius or 5
        table.insert(self.flashes, {
            radius = initialRadius,
            x = x,
            y = y,
            alpha = 255
        })
    end,
    draw = function(self)
        for i, v in ipairs(self.flashes) do
            local r, g, b, a = love.graphics.getColor()
            love.graphics.setColor(255, 255, 255, v.alpha)
            love.graphics.circle("fill", v.x, v.y, v.radius)
            love.graphics.setColor(r, g, b, a)
        end
    end,
    update = function(self, elapsed)
        for i, v in ipairs(self.flashes) do
            v.alpha = v.alpha - 255 * elapsed
            v.radius = v.radius + 100 * elapsed
            if v.alpha < 0 then
                table.remove(self.flashes, i)
            end
        end
    end,
    flashes = {}
}

return flash
