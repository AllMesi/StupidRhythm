local button = {}

local font = gr.newFont(32)

local canPress = false

local countToPress = 0.5

function returnButton(text, fn, xoffset, yoffset, height)
    return {
        text = text,
        fn = fn,
        now = false,
        last = false,
        yoffset = yoffset,
        xoffset = xoffset,
        buttonHeight = height
    }
end

function button:new(text, fn, xoffset, yoffset, height)
    if not xoffset then
        xoffset = 0
    end
    if not yoffset then
        yoffset = 0
    end
    if not height then
        height = 64
    end
    table.insert(buttons, returnButton(text, fn, xoffset, yoffset, height))
end

function button:update(dt)
    countToPress = countToPress - 0.1
    if countToPress <= 0 then
        canPress = true
    end
    buttonWidth = ww * (1 / 5)
end

function button:draw()
    local cursor_y = 0
    
    local margin = 16
    
    for i, button in ipairs(buttons) do
        local totalHeight = (button.buttonHeight + margin) * #buttons
        
        button.last = button.now
        
        button.now = love.mouse.isDown(1) or love.mouse.isDown(2)
        
        local x = (ww / 2) - (buttonWidth / 2) + button.xoffset
        
        local y = (wh / 2) - (totalHeight / 2) + cursor_y + button.yoffset
        
        local colour = {0, 0, 0}
        local colour2 = {1, 1, 1}
        
        local hot = love.mouse.getX() > x and love.mouse.getX() < x + buttonWidth and
            love.mouse.getY() > y and love.mouse.getY() < y + button.buttonHeight
        
        if canPress and hot then
            colour = {1, 1, 1}
            colour2 = {0, 0, 0}
        end
        
        if canPress and button.now and not button.last and hot then
            button.fn()
        end
        
        gr.setColour(1, 1, 1)
        
        love.graphics.roundrectangle("fill", x - 1, y - 1, buttonWidth + 2, button.buttonHeight + 2, 10, 100)
        
        gr.setColour(unpack(colour))
        
        love.graphics.roundrectangle("fill", x, y, buttonWidth, button.buttonHeight, 10, 100)
        
        gr.setColour(0, 0, 0)
        
        local textWidth = font:getWidth(button.text)
        local textHeight = font:getHeight(button.text)
        
        gr.setColour(unpack(colour2))
        
        gr.print(
            button.text,
            font,
            (ww / 2) - textWidth / 2,
            y + (button.buttonHeight / 2) - textHeight / 2
        )
        cursor_y = cursor_y + (button.buttonHeight + margin)
    end
end

function button:clear()
    buttons = {}
    canPress = false
    countToPress = 1
    if countToPress <= 0 then
        canPress = true
    end
end

function love.graphics.roundrectangle(mode, x, y, w, h, rd, s)
    local r, g, b, a = love.graphics.getColor()
    local rd = rd or math.min(w, h) / 4
    local s = s or 32
    local l = love.graphics.getLineWidth()
    
    local corner = 1
    local function stencilol()
        love.graphics.setColor(255, 255, 255, 255)
        if corner == 1 then
            love.graphics.rectangle("fill", x - l, y - l, rd + l, rd + l)
        elseif corner == 2 then
            love.graphics.rectangle("fill", x + w - rd + l, y - l, rd + l, rd + l)
        elseif corner == 3 then
            love.graphics.rectangle("fill", x - l, y + h - rd + l, rd + l, rd + l)
        elseif corner == 4 then
            love.graphics.rectangle("fill", x + w - rd + l, y + h - rd + l, rd + l, rd + l)
        elseif corner == 0 then
            love.graphics.rectangle("fill", x + rd, y - l, w - 2 * rd + l, h + 2 * l)
            love.graphics.rectangle("fill", x - l, y + rd, w + 2 * l, h - 2 * rd + l)
        end
    end
    
    love.graphics.stencil(stencilol)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.setColor(r, g, b, a)
    love.graphics.circle(mode, x + rd, y + rd, rd, s)
    love.graphics.setStencilTest()
    corner = 2
    love.graphics.stencil(stencilol)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.setColor(r, g, b, a)
    love.graphics.circle(mode, x + w - rd, y + rd, rd, s)
    corner = 3
    love.graphics.stencil(stencilol)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.setColor(r, g, b, a)
    love.graphics.circle(mode, x + rd, y + h - rd, rd, s)
    love.graphics.setStencilTest()
    corner = 4
    love.graphics.stencil(stencilol)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.setColor(r, g, b, a)
    love.graphics.circle(mode, x + w - rd, y + h - rd, rd, s)
    love.graphics.setStencilTest()
    corner = 0
    love.graphics.stencil(stencilol)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.setColor(r, g, b, a)
    love.graphics.rectangle(mode, x, y, w, h)
    love.graphics.setStencilTest()
end

return button
