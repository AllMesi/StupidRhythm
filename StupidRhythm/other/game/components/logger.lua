local logs = {}
local logger = {
    _started = false,
    _gameName = "",
    _drawOnScreen = false,
    _startedTime = 0,
    _colour = ""
}

function logger.log(...)
    if logger.started then
        love.filesystem.createDirectory("/logfiles")
        for i, v in ipairs({...}) do
            io.write("[" .. os.date("%H:%M:%S") .. " " .. logger._gameName .. "] " .. v .. "\n")
            table.insert(logs, "[" .. os.date("%H:%M:%S") .. " " .. logger._gameName .. "] " .. v)
            love.filesystem.append("logfiles/" .. logger._gameName .. "-" .. logger._startedTime .. ".log",
                "[" .. os.date("%H:%M:%S") .. " " .. logger._gameName .. "] " .. v .. "\n")
        end
    end
end

function logger.init(gameName, showOnScreen, colour)
    print("Logger initializing...")
    if not logger.started then
        logger._startedTime = os.time()
        logger._gameName = gameName
        logger.started = true
        if showOnScreen then
            logger._drawOnScreen = true
        end
        logger._colour = colour
        logger.log("Logger initialized.")
    else
        logger.log("Logger already initialized.")
    end
end

function logger.uninit()
    logger.log("Logger uninitializing...")
    logger._startedTime = 0
    logger._gameName = ""
    logger._drawOnScreen = false
    logger._colour = ""
    logger._started = false
end

function logger.draw()
    if logger._drawOnScreen then
        love.graphics.setColor(Lume.color(logger._colour))
        for i, v in ipairs(logs) do
            love.graphics.print(v, 0, i * 15)
        end
        love.graphics.setColor(1, 1, 1, 1)
    end
end

return logger
