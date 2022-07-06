local button = {}
local buttons = {}

function button.draw()
    for i, v in ipairs(buttons) do
        local r, g, b, a = love.graphics.getColor()
        love.graphics.setColor(unpack(v.colour[2]))
        love.graphics.rectangle("fill", v.x, v.y, v.w, v.h, 2)
        love.graphics.setColor(unpack(v.colour[1]))
        love.graphics.print(v.text, v.x + v.w / 2 - love.graphics.getFont():getWidth(v.text) / 2,
            v.y + v.h / 2 - love.graphics.getFont():getHeight() / 2)
        love.graphics.setColor(r, g, b, a)
    end
end

function button.pressed(x, y, button)
    if button == 1 then
        for i, v in ipairs(buttons) do
            if x > v.x and x < v.x + v.w and y > v.y and y < v.y + v.h then
                v.fn()
            end
        end
    end
end

function button.update()
    local mx, my = love.mouse.getPosition()
    for i, v in ipairs(buttons) do
        if mx > v.x and mx < v.x + v.w and my > v.y and my < v.y + v.h then
            v.colour = {{10, 10, 10}, {255, 255, 255}}
        else
            v.colour = {{10, 10, 10}, {200, 200, 200}}
        end
    end
end

function button.new(text, fn, x, y, width, height)
    table.insert(buttons, {
        text = text,
        fn = fn,
        x = x,
        y = y,
        colour = {{0, 0, 0}, {0, 0, 0}},
        w = width,
        h = height
    })
end

return button
