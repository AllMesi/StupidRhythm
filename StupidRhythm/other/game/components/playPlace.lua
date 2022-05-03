local playPlace = {}

function playPlace:draw()
    Components.hud:draw()
    Components.note:draw()
    local c = health / healthMax
    local colour = {2 - 2 * c, 2 * c, 0}
    love.graphics.setColor(colour)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', love.graphics.getWidth() / 2 - healthMax / 2, 1.5 * 32, healthMax, 32 / 2, 5, 5)
    love.graphics.setColor(colour)
    if health > healthMax then
        love.graphics.rectangle('fill', love.graphics.getWidth() / 2 - healthMax / 2, 1.5 * 32, healthMax, 32 / 2, 5, 5)
    else
        love.graphics.rectangle('fill', love.graphics.getWidth() / 2 - healthMax / 2, 1.5 * 32, health, 32 / 2, 5, 5)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('line', love.graphics.getWidth() / 2 - healthMax / 2, 1.5 * 32, healthMax, 32 / 2, 5, 5)
    if health > healthMax then
        love.graphics.printf("Misses: " .. misses .. " // Accuracy: - // Score: " .. math.floor(scores.score) .. " // Health: 100%", 0, 0,
            love.graphics.getWidth(), "center")
    else
        love.graphics.printf("Misses: " .. misses .. " // Accuracy: - // Score: " .. math.floor(scores.score) .. " // Health: " ..
                                 tostring(math.floor(health)):sub(1, -2) .. "%", 0, 0, love.graphics.getWidth(),
            "center")
    end
end

return playPlace
