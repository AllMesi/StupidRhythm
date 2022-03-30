local strums = {}

function strums:update(dt) end

function strums:draw()
    love.graphics.circle("line", GameVars.inputPlace.x, GameVars.inputPlace.y,
                         GameVars.inputPlace.size)
    love.graphics.circle("line", GameVars.inputPlace2.x, GameVars.inputPlace2.y,
                         GameVars.inputPlace2.size)
    love.graphics.circle("line", GameVars.inputPlace3.x, GameVars.inputPlace3.y,
                         GameVars.inputPlace3.size)
    love.graphics.circle("line", GameVars.inputPlace4.x, GameVars.inputPlace3.y,
                         GameVars.inputPlace4.size)
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
end

return strums
