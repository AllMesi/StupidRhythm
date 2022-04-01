local hudCircles = {}

function hudCircles:update(dt) end

function hudCircles:draw()
    if GameVars.inputPlace.size < 31 then
        GameVars.inputPlace.size = GameVars.inputPlace.size + 0.5
    end
    if GameVars.inputPlace2.size < 31 then
        GameVars.inputPlace2.size = GameVars.inputPlace2.size + 0.5
    end
    if GameVars.inputPlace3.size < 31 then
        GameVars.inputPlace3.size = GameVars.inputPlace3.size + 0.5
    end
    if GameVars.inputPlace4.size < 31 then
        GameVars.inputPlace4.size = GameVars.inputPlace4.size + 0.5
    end

    love.graphics.circle("line", GameVars.inputPlace.x, GameVars.inputPlace.y,
                         GameVars.inputPlace.size)

    love.graphics.circle("line", GameVars.inputPlace2.x, GameVars.inputPlace2.y,
                         GameVars.inputPlace2.size)

    love.graphics.circle("line", GameVars.inputPlace3.x, GameVars.inputPlace3.y,
                         GameVars.inputPlace3.size)

    love.graphics.circle("line", GameVars.inputPlace4.x, GameVars.inputPlace4.y,
                         GameVars.inputPlace4.size)

    if GameVars.second then
        love.graphics.circle("line", GameVars.inputPlace5.x,
                             GameVars.inputPlace5.y, GameVars.inputPlace5.size)

        love.graphics.circle("line", GameVars.inputPlace6.x,
                             GameVars.inputPlace6.y, GameVars.inputPlace6.size)

        love.graphics.circle("line", GameVars.inputPlace7.x,
                             GameVars.inputPlace7.y, GameVars.inputPlace7.size)

        love.graphics.circle("line", GameVars.inputPlace8.x,
                             GameVars.inputPlace8.y, GameVars.inputPlace8.size)
    end
end

return hudCircles
