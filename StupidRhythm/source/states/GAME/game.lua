local state = {}
local noteRow1 = {}
local noteRow2 = {}
local noteRow3 = {}
local noteRow4 = {}
local notesToBeSpawned = {}
local Conductor = require 'states.GAME.conductor'
local music
local interval = 1
local loaded = false
local spawnOffset = 0
local strumLine = {
    strum1 = {
        y = 85,
        lasty = 0,
        x = 100,
        lastx = 0,
        size = 35,
        overlayAlpha = 0,
        bpTimer = 0.1,
        sizeOff = 0
    },
    strum2 = {
        y = 85,
        lasty = 0,
        x = 200,
        lastx = 0,
        size = 35,
        overlayAlpha = 0,
        bpTimer = 0.1,
        sizeOff = 0
    },
    strum3 = {
        y = 85,
        lasty = 0,
        x = 300,
        lastx = 0,
        size = 35,
        overlayAlpha = 0,
        bpTimer = 0.1,
        sizeOff = 0
    },
    strum4 = {
        y = 85,
        lasty = 0,
        x = 400,
        lastx = 0,
        size = 35,
        overlayAlpha = 0,
        bpTimer = 0.1,
        sizeOff = 0
    }
}
local nameOfSongLmao = ""
local keys = {}
local cameraa = {
    zoom = 1
}
local strumTime = 0
local songSpeed = 1
local autoPlay = false
local score = 0
local totalNotesHit = 0
local totalNotesMissed = 0
local combo = 0
local circleSegments = 400
local _, _2, notePressType, auto
local playFieldCam = camera()
local sandbox = require 'states.GAME.sandbox'
local script
local error = {
    isShowing = false,
    message = ""
}

function state.exit()
    collectgarbage()
    noteRow1 = {}
    noteRow2 = {}
    noteRow3 = {}
    noteRow4 = {}
    error = {
        isShowing = false,
        message = ""
    }
    loaded = false
    keys = nil
    music = nil
    love.keyboard.setKeyRepeat(true)
end

function state.enter(songName)
    presence.details = "Playing: " .. songName
    presence.state = "In Game"
    if love.filesystem.getInfo("songs/" .. nameOfSongLmao .. "/scripts/onStart.lua") ~= nil then
        local luaGlobalFunctions = loadstring(love.filesystem.read("states/GAME/luaGlobal.lua"))()
        luaGlobalFunctions.elapsed = elapsed
        local code = love.filesystem.read("songs/" .. nameOfSongLmao .. "/scripts/onStart.lua")
        local ok, result = pcall(sandbox.run, code, {
            env = luaGlobalFunctions
        })
        error.isShowing = not ok
        error.message = result
    end
    noteRow1 = {}
    noteRow2 = {}
    noteRow3 = {}
    noteRow4 = {}
    loaded = true
    Conductor.bpm = 100
    Conductor.crochet = ((60 / Conductor.bpm) * 1000)
    Conductor.stepCrochet = Conductor.crochet / 4
    Conductor.songPosition = 0
    Conductor.songPositionInBeats = 0
    Conductor.songPositionInSteps = 0
    Conductor.fakeCrochet = (60 / Conductor.bpm) * 1000
    Conductor.totalLength = 0
    _, _2, notePressType, auto = readSave()
    keys = _
    autoPlay = auto
    local options = loadstring("return" ..
                                   love.filesystem.read("songs/" .. songName .. "/.sr"):gsub("%[", "{"):gsub("%]", "}"))()
    music = love.audio.newSource("songs/" .. songName .. "/" .. options.audio, "stream")
    Conductor.changeBPM(options.bpm)
    nameOfSongLmao = songName
    music:play()
    Conductor.totalLength = music:getDuration()
    for i, v in ipairs(options.notes) do
        spawnNote(v[1], v[2], v[3])
    end
    totalNotesMissed = 0
    totalNotesHit = 0
    combo = 0
    score = 0
    print("Playing: " .. songName, "BPM: " .. options.bpm)
    love.keyboard.setKeyRepeat(false)
    love.graphics.setLineWidth(3)
end

function state.draw()
    if loaded then
        gameCam:attach()
        playFieldCam:attach()
        love.graphics.setColor(255, 255, 255)
        love.graphics.circle("line", strumLine.strum1.x, strumLine.strum1.y,
            strumLine.strum1.size + strumLine.strum1.sizeOff, circleSegments)
        love.graphics.setColor(255, 255, 255, strumLine.strum1.overlayAlpha)
        love.graphics.circle("fill", strumLine.strum1.x, strumLine.strum1.y,
            strumLine.strum1.size + strumLine.strum1.sizeOff, circleSegments)
        for i, v in reversedipairs(noteRow1) do
            if v.y > -v.size and v.y < love.graphics.getHeight() + v.size then
                love.graphics.setColor(255, 255, 255, v.alpha)
                if not v.wasHit then
                    if v.holdRegister then
                        love.graphics.rectangle("fill", v.x - 30, v.y, 60, 10)
                    else
                        love.graphics.circle("fill", v.x, v.y, v.size, circleSegments)
                        local r, g, b, a = love.graphics.getColor()
                        love.graphics.setColor(0, 0, 255, a)
                        love.graphics.circle("line", v.x, v.y, v.size, circleSegments)
                        love.graphics.setColor(r, g, b, a)
                    end
                end
            end
        end
        love.graphics.setColor(255, 255, 255)
        love.graphics.print(string.upper(keys[1]), pixel12,
            strumLine.strum1.x - pixel12:getWidth(string.upper(keys[1])) / 2,
            strumLine.strum1.y + strumLine.strum1.size + 10)
        love.graphics.circle("line", strumLine.strum2.x, strumLine.strum2.y,
            strumLine.strum2.size + strumLine.strum2.sizeOff, circleSegments)
        love.graphics.setColor(255, 255, 255, strumLine.strum2.overlayAlpha)
        love.graphics.circle("fill", strumLine.strum2.x, strumLine.strum2.y,
            strumLine.strum2.size + strumLine.strum2.sizeOff, circleSegments)
        for i, v in reversedipairs(noteRow2) do
            if v.y > -v.size and v.y < love.graphics.getHeight() + v.size then
                love.graphics.setColor(255, 255, 255, v.alpha)
                if not v.wasHit then
                    if v.holdRegister then
                        love.graphics.rectangle("fill", v.x - 30, v.y, 60, 10)
                    else
                        love.graphics.circle("fill", v.x, v.y, v.size, circleSegments)
                        local r, g, b, a = love.graphics.getColor()
                        love.graphics.setColor(0, 0, 255, a)
                        love.graphics.circle("line", v.x, v.y, v.size, circleSegments)
                        love.graphics.setColor(r, g, b, a)
                    end
                end
            end
        end
        love.graphics.setColor(255, 255, 255)
        love.graphics.print(string.upper(keys[2]), pixel12,
            strumLine.strum2.x - pixel12:getWidth(string.upper(keys[2])) / 2,
            strumLine.strum2.y + strumLine.strum2.size + 10)
        love.graphics.circle("line", strumLine.strum3.x, strumLine.strum3.y,
            strumLine.strum3.size + strumLine.strum3.sizeOff, circleSegments)
        love.graphics.setColor(255, 255, 255, strumLine.strum3.overlayAlpha)
        love.graphics.circle("fill", strumLine.strum3.x, strumLine.strum3.y,
            strumLine.strum3.size + strumLine.strum3.sizeOff, circleSegments)
        for i, v in reversedipairs(noteRow3) do
            if v.y > -v.size and v.y < love.graphics.getHeight() + v.size then
                love.graphics.setColor(255, 255, 255, v.alpha)
                if v.wasHit then
                    love.graphics.setColor(0, 0, 0, 0)
                end
                if v.wasMissed then
                    love.graphics.setColor(255, 255, 255, 127.5)
                end
                if v.holdRegister then
                    love.graphics.rectangle("fill", v.x - 30, v.y, 60, 10)
                else
                    love.graphics.circle("fill", v.x, v.y, v.size, circleSegments)
                    local r, g, b, a = love.graphics.getColor()
                    love.graphics.setColor(0, 0, 255, a)
                    love.graphics.circle("line", v.x, v.y, v.size, circleSegments)
                    love.graphics.setColor(r, g, b, a)
                end
            end
        end
        love.graphics.setColor(255, 255, 255)
        love.graphics.print(string.upper(keys[3]), pixel12,
            strumLine.strum3.x - pixel12:getWidth(string.upper(keys[3])) / 2,
            strumLine.strum3.y + strumLine.strum3.size + 10)
        love.graphics.circle("line", strumLine.strum4.x, strumLine.strum4.y,
            strumLine.strum4.size + strumLine.strum4.sizeOff, circleSegments)
        love.graphics.setColor(255, 255, 255, strumLine.strum4.overlayAlpha)
        love.graphics.circle("fill", strumLine.strum4.x, strumLine.strum4.y,
            strumLine.strum4.size + strumLine.strum4.sizeOff, circleSegments)
        for i, v in reversedipairs(noteRow4) do
            if v.y > -v.size and v.y < love.graphics.getHeight() + v.size then
                love.graphics.setColor(255, 255, 255, v.alpha)
                if not v.wasHit then
                    if v.holdRegister then
                        love.graphics.rectangle("fill", v.x - 30, v.y, 60, 10)
                    else
                        love.graphics.circle("fill", v.x, v.y, v.size, circleSegments)
                        local r, g, b, a = love.graphics.getColor()
                        love.graphics.setColor(0, 0, 255, a)
                        love.graphics.circle("line", v.x, v.y, v.size, circleSegments)
                        love.graphics.setColor(r, g, b, a)
                    end
                end
            end
        end
        love.graphics.setColor(255, 255, 255)
        love.graphics.print(string.upper(keys[4]), pixel12,
            strumLine.strum4.x - pixel12:getWidth(string.upper(keys[4])) / 2,
            strumLine.strum4.y + strumLine.strum4.size + 10)
        love.graphics.linerectangle(strumLine.strum1.x - strumLine.strum1.size - 50, 0,
            strumLine.strum4.x + strumLine.strum4.size + 50, love.graphics.getHeight())
        playFieldCam:detach()
        if autoPlay then
            -- Thanks for the math psych engine
            love.graphics.setColor(255, 255, 255, 255 - math.sin((math.pi * Conductor.songPosition)) * 255)
            love.graphics.print("[AUTOPLAY]", pixel12,
                love.graphics.getWidth() / 2 - pixel12:getWidth("[AUTOPLAY]") / 2, love.graphics.getHeight() / 1.5)
        end
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("Score: " .. score .. "\nTotal Notes Hit: " .. totalNotesHit .. "\nMisses: " ..
                                totalNotesMissed .. "\nNote Parts: " .. #noteRow1 + #noteRow2 + #noteRow3 + #noteRow4,
            pixel12, 0, love.graphics.getHeight() / 2)
        gameCam:detach()
        if error.isShowing then
            love.graphics.setColor(255, 0, 0)
            love.graphics.printf(error.message, 10, 10, love.graphics.getWidth() - music:getDuration() - 10)
            love.graphics.setColor(255, 255, 255)
        end
        love.graphics
            .rectangle("line", love.graphics.getWidth() - music:getDuration() - 10, 10, music:getDuration(), 30)
        love.graphics.rectangle("fill", love.graphics.getWidth() - music:getDuration() - 10, 10, music:tell(), 30)
        love.graphics.print(math.floor(music:tell()) .. " / " .. math.floor(music:getDuration()),
            love.graphics.getWidth() - math.floor(music:getDuration()), 50)
        if not music:isPlaying() then
            love.graphics.setColor(0, 0, 0, 127.5)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            love.graphics.setColor(255, 255, 255)
            love.graphics.print("Paused", pixel12, love.graphics.getWidth() / 2 - pixel12:getWidth("Paused") / 2,
                love.graphics.getHeight() / 2 - pixel12:getHeight("") / 2)
        end
    end
end

function state.update(elapsed)
    if loaded then
        local lastBeat = Conductor.songPositionInBeats
        local lastStep = Conductor.songPositionInSteps
        Conductor.songPosition = music:tell()
        Conductor.songPositionInBeats = music:tell() / (60 / Conductor.bpm)
        Conductor.songPositionInSteps = music:tell() / (60 / Conductor.bpm) * 4
        if math.floor(Conductor.songPositionInSteps) ~= math.floor(lastStep) and
            math.floor(Conductor.songPositionInSteps) % interval == 0 then
            step()
        end

        if math.floor(Conductor.songPositionInBeats) ~= math.floor(lastBeat) and
            math.floor(Conductor.songPositionInBeats) % interval == 0 then
            beat()
        end

        if music:tell() >= music:getDuration() - 0.1 then
            songEnd()
        end
        lastBeat = Conductor.songPositionInBeats
        lastStep = Conductor.songPositionInSteps
    end

    for i, v in ipairs(noteRow1) do
        v.x = strumLine.strum1.x
        v.y = strumLine.strum1.y - Conductor.songPosition * 1000 + v.time
        if v.y > -strumLine.strum1.y - 1280 and v.y < strumLine.strum1.y + 1280 then
            if autoPlay then
                if v.y < strumLine.strum1.y then
                    if v.canBeHit then
                        v.wasHit = true
                        score = score + 350
                        totalNotesHit = totalNotesHit + 1
                        strumLine.strum1.overlayAlpha = 255
                        v.canBeHit = false
                        if notePressType == "nofade" then
                            strumLine.strum1.bpTimer = 0.1
                        end
                    end
                end
            end
            if v.y < strumLine.strum1.y - v.size * 4 and not v.wasHit then
                if not v.wasMissed then
                    score = score - 100
                    totalNotesMissed = totalNotesMissed + 1
                    v.wasMissed = true
                    combo = 0
                    v.canBeHit = false
                end
            end
            if v.holdRegister then
                if love.keyboard.isDown(keys[1]) then
                    if v.canBeHit then
                        if v.y < strumLine.strum1.y + 5 then
                            v.wasHit = true
                        end
                    end
                end
            end
        end
        if v.y < -1280 then
            table.remove(noteRow1, i)
        end
        v.size = strumLine.strum1.size
    end
    for i, v in ipairs(noteRow2) do
        v.x = strumLine.strum2.x
        v.y = strumLine.strum2.y - Conductor.songPosition * 1000 + v.time
        if v.y > -strumLine.strum2.y - 1280 and v.y < strumLine.strum2.y + 1280 then
            if autoPlay then
                if v.y < strumLine.strum2.y then
                    if v.canBeHit then
                        v.wasHit = true
                        score = score + 350
                        totalNotesHit = totalNotesHit + 1
                        strumLine.strum2.overlayAlpha = 255
                        v.canBeHit = false
                    end
                end
            end
            if v.y < strumLine.strum2.y - v.size * 4 and not v.wasHit then
                if not v.wasMissed then
                    score = score - 100
                    totalNotesMissed = totalNotesMissed + 1
                    v.wasMissed = true
                    combo = 0
                    v.canBeHit = false
                    strumLine.strum2.bpTimer = 0.1
                end
            end
        end
        if v.holdRegister then
            if love.keyboard.isDown(keys[2]) then
                if v.canBeHit then
                    if v.y < strumLine.strum2.y + 5 then
                        v.wasHit = true
                    end
                end
            end
        end
        if v.y < -1280 then
            table.remove(noteRow2, i)
        end
        v.size = strumLine.strum2.size
    end
    for i, v in ipairs(noteRow3) do
        v.x = strumLine.strum3.x
        v.y = strumLine.strum3.y - Conductor.songPosition * 1000 + v.time
        if v.y > -strumLine.strum3.y - 1280 and v.y < strumLine.strum3.y + 1280 then
            if autoPlay then
                if v.y < strumLine.strum3.y then
                    if v.canBeHit then
                        v.wasHit = true
                        score = score + 350
                        totalNotesHit = totalNotesHit + 1
                        strumLine.strum3.overlayAlpha = 255
                        v.canBeHit = false
                        if notePressType == "nofade" then
                            strumLine.strum3.bpTimer = 0.1
                        end
                    end
                end
            end
            if v.y < strumLine.strum3.y - v.size * 4 and not v.wasHit then
                if not v.wasMissed then
                    score = score - 100
                    totalNotesMissed = totalNotesMissed + 1
                    v.wasMissed = true
                    combo = 0
                    v.canBeHit = false
                end
            end
        end
        if v.holdRegister then
            if love.keyboard.isDown(keys[3]) then
                if v.canBeHit then
                    if v.y < strumLine.strum3.y + 5 then
                        v.wasHit = true
                    end
                end
            end
        end
        if v.y < -1280 then
            table.remove(noteRow3, i)
        end
        v.size = strumLine.strum3.size
    end
    for i, v in ipairs(noteRow4) do
        v.x = strumLine.strum4.x
        v.y = strumLine.strum4.y - Conductor.songPosition * 1000 + v.time
        if v.y > -strumLine.strum4.y - 1280 and v.y < strumLine.strum4.y + 1280 then
            if autoPlay then
                if v.y < strumLine.strum4.y then
                    if v.canBeHit then
                        v.wasHit = true
                        score = score + 350
                        totalNotesHit = totalNotesHit + 1
                        strumLine.strum4.overlayAlpha = 255
                        v.canBeHit = false
                        if notePressType == "nofade" then
                            strumLine.strum4.bpTimer = 0.1
                        end
                    end
                end
            end
            if v.y < strumLine.strum4.y - v.size * 4 and not v.wasHit then
                if not v.wasMissed then
                    score = score - 100
                    totalNotesMissed = totalNotesMissed + 1
                    v.wasMissed = true
                    combo = 0
                    v.canBeHit = false
                end
            end
        end
        if v.holdRegister then
            if love.keyboard.isDown(keys[4]) then
                if v.canBeHit then
                    if v.y < strumLine.strum4.y + 5 then
                        v.wasHit = true
                    end
                end
            end
        end
        if v.y < -1280 then
            table.remove(noteRow4, i)
        end
        v.size = strumLine.strum4.size
    end
    gameCam:zoomTo(cameraa.zoom)
    gameCam:lookAt(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    playFieldCam:lookAt(love.graphics.getWidth() / 2 - 500, love.graphics.getHeight() / 2)
    songSpeed = songSpeed + 10 * elapsed
    if loaded then
        if music:isPlaying() then
            for i = 1, 4 do
                if notePressType == "nofade" then
                    strumLine["strum" .. i].bpTimer = strumLine["strum" .. i].bpTimer - elapsed
                    if strumLine["strum" .. i].bpTimer < 0 then
                        strumLine["strum" .. i].bpTimer = 0.1
                        strumLine["strum" .. i].overlayAlpha = 0
                    end
                end
                -- strumLine["strum" .. i].y = math.sin(Conductor.songPosition + i) * 50 + 150
                if love.filesystem.getInfo("songs/" .. nameOfSongLmao .. "/scripts/onUpdate.lua") ~= nil then
                    local luaGlobalFunctions = loadstring(love.filesystem.read("states/GAME/luaGlobal.lua"))()
                    local code = love.filesystem.read("songs/" .. nameOfSongLmao .. "/scripts/onUpdate.lua")
                    local ok, result = pcall(sandbox.run, code, {
                        env = luaGlobalFunctions,
                        {
                            curBeat = math.floor(Conductor.songPositionInBeats),
                            curStep = math.floor(Conductor.songPositionInBeats),
                            songPos = math.floor(Conductor.songPositionInBeats),
                            elapsed = elapsed
                        }
                    })
                    error.isShowing = not ok
                    error.message = result
                end
            end
            if notePressType == "fade" then
                for i = 1, 4 do
                    strumLine["strum" .. i].overlayAlpha = strumLine["strum" .. i].overlayAlpha - 510 * elapsed
                end
            elseif notePressType == "nofade" then
                if not autoPlay then
                    if love.keyboard.isDown(keys[1]) then
                        strumLine.strum1.overlayAlpha = 255
                    else
                        strumLine.strum1.overlayAlpha = 0
                    end
                    if love.keyboard.isDown(keys[2]) then
                        strumLine.strum2.overlayAlpha = 255
                    else
                        strumLine.strum2.overlayAlpha = 0
                    end
                    if love.keyboard.isDown(keys[3]) then
                        strumLine.strum3.overlayAlpha = 255
                    else
                        strumLine.strum3.overlayAlpha = 0
                    end
                    if love.keyboard.isDown(keys[4]) then
                        strumLine.strum4.overlayAlpha = 255
                    else
                        strumLine.strum4.overlayAlpha = 0
                    end
                end
            elseif notePressType == "none" then
                for i = 1, 4 do
                    strumLine["strum" .. i].overlayAlpha = 0
                end
            end
        end
    end
end

function state.keypressed(key)
    if not autoPlay and music:isPlaying() then
        if key == keys[1] then
            strumLine.strum1.overlayAlpha = 255
            for i, v in ipairs(noteRow1) do
                if not v.holdRegister then
                    if v.canBeHit and not v.wasMissed and not v.wasHit then
                        if v.y < strumLine.strum1.y + 100 then
                            v.wasHit = true
                            score = score + 350
                            totalNotesHit = totalNotesHit + 1
                        end
                    end
                end
            end
        end
        if key == keys[2] then
            strumLine.strum2.overlayAlpha = 255
            for i, v in ipairs(noteRow2) do
                if not v.holdRegister then
                    if v.canBeHit and not v.wasMissed and not v.wasHit then
                        if v.y < strumLine.strum2.y + 100 then
                            v.wasHit = true
                            score = score + 350
                            totalNotesHit = totalNotesHit + 1
                        end
                    end
                end
            end
        end
        if key == keys[3] then
            strumLine.strum3.overlayAlpha = 255
            for i, v in ipairs(noteRow3) do
                if not v.holdRegister then
                    if v.canBeHit and not v.wasMissed and not v.wasHit then
                        if v.y < strumLine.strum3.y + 100 then
                            v.wasHit = true
                            score = score + 350
                            totalNotesHit = totalNotesHit + 1
                        end
                    end
                end
            end
        end
        if key == keys[4] then
            strumLine.strum4.overlayAlpha = 255
            for i, v in ipairs(noteRow4) do
                if not v.holdRegister then
                    if v.canBeHit and not v.wasMissed and not v.wasHit then
                        if v.y < strumLine.strum4.y + 100 then
                            v.wasHit = true
                            score = score + 350
                            totalNotesHit = totalNotesHit + 1
                        end
                    end
                end
            end
        end
    end
    if key == "space" then
        if music:isPlaying() then
            music:pause()
        else
            music:play()
        end
    end
    if key == "f9" then
        music:stop()
        stateManager:switch("game")
    end
    if key == "f7" then
        music:stop()
        stateManager:switch("chartingeditor", nameOfSongLmao, Conductor.bpm)
    end
    if key == "e" then
        music:seek(music:tell() + 10)
    end
    if key == "q" then
        if music:tell() - 10 < 0 then
            music:seek(0)
        else
            music:seek(music:tell() - 10)
        end
    end
end

function spawnNote(row, time, length)
    length = length or 0
    if length > 0 then
        if row == 0 then
            table.insert(noteRow1, {
                alpha = 255,
                x = -100,
                y = -100,
                time = time,
                size = 0,
                tooLate = false,
                canBeHit = true,
                wasHit = false,
                wasMissed = false,
                holdRegister = false
            })
        elseif row == 1 then
            table.insert(noteRow2, {
                alpha = 255,
                x = -100,
                y = -100,
                time = time,
                size = 0,
                tooLate = false,
                canBeHit = true,
                wasHit = false,
                wasMissed = false,
                holdRegister = false
            })
        elseif row == 2 then
            table.insert(noteRow3, {
                alpha = 255,
                x = -100,
                y = -100,
                time = time,
                size = 0,
                tooLate = false,
                canBeHit = true,
                wasHit = false,
                wasMissed = false,
                holdRegister = false
            })
        elseif row == 3 then
            table.insert(noteRow4, {
                alpha = 255,
                x = -100,
                y = -100,
                time = time,
                size = 0,
                tooLate = false,
                canBeHit = true,
                wasHit = false,
                wasMissed = false,
                holdRegister = false
            })
        end
        for i = 1, length / 10 do
            if row == 0 then
                table.insert(noteRow1, {
                    alpha = 255,
                    x = -100,
                    y = -100,
                    time = time + i * 10,
                    size = 0,
                    tooLate = false,
                    canBeHit = true,
                    wasHit = false,
                    wasMissed = false,
                    holdRegister = true
                })
            elseif row == 1 then
                table.insert(noteRow2, {
                    alpha = 255,
                    x = -100,
                    y = -100,
                    time = time + i * 10,
                    size = 0,
                    tooLate = false,
                    canBeHit = true,
                    wasHit = false,
                    wasMissed = false,
                    holdRegister = true
                })
            elseif row == 2 then
                table.insert(noteRow3, {
                    alpha = 255,
                    x = -100,
                    y = -100,
                    time = time + i * 10,
                    size = 0,
                    tooLate = false,
                    canBeHit = true,
                    wasHit = false,
                    wasMissed = false,
                    holdRegister = true
                })
            elseif row == 3 then
                table.insert(noteRow4, {
                    alpha = 255,
                    x = -100,
                    y = -100,
                    time = time + i * 10,
                    size = 0,
                    tooLate = false,
                    canBeHit = true,
                    wasHit = false,
                    wasMissed = false,
                    holdRegister = true
                })
            end
        end
    else
        if row == 0 then
            table.insert(noteRow1, {
                alpha = 255,
                x = -100,
                y = -100,
                time = time,
                size = 0,
                tooLate = false,
                canBeHit = true,
                wasHit = false,
                wasMissed = false,
                holdRegister = false
            })
        elseif row == 1 then
            table.insert(noteRow2, {
                alpha = 255,
                x = -100,
                y = -100,
                time = time,
                size = 0,
                tooLate = false,
                canBeHit = true,
                wasHit = false,
                wasMissed = false,
                holdRegister = false
            })
        elseif row == 2 then
            table.insert(noteRow3, {
                alpha = 255,
                x = -100,
                y = -100,
                time = time,
                size = 0,
                tooLate = false,
                canBeHit = true,
                wasHit = false,
                wasMissed = false,
                holdRegister = false
            })
        elseif row == 3 then
            table.insert(noteRow4, {
                alpha = 255,
                x = -100,
                y = -100,
                time = time,
                size = 0,
                tooLate = false,
                canBeHit = true,
                wasHit = false,
                wasMissed = false,
                holdRegister = false
            })
        end
    end
end

function state.resize(w, h)
    strumLine = {
        strum1 = {
            y = 85,
            lasty = 0,
            x = 100,
            lastx = 0,
            size = strumLine.strum1.size,
            overlayAlpha = strumLine.strum1.overlayAlpha,
            bpTimer = 0.1,
            sizeOff = 0
        },
        strum2 = {
            y = 85,
            lasty = 0,
            x = 200,
            lastx = 0,
            size = strumLine.strum2.size,
            overlayAlpha = strumLine.strum2.overlayAlpha,
            bpTimer = 0.1,
            sizeOff = 0
        },
        strum3 = {
            y = 85,
            lasty = 0,
            x = 300,
            lastx = 0,
            size = strumLine.strum3.size,
            overlayAlpha = strumLine.strum3.overlayAlpha,
            bpTimer = 0.1,
            sizeOff = 0
        },
        strum4 = {
            y = 85,
            lasty = 0,
            x = 400,
            lastx = 0,
            size = strumLine.strum4.size,
            overlayAlpha = strumLine.strum4.overlayAlpha,
            bpTimer = 0.1,
            sizeOff = 0
        }
    }
end

function noteHit(time, row)
end

function step()
    if love.filesystem.getInfo("songs/" .. nameOfSongLmao .. "/scripts/onStep.lua") ~= nil then
        local luaGlobalFunctions = loadstring(love.filesystem.read("states/GAME/luaGlobal.lua"))()
        luaGlobalFunctions.curStep = math.floor(Conductor.songPositionInSteps)
        local code = love.filesystem.read("songs/" .. nameOfSongLmao .. "/scripts/onStep.lua")
        local ok, result = pcall(sandbox.run, code, {
            env = luaGlobalFunctions,
            {
                curBeat = math.floor(Conductor.songPositionInBeats),
                curStep = math.floor(Conductor.songPositionInBeats),
                songPos = math.floor(Conductor.songPositionInBeats)
            }
        })
        error.isShowing = not ok
        error.message = result
    end
end

function beat()
    if love.filesystem.getInfo("songs/" .. nameOfSongLmao .. "/scripts/onBeat.lua") ~= nil then
        local luaGlobalFunctions = loadstring(love.filesystem.read("states/GAME/luaGlobal.lua"))()
        local code = love.filesystem.read("songs/" .. nameOfSongLmao .. "/scripts/onBeat.lua")
        local ok, result = pcall(sandbox.run, code, {
            env = luaGlobalFunctions,
            {
                curBeat = math.floor(Conductor.songPositionInBeats),
                curStep = math.floor(Conductor.songPositionInBeats),
                songPos = math.floor(Conductor.songPositionInBeats)
            }
        })
        error.isShowing = not ok
        error.message = result
    end
end

function songEnd()
    if love.filesystem.getInfo("songs/" .. nameOfSongLmao .. "/scripts/onEnd.lua") ~= nil then
        local luaGlobalFunctions = loadstring(love.filesystem.read("states/GAME/luaGlobal.lua"))()
        local code = love.filesystem.read("songs/" .. nameOfSongLmao .. "/scripts/onEnd.lua")
        local ok, result = pcall(sandbox.run, code, {
            env = luaGlobalFunctions,
            {
                curBeat = math.floor(Conductor.songPositionInBeats),
                curStep = math.floor(Conductor.songPositionInBeats),
                songPos = math.floor(Conductor.songPositionInBeats)
            }
        })
        error.isShowing = not ok
        error.message = result
    end
    loaded = false
    presence.state = "In Menus"
    stateManager:switch("songSelect")
end

function setStrumPosition(s1, s2, s3, s4)
    s1 = s1 or {0, 0}
    s2 = s2 or {100, 100}
    s3 = s2 or {200, 200}
    s4 = s2 or {300, 300}
    strumLine.strum1.x = s1[1]
    strumLine.strum1.y = s1[2]
    strumLine.strum2.x = s2[1]
    strumLine.strum2.y = s2[2]
    strumLine.strum3.x = s3[1]
    strumLine.strum3.y = s3[2]
    strumLine.strum4.x = s4[1]
    strumLine.strum4.y = s4[2]
end

return state
