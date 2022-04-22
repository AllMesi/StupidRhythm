local sources = {}

function print(str)
    if not love.filesystem.getInfo(love.filesystem.getSourceBaseDirectory() .. "/logfiles") then
        love.filesystem.createDirectory(love.filesystem.getSourceBaseDirectory() .. "/logfiles")
    end
    io.write("[" .. os.date("%H:%M:%S") .. "] " .. str .. "\n")
    table.insert(logs, "[" .. os.date("%H:%M:%S") .. "] " .. str)
    if not love.filesystem.getInfo("logfiles/StupidRhythm-" .. TimeGameOpened .. ".log") then
        love.filesystem.write("logfiles/StupidRhythm-" .. TimeGameOpened .. ".log", "[" .. os.date("%H:%M:%S") .. "] " .. str)
    else
        love.filesystem.append("logfiles/StupidRhythm-" .. TimeGameOpened .. ".log", "\n[" .. os.date("%H:%M:%S") .. "] " .. str)
    end
end

-- function discordRPC.ready(userId, username, discriminator, avatar)
--     print(string.format("Discord: ready (%s, %s, %s, %s)", userId, username, discriminator, avatar))
-- end
-- function discordRPC.disconnected(errorCode, message)
--     print(string.format("Discord: disconnected (%d: %s)", errorCode, message))
-- end
-- function discordRPC.errored(errorCode, message)
--     print(string.format("Discord: error (%d: %s)", errorCode, message))
-- end
-- function discordRPC.joinGame(joinSecret)
--     print(string.format("Discord: join (%s)", joinSecret))
-- end
-- function discordRPC.spectateGame(spectateSecret)
--     print(string.format("Discord: spectate (%s)", spectateSecret))
-- end
-- function discordRPC.joinRequest(userId, username, discriminator, avatar)
--     print(string.format("Discord: join request (%s, %s, %s, %s)", userId, username, discriminator, avatar))
--     discordRPC.respond(userId, "yes")
-- end
function screenshot()
    love.filesystem.createDirectory("screenshots")
    love.graphics.captureScreenshot("screenshots/screenshot-" .. os.time() .. ".png")
end

function playSound(sound)
    for i, source in ipairs(sources) do
        if not source:isPlaying() then
            source:play()
            return
        end
    end
    table.insert(sources, love.audio.newSource("sounds/" .. sound, "static"))
    sources[#sources]:play()
end

function math.round(n, deci)
    deci = 10 ^ (deci or 0)
    return math.floor(n * deci + .5) / deci
end

function fps(set, fps)
    if set then
        CONFIG.FPS = fps
    else
        return ("%3d FPS"):format(1 / love.timer.getDelta())
    end
end

function startGame(name)
    song = name
    Scene.switch(Scenes.game)
end

function showCursor()

end

function hideCursor()

end

local u = 0

function random(x, y)
    u = u + 1
    if x ~= nil and y ~= nil then
        return math.floor(x + (math.random(math.randomseed(os.time() + u)) * 999999 % y))
    else
        return math.floor((math.random(math.randomseed(os.time() + u)) * 100))
    end
end

function love.graphics.roundrectangle(mode, x, y, w, h, rd, s)
    local r, g, b, a = love.graphics.getColor()
    local rd = rd or math.min(w, h) / 4
    local s = s or 32
    local l = love.graphics.getLineWidth()
    
    local corner = 1
    local function mystencil()
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
    
    love.graphics.stencil(mystencil)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.setColor(r, g, b, a)
    love.graphics.circle(mode, x + rd, y + rd, rd, s)
    love.graphics.setStencilTest()
    corner = 2
    love.graphics.stencil(mystencil)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.setColor(r, g, b, a)
    love.graphics.circle(mode, x + w - rd, y + rd, rd, s)
    corner = 3
    love.graphics.stencil(mystencil)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.setColor(r, g, b, a)
    love.graphics.circle(mode, x + rd, y + h - rd, rd, s)
    love.graphics.setStencilTest()
    corner = 4
    love.graphics.stencil(mystencil)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.setColor(r, g, b, a)
    love.graphics.circle(mode, x + w - rd, y + h - rd, rd, s)
    love.graphics.setStencilTest()
    corner = 0
    love.graphics.stencil(mystencil)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.setColor(r, g, b, a)
    love.graphics.rectangle(mode, x, y, w, h)
    love.graphics.setStencilTest()
end

function quit()
    love.event.quit(0)
end

function restart()
    love.event.quit("restart")
end

function math.round(num, decimals)
    decimals = math.pow(10, decimals or 0)
    num = num * decimals
    if num >= 0 then num = math.floor(num + 0.5) else num = math.ceil(num - 0.5) end
    return num / decimals
end

function listFiles(dir)
    local files = love.filesystem.getDirectoryItems(dir)
    for k, file in ipairs(files) do
        return file
    end
end
