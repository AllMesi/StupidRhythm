local panic = false
local panicText = "could not find game/main.lua!"
love.filesystem.mount(love.filesystem.getSourceBaseDirectory(), "")
if not love.filesystem.getInfo("game/main.lua") then
    panic = true
    love.window.setMode(love.graphics.getWidth() / 2 - love.graphics.newFont(12):getWidth(panicText) / 2,
        love.graphics.getHeight() / 2 - love.graphics.newFont(12):getHeight(panicText) / 2, {
            borderless = true
        })
else
    require "game.main"
end
if panic then
    love.draw = function()
        love.graphics.print(panicText, love.graphics.getWidth() / 2 - love.graphics.newFont(12):getWidth(panicText) / 2,
            love.graphics.getHeight() / 2 - love.graphics.newFont(12):getHeight(panicText) / 2)
    end
end
