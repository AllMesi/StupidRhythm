local loading = {}

function loading:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(revamped50)
    love.graphics.printf(loadingText, 0, love.graphics.getHeight() / 2 - 30, love.graphics.getWidth(), 'center')
    love.graphics.setColor(1, 1, 1)
end

return loading
