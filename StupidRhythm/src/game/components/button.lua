local button = {}
local buttons = {}

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
            colour = {0.19607843137, 0.6, 0.73333333333}
            colour2 = {0, 0, 0}
        end
        
        if canPress and button.now and not button.last and hot then
            button.fn()
        end
        
        gr.setColour(unpack(colour))
        
        love.graphics.rectangle("fill", x, y, buttonWidth, button.buttonHeight, 10)
        
        gr.setColour(0, 0, 0)
        
        local textWidth = revamped32:getWidth(button.text)
        local textHeight = revamped32:getHeight(button.text)
        
        gr.setColour(unpack(colour2))
        
        gr.print(
            button.text,
            revamped32,
            (ww / 2) - textWidth / 2,
            y + (button.buttonHeight / 2) - textHeight / 2 + 2
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

return button
