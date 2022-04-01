local hudLinesOutLines = {}

function hudLinesOutLines:update(dt) end

function hudLinesOutLines:draw()
    love.graphics.line(0, 0, love.graphics.getWidth(), 0)

    love.graphics.line(0, 0, 0, love.graphics.getHeight())

    love.graphics.line(love.graphics.getWidth(), 0, love.graphics.getWidth(),
                       love.graphics.getHeight())

    love.graphics.line(0, love.graphics.getHeight(), love.graphics.getWidth(),
                       love.graphics.getHeight())
end

return hudLinesOutLines
