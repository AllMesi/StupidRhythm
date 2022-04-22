local loading = {}
local font = love.graphics.newFont("fonts/COMIC.ttf", 50)

function loading:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(font)
    love.graphics.printf('LOADING...\nDont worry if the window shows \'Not Responding\'', 0,
        love.graphics.getHeight() / 2 - 30, love.graphics.getWidth(), 'center')
    love.graphics.setColor(1, 1, 1)
end

return loading
