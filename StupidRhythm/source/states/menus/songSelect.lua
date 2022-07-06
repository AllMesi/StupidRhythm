local state = {}

local curSelect = 1
local selects = {}

local textBox = {
    isInModeName = false,
    isInModeBPM = false,
    textN = "",
    text = ""
}

local song
local options

function state.enter()
    selects = {}
    song = nil
    presence.details = "in songSelect menu"
    refresh()
    readAndChange()
    local data = json.decode(love.filesystem.read("testChart.json"))
    print(data.song.bpm)
    print(data.song.speed)
end

function state.update(dt)
    grid.update(dt)
    refresh()
end

function state.draw()
    grid.draw()
    for i, v in ipairs(selects) do
        if i == curSelect then
            love.graphics.setColor(255, 255, 255)
        else
            love.graphics.setColor(255, 255, 255, 127.5)
        end
        love.graphics.printf(v, vcr50, 10,
            love.graphics.getHeight() / 2 - 30 - vcr50:getHeight(v) * (#selects - 1) / 2 + i * vcr50:getHeight(v) -
                vcr50:getHeight(v) / 2, love.graphics.getWidth())
    end
    love.graphics.setColor(255, 255, 255)
    if song ~= nil then
        if song:isPlaying() then
            love.graphics.rectangle("line", love.graphics.getWidth() / 2 - song:getDuration() / 2, 10,
                song:getDuration(), 30)
            love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - song:getDuration() / 2, 10, song:tell(), 30)
            love.graphics.print(formatTime(song:tell()) .. " / " .. formatTime(song:getDuration()),
                love.graphics.getWidth() / 2 -
                    love.graphics.getFont():getWidth(formatTime(song:tell()) .. " / " .. formatTime(song:getDuration())) /
                    2, 50)
            if options ~= nil then
                love.graphics.print("\nBPM: " .. options.bpm, love.graphics.getWidth() / 2 -
                    love.graphics.getFont():getWidth("\nBPM: " .. options.bpm) / 2, 50)
            end
        end
    end
    if textBox.isInModeName then
        grid.draw()
        love.graphics.printf("Enter song name > " .. textBox.text .. "_", pixel32, 10, 10, love.graphics.getWidth())
    end
    if textBox.isInModeBPM then
        grid.draw()
        love.graphics.printf("Enter BPM > " .. textBox.text .. "_", pixel32, 10, 10, love.graphics.getWidth())
    end
end

function love.textinput(t)
    if textBox.isInModeBPM or textBox.isInModeName then
        textBox.text = textBox.text .. t
    end
end

function state.keypressed(key)
    if key == "up" then
        if curSelect > 1 then
            curSelect = curSelect - 1
        else
            curSelect = #selects
        end
        readAndChange()
    end
    if key == "down" then
        if curSelect < #selects then
            curSelect = curSelect + 1
        else
            curSelect = 1
        end
        readAndChange()
    end
    if key == "return" or key == "kpenter" then
        if not textBox.isInModeName then
            if curSelect == #selects then
                stateManager:switch("main", true)
                song:stop()
                song = nil
            elseif curSelect == #selects - 1 then
                textBox.isInModeName = true
            else
                song:stop()
                stateManager:switch("game", selects[curSelect])
            end
        else
            if textBox.text ~= "" then
                textBox.isInModeName = false
                textBox.isInModeBPM = true
                textBox.textN = textBox.text
                textBox.text = ""
            end
        end
        if textBox.isInModeBPM then
            if tonumber(textBox.text) ~= nil then
                makeNewSong(textBox.textN, tonumber(textBox.text))
                textBox.isInModeName = false
                textBox.isInModeBPM = false
                textBox.text = ""
                textBox.textN = ""
            end
        end
    end
    if key == "backspace" then
        if textBox.isInModeName or textBox.isInModeBPM then
            local byteoffset = utf8.offset(textBox.text, -1)
            if byteoffset then
                textBox.text = string.sub(textBox.text, 1, byteoffset - 1)
            end
        end
    end
    if key == "escape" then
        textBox.isInModeName = false
        textBox.isInModeBPM = false
        textBox.text = ""
        textBox.textN = ""
    end
end

function refresh()
    selects = {}
    local files = love.filesystem.getDirectoryItems("songs")
    for k, file in ipairs(files) do
        table.insert(selects, file)
    end
    table.insert(selects, "New Song")
    table.insert(selects, "Back")
end

function readAndChange()
    if song ~= nil then
        song:stop()
    end
    if curSelect < #selects - 1 then
        options = json.decode(love.filesystem.read("songs/" .. selects[curSelect] .. "/chart.json"))
        if love.filesystem.getInfo("songs/" .. selects[curSelect] .. "/" .. options.audio) ~= nil then
            if song ~= nil then
                song:stop()
            end
            song = love.audio.newSource("songs/" .. selects[curSelect] .. "/" .. options.audio, "stream")
            song:setLooping(true)
            song:play()
        else
            song:stop()
        end
        presence.details = "in songSelect menu (Listening to " .. selects[curSelect] .. ")"
    else
        presence.details = "in songSelect menu"
    end
end

return state
