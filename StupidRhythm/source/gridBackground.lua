local grid = {}

local y = 0
local x = 0

local gridImage
local gridQuad

local init = false

function grid.update(dt)
    if init then
        y = y - 50 * dt
        x = x - 50 * dt
        gridQuad:setViewport(x, y, love.graphics:getWidth(), love.graphics:getHeight())
    end
end

function grid.changeImage(image)
    gridImage = love.graphics.newImage(image)
    gridImage:setWrap("repeat", "repeat")
    gridQuad = love.graphics.newQuad(0, 0, love.graphics.getWidth(), love.graphics.getHeight(), gridImage:getWidth(),
        gridImage:getHeight())
end

function grid.init()
    gridImage = love.graphics.newImage("assets/images/grid2.png")
    gridImage:setWrap("repeat", "repeat")
    gridQuad = love.graphics.newQuad(0, 0, love.graphics.getWidth(), love.graphics.getHeight(), gridImage:getWidth(),
        gridImage:getHeight())
    init = true
end

function grid.draw()
    if init then
        love.graphics.draw(gridImage, gridQuad, 0, 0)
        love.graphics.setColor(255, 255, 255, 30)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(images.thing, 0, 0, 0, (love.graphics.getWidth() / images.thing:getWidth()),
            (love.graphics.getHeight() / images.thing:getHeight()))
    end
end

return grid
