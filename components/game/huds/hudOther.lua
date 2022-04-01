local hudOther = {}

function hudOther:update(dt) end

function hudOther:draw()
    love.graphics.print(GameVars.rating, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
end

return hudOther
