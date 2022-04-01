local hudLines = {}

function hudLines:update(dt) end

function hudLines:draw()
    love.graphics.line(love.graphics.getWidth() / 2 - 150, 0,
                       love.graphics.getWidth() / 2 - 150,
                       love.graphics.getHeight())

    love.graphics.line(love.graphics.getWidth() / 2 + 150, 0,
                       love.graphics.getWidth() / 2 + 150,
                       love.graphics.getHeight())

    love.graphics.line(love.graphics.getWidth() / 2 - 150, 0,
                       love.graphics.getWidth() / 2 + 150, 0)

    love.graphics.line(love.graphics.getWidth() / 2 - 150,
                       love.graphics.getHeight(),
                       love.graphics.getWidth() / 2 + 150,
                       love.graphics.getHeight())

    if GameVars.second then
        love.graphics.line(love.graphics.getWidth() / 2 - 650, 0,
                           love.graphics.getWidth() / 2 - 650,
                           love.graphics.getHeight())

        love.graphics.line(love.graphics.getWidth() / 2 - 350, 0,
                           love.graphics.getWidth() / 2 - 350,
                           love.graphics.getHeight())
    end
end

return hudLines
