local state = {}
local Conductor = require 'states.GAME.conductor'
local music
local interval = 1
local loaded = false
state.spawnOffset = 0
state.strumSpeed = 1
local replayMode = false
local keyPresses = {}
state.placeHolderVar = 1
state.isDownScroll = 1
local isSwitchingScroll = -1
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
local health = 2
local strumTime = 0
local autoPlay = false
local score = 0
local totalNotesHit = 0
local totalNotesMissed = 0
local combo = 0
local circleSegments = 400
local _, _2, notePressType, auto
local sandbox = require 'states.GAME.sandbox'
local script
local error = {
    isShowing = false,
    message = ""
}
local hit = love.audio.newSource("sounds/hit.wav", "static")
local countDown = 2
local isCounting = false
local canPause = false
state.strumLine = strumLine
state.notes = {
    row1 = {},
    row2 = {},
    row3 = {},
    row4 = {}
}

function state.exit()
end

function state.enter(songName, replay)
    local startLoad = love.timer.getTime()
    strumLine = {
        strum1 = {
            y = 85,
            lasty = 0,
            x = love.graphics.getWidth() / 2 - 120,
            lastx = 0,
            size = strumLine.strum1.size,
            overlayAlpha = strumLine.strum1.overlayAlpha,
            bpTimer = 0.1,
            sizeOff = 0
        },
        strum2 = {
            y = 85,
            lasty = 0,
            x = love.graphics.getWidth() / 2 - 40,
            lastx = 0,
            size = strumLine.strum2.size,
            overlayAlpha = strumLine.strum2.overlayAlpha,
            bpTimer = 0.1,
            sizeOff = 0
        },
        strum3 = {
            y = 85,
            lasty = 0,
            x = love.graphics.getWidth() / 2 + 40,
            lastx = 0,
            size = strumLine.strum3.size,
            overlayAlpha = strumLine.strum3.overlayAlpha,
            bpTimer = 0.1,
            sizeOff = 0
        },
        strum4 = {
            y = 85,
            lasty = 0,
            x = love.graphics.getWidth() / 2 + 120,
            lastx = 0,
            size = strumLine.strum4.size,
            overlayAlpha = strumLine.strum4.overlayAlpha,
            bpTimer = 0.1,
            sizeOff = 0
        }
    }
    isCounting = true
    countDown = 2
    canPause = false
    presence.details = "Playing: " .. songName
    presence.state = "In Game"
    health = 2
    state.notes = {
        row1 = {},
        row2 = {},
        row3 = {},
        row4 = {}
    }
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
    if replay ~= nil then
        replayMode = true
        local keyPressesDecoded = json.decode(love.filesystem.read("replay.json"))
        table.insert(keyPresses, (arson.decode(keyPressesDecoded)))
        notePressType = "fade"
    end
    keys = _
    autoPlay = auto
    local options = json.decode(love.filesystem.read("songs/" .. songName .. "/chart.json"))
    music = love.audio.newSource("songs/" .. songName .. "/" .. options.audio, "static")
    Conductor.init(music)
    Conductor.changeBPM(options.bpm)
    nameOfSongLmao = options.song
    Conductor.songPosition = -2
    Conductor.totalLength = music:getDuration()
    state.strumSpeed = options.speed
    for i, v in ipairs(options.notes) do
        state.spawnNote(v.row, v.time, v.length, v.velocity, v.hurt)
    end
    totalNotesMissed = 0
    totalNotesHit = 0
    combo = 0
    score = 0
    love.keyboard.setKeyRepeat(false)
    love.graphics.setLineWidth(2)
    local result = love.timer.getTime() - startLoad
    print(string.format("It took %.3f milliseconds to load " .. options.song .. " with BPM " .. options.bpm,
        result * 1000))
end

function state.draw()
    if loaded then
        gameCam:attach()
        for i = 1, 4 do
            local noteSizeX, noteSizeY = getImageScaleForNewDimensions(images.notes["n" .. i], 75, 75)
            love.graphics.setColor(255, 255, 255)
            love.graphics.circle("line", strumLine["strum" .. i].x, strumLine["strum" .. i].y,
                strumLine["strum" .. i].size + strumLine["strum" .. i].sizeOff, circleSegments)
            love.graphics.setColor(255, 255, 255, strumLine["strum" .. i].overlayAlpha)
            love.graphics.circle("fill", strumLine["strum" .. i].x, strumLine["strum" .. i].y,
                strumLine["strum" .. i].size + strumLine["strum" .. i].sizeOff, circleSegments)
            for j, v in reversedipairs(state.notes["row" .. i]) do
                if v.time > -v.size and v.time < love.graphics.getHeight() + v.size - state.spawnOffset then
                    love.graphics.setColor(255, 255, 255, v.alpha)
                    if not v.wasHit then
                        if v.holdRegister then
                            love.graphics.rectangle("fill", v.x - 30, v.y - 15 + strumLine["strum" .. i].y, 60, 30)
                        else
                            if v.isHurt then
                                love.graphics.draw(images.notes["n" .. i .. "h"],
                                    v.x - images.notes["n" .. i]:getWidth() / 2 * noteSizeX, v.y +
                                        strumLine["strum" .. i].y - images.notes["n" .. i]:getHeight() / 2 * noteSizeY,
                                    0, noteSizeX, noteSizeY)
                            else
                                love.graphics.draw(images.notes["n" .. i],
                                    v.x - images.notes["n" .. i]:getWidth() / 2 * noteSizeX, v.y +
                                        strumLine["strum" .. i].y - images.notes["n" .. i]:getHeight() / 2 * noteSizeY,
                                    0, noteSizeX, noteSizeY)
                            end
                        end
                    end
                end
            end
            love.graphics.setColor(255, 255, 255)
            if state.isDownScroll < 0 then
                love.graphics.print(string.upper(keys[i]), vcr20,
                    strumLine["strum" .. i].x - vcr20:getWidth(string.upper(keys[i])) / 2,
                    strumLine["strum" .. i].y + strumLine["strum" .. i].size + 10)
            else
                love.graphics.print(string.upper(keys[i]), vcr20,
                    strumLine["strum" .. i].x - vcr20:getWidth(string.upper(keys[i])) / 2,
                    strumLine["strum" .. i].y - strumLine["strum" .. i].size - 30)
            end
        end

        love.graphics.linerectangle(strumLine.strum1.x - strumLine.strum1.size - 50, 0,
            strumLine.strum4.x + strumLine.strum4.size + 50, love.graphics.getHeight())

        if autoPlay then
            love.graphics.setColor(255, 255, 255, 255 - math.sin((math.pi * Conductor.songPosition)) * 255)
            love.graphics.print("AUTOPLAY", vcr20, love.graphics.getWidth() / 2 - vcr20:getWidth("AUTOPLAY") / 2,
                love.graphics.getHeight() / 1.5)
        end
        if replayMode then
            love.graphics.setColor(255, 255, 255, 255 - math.sin((math.pi * Conductor.songPosition)) * 255)
            love.graphics.print("REPLAY", vcr20, love.graphics.getWidth() / 2 - vcr20:getWidth("REPLAY") / 2,
                love.graphics.getHeight() / 1.5)
        end

        love.graphics.setColor(255, 255, 255)
        love.graphics.print("\nBPM: " .. math.floor(Conductor.bpm * music:getPitch()) .. "\nSong: " .. nameOfSongLmao,
            vcr20, 0, 0)
        love.graphics.print("Score:" .. score .. " | Misses: " .. totalNotesMissed .. " | Combo: " .. combo,
            love.graphics.getWidth() / 2 -
                love.graphics.getFont():getWidth(
                    "Score:" .. score .. " | Misses: " .. totalNotesMissed .. " | Combo: " .. combo) / 2,
            love.graphics.getHeight() - love.graphics.getFont():getHeight() - 10)

        gameCam:detach()

        if error.isShowing then
            love.graphics.setColor(255, 0, 0)
            love.graphics.printf((error.message):gsub("/", "_"), 10, 10,
                love.graphics.getWidth() - music:getDuration() - 10)
            love.graphics.setColor(255, 255, 255)
        end

        love.graphics
            .rectangle("line", love.graphics.getWidth() - music:getDuration() - 10, 10, music:getDuration(), 30)
        love.graphics.rectangle("fill", love.graphics.getWidth() - music:getDuration() - 10, 10, music:tell(), 30)
        love.graphics.print(formatTime(music:tell()) .. " / " .. formatTime(music:getDuration()),
            love.graphics.getWidth() - music:getDuration(), 50)

        if not music:isPlaying() and canPause then
            love.graphics.setColor(0, 0, 0, 127.5)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            love.graphics.setColor(255, 255, 255)
            love.graphics.print("Paused", vcr20, love.graphics.getWidth() / 2 - vcr20:getWidth("Paused") / 2,
                love.graphics.getHeight() / 2 - vcr20:getHeight("") / 2)
        end
    end
    flash:draw()
end

function state.update(elapsed)
    if loaded then
        state.strumLine = strumLine
        gameCam:zoomTo(cameraa.zoom)
        gameCam:lookAt(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
        flash:update(elapsed)

        for i = 1, 4 do
            for j, v in ipairs(state.notes["row" .. i]) do
                v.time = strumLine["strum" .. i].y - Conductor.songPosition * 1000 + v.startTime
                v.y = v.time - strumLine["strum" .. i].y
                v.y = v.y * state.strumSpeed
                v.y = v.y * v.velocity
                if v.time > -v.size and v.time < love.graphics.getHeight() + v.size - state.spawnOffset then
                    v.x = strumLine["strum" .. i].x + v.xOffset
                    if autoPlay then
                        if v.time < strumLine["strum" .. i].y then
                            if v.canBeHit and not v.holdRegister and not v.isHurt then
                                v.wasHit = true
                                v.canBeHit = false
                                hitSound()
                                score = score + 350
                                health = health + 0.01
                                totalNotesHit = totalNotesHit + 1
                                combo = combo + 1
                                strumLine["strum" .. i].overlayAlpha = 255
                                if notePressType == "nofade" then
                                    strumLine["strum" .. i].bpTimer = 0.1
                                end
                            end
                            if v.canBeHit and v.holdRegister and not v.isHurt then
                                v.wasHit = true
                                v.canBeHit = false
                                strumLine["strum" .. i].overlayAlpha = 255
                                if notePressType == "nofade" then
                                    strumLine["strum" .. i].bpTimer = 0.1
                                end
                            end
                        end
                    end
                    if v.time < strumLine["strum" .. i].y - v.size * 2 and not v.wasHit then
                        if not v.wasMissed and not v.isHurt then
                            score = score - 100
                            health = health - 0.01
                            totalNotesMissed = totalNotesMissed + 1
                            combo = combo + 1
                            v.wasMissed = true
                            combo = 0
                            v.canBeHit = false
                        end
                    end
                    if music:isPlaying() then
                        if v.holdRegister and not autoPlay then
                            if love.keyboard.isDown(keys[i]) then
                                if v.canBeHit then
                                    if v.time < strumLine["strum" .. i].y + 5 then
                                        v.wasHit = true
                                    end
                                end
                            end
                        end
                    end
                end
                if v.time < -500 then
                    table.remove(state.notes["row" .. i], j)
                end
                v.size = strumLine["strum" .. i].size
            end
        end

        if music:isPlaying() then
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

                loaded = false
                collectgarbage()
                state.notes = {
                    row1 = {},
                    row2 = {},
                    row3 = {},
                    row4 = {}
                }
                error = {
                    isShowing = false,
                    message = ""
                }
                keys = nil
                music = nil
                _, _2, notePressType, auto = nil, nil, nil, nil
                love.keyboard.setKeyRepeat(true)
            end
            lastBeat = Conductor.songPositionInBeats
            lastStep = Conductor.songPositionInSteps
            for i = 1, 4 do
                if notePressType == "nofade" then
                    strumLine["strum" .. i].bpTimer = strumLine["strum" .. i].bpTimer - elapsed
                    if strumLine["strum" .. i].bpTimer < 0 then
                        strumLine["strum" .. i].bpTimer = 0.1
                        strumLine["strum" .. i].overlayAlpha = 0
                    end
                end
                callScript("onUpdate")
            end
            if notePressType == "fade" then
                for i = 1, 4 do
                    strumLine["strum" .. i].overlayAlpha = strumLine["strum" .. i].overlayAlpha - 510 * elapsed
                end
            elseif notePressType == "nofade" then
                if not autoPlay or replayMode then
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
        else
            if isCounting then
                countDown = countDown - elapsed
                Conductor.songPosition = Conductor.songPosition + elapsed
                if countDown < 0 then
                    music:play()
                    callScript("onStart")
                    isCounting = false
                    canPause = true
                end
            end
        end
        for i, v in ipairs(keyPresses) do
            if Conductor.songPosition > v.time + 0.5 and Conductor.songPosition < v.time - 0.5 then
                for i = 1, 4 do
                    if v.key == keys[i] then
                        strumLine["strum" .. i].overlayAlpha = 255
                    end
                end
            end
        end
    end
end

function state.keypressed(key)
    if not autoPlay then
        if not replayMode then
            for i = 1, 4 do
                if key == keys[i] then
                    hitSound()
                    strumLine["strum" .. i].overlayAlpha = 255
                    if Conductor.songPosition < 0 then
                        for i, v in ipairs(state.notes["row" .. i]) do
                            if not v.holdRegister then
                                if v.canBeHit and not v.wasMissed and not v.wasHit then
                                    if v.time < strumLine.strum1.y + 100 then
                                        if not v.isHurt then
                                            v.wasHit = true
                                            score = score + 350
                                            totalNotesHit = totalNotesHit + 1
                                            combo = combo + 1
                                        else
                                            v.wasHit = true
                                            totalNotesMissed = totalNotesMissed + 1
                                            score = score - 100
                                            combo = 0
                                            totalNotesHit = totalNotesHit + 1
                                        end
                                    end
                                end
                            end
                        end
                    else
                        if music:isPlaying() then
                            for i, v in ipairs(state.notes["row" .. i]) do
                                if not v.holdRegister then
                                    if v.canBeHit and not v.wasMissed and not v.wasHit then
                                        if v.time < strumLine.strum1.y + 100 then
                                            if not v.isHurt then
                                                v.wasHit = true
                                                score = score + 350
                                                totalNotesHit = totalNotesHit + 1
                                                combo = combo + 1
                                            else
                                                v.wasHit = true
                                                totalNotesMissed = totalNotesMissed + 1
                                                score = score - 100
                                                combo = 0
                                                totalNotesHit = totalNotesHit + 1
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if key == "space" then
        if canPause then
            if music:isPlaying() then
                music:pause()
            else
                music:play()
            end
        end
    end
    if key == "f9" then
        music:stop()
        stateManager:switch("game", nameOfSongLmao)
    end
    if key == "f7" then
        music:stop()
        stateManager:switch("chartingeditor", nameOfSongLmao, Conductor.bpm, music)
    end
    if love.keyboard.isDown("lctrl", "rctrl") then
        if key == "e" then
            if music:tell() + 5 > music:getDuration() then
                music:seek(music:getDuration() - 1)
            else
                music:seek(music:tell() + 5)
            end
        end
        if key == "q" then
            if music:tell() - 5 < 0 then
                music:seek(0)
            else
                music:seek(music:tell() - 5)
            end
            state.notes = {
                row1 = {},
                row2 = {},
                row3 = {},
                row4 = {}
            }
            addNotesAfter(music:tell() * 1000)
        end
    end
    if key == "f4" then
        state.toggleDownScroll()
    end
end

function state.spawnNote(row, time, length, velocity, hurt)
    length = length or 0
    time = time or Conductor.songPosition * 1000 + 1000
    row = row or love.math.random(0, 3)
    velocity = velocity or 1
    hurt = hurt or false
    if length > 0 then
        if row == 0 then
            table.insert(state.notes.row1, {
                alpha = 255,
                x = -100,
                xOffset = 0,
                y = -100,
                time = time,
                startTime = time,
                size = 0,
                velocity = velocity,
                tooLate = false,
                canBeHit = true,
                wasHit = false,
                wasMissed = false,
                holdRegister = false,
                isHurt = hurt
            })
        elseif row == 1 then
            table.insert(state.notes.row2, {
                alpha = 255,
                x = -100,
                xOffset = 0,
                y = -100,
                time = time,
                startTime = time,
                size = 0,
                velocity = velocity,
                tooLate = false,
                canBeHit = true,
                wasHit = false,
                wasMissed = false,
                holdRegister = false,
                isHurt = hurt
            })
        elseif row == 2 then
            table.insert(state.notes.row3, {
                alpha = 255,
                x = -100,
                xOffset = 0,
                y = -100,
                time = time,
                startTime = time,
                size = 0,
                velocity = velocity,
                tooLate = false,
                canBeHit = true,
                wasHit = false,
                wasMissed = false,
                holdRegister = false,
                isHurt = hurt
            })
        elseif row == 3 then
            table.insert(state.notes.row4, {
                alpha = 255,
                x = -100,
                xOffset = 0,
                y = -100,
                time = time,
                startTime = time,
                size = 0,
                velocity = velocity,
                tooLate = false,
                canBeHit = true,
                wasHit = false,
                wasMissed = false,
                holdRegister = false,
                isHurt = hurt
            })
        end
        for i = 1, length / 30 do
            if row == 0 then
                table.insert(state.notes.row1, {
                    alpha = 255,
                    x = -100,
                    xOffset = 0,
                    y = -100,
                    time = time + i * 30,
                    startTime = time + i * 30,
                    size = 0,
                    velocity = velocity,
                    tooLate = false,
                    canBeHit = true,
                    wasHit = false,
                    wasMissed = false,
                    holdRegister = true,
                    isHurt = hurt
                })
            elseif row == 1 then
                table.insert(state.notes.row2, {
                    alpha = 255,
                    x = -100,
                    xOffset = 0,
                    y = -100,
                    time = time + i * 30,
                    startTime = time + i * 30,
                    size = 0,
                    velocity = velocity,
                    tooLate = false,
                    canBeHit = true,
                    wasHit = false,
                    wasMissed = false,
                    holdRegister = true,
                    isHurt = hurt
                })
            elseif row == 2 then
                table.insert(state.notes.row3, {
                    alpha = 255,
                    x = -100,
                    xOffset = 0,
                    y = -100,
                    time = time + i * 30,
                    startTime = time + i * 30,
                    size = 0,
                    velocity = velocity,
                    tooLate = false,
                    canBeHit = true,
                    wasHit = false,
                    wasMissed = false,
                    holdRegister = true,
                    isHurt = hurt
                })
            elseif row == 3 then
                table.insert(state.notes.row4, {
                    alpha = 255,
                    x = -100,
                    xOffset = 0,
                    y = -100,
                    time = time + i * 30,
                    startTime = time + i * 30,
                    size = 0,
                    velocity = velocity,
                    tooLate = false,
                    canBeHit = true,
                    wasHit = false,
                    wasMissed = false,
                    holdRegister = true,
                    isHurt = hurt
                })
            end
        end
    else
        if row == 0 then
            table.insert(state.notes.row1, {
                alpha = 255,
                x = -100,
                xOffset = 0,
                y = -100,
                time = time,
                startTime = time,
                size = 0,
                velocity = velocity,
                tooLate = false,
                canBeHit = true,
                wasHit = false,
                wasMissed = false,
                holdRegister = false,
                isHurt = hurt
            })
        elseif row == 1 then
            table.insert(state.notes.row2, {
                alpha = 255,
                x = -100,
                xOffset = 0,
                y = -100,
                time = time,
                startTime = time,
                size = 0,
                velocity = velocity,
                tooLate = false,
                canBeHit = true,
                wasHit = false,
                wasMissed = false,
                holdRegister = false,
                isHurt = hurt
            })
        elseif row == 2 then
            table.insert(state.notes.row3, {
                alpha = 255,
                x = -100,
                xOffset = 0,
                y = -100,
                time = time,
                startTime = time,
                size = 0,
                velocity = velocity,
                tooLate = false,
                canBeHit = true,
                wasHit = false,
                wasMissed = false,
                holdRegister = false,
                isHurt = hurt
            })
        elseif row == 3 then
            table.insert(state.notes.row4, {
                alpha = 255,
                x = -100,
                xOffset = 0,
                y = -100,
                time = time,
                startTime = time,
                size = 0,
                velocity = velocity,
                tooLate = false,
                canBeHit = true,
                wasHit = false,
                wasMissed = false,
                holdRegister = false,
                isHurt = hurt
            })
        end
    end
end

function step()
    callScript("onStep")
end

function beat()
    callScript("onBeat")
end

function songEnd()
    callScript("onEnd")
    local time = os.time() .. love.math.random(0, 1000)
    love.filesystem.createDirectory("replays")
    love.filesystem.write("replay.json", json.encode(arson.encode(keyPresses)))
    music:stop()
    music = nil
    presence.state = "In Menus"
    stateManager:switch("songSelect")
end

function state.toggleDownScroll(time, ease)
    if isSwitchingScroll == -1 then
        isSwitchingScroll = 1
        ease = ease or "linear"
        time = time or 0
        state.isDownScroll = state.isDownScroll * -1
        if state.isDownScroll < 0 then
            for i = 1, 4 do
                Flux.to(strumLine["strum" .. i], time, {
                    y = love.graphics.getHeight() - 85
                }):ease(ease)
            end
            Flux.to(state, time, {
                strumSpeed = state.strumSpeed * -1
            }):ease(ease)
            Flux.to(state, time, {
                spawnOffset = -love.graphics.getHeight()
            }):ease(ease):oncomplete(function()
                isSwitchingScroll = -1
            end)
        else
            for i = 1, 4 do
                Flux.to(strumLine["strum" .. i], time, {
                    y = 85
                }):ease(ease)
            end
            Flux.to(state, time, {
                strumSpeed = state.strumSpeed * -1
            }):ease(ease)
            Flux.to(state, time, {
                spawnOffset = 0
            }):ease(ease):oncomplete(function()
                isSwitchingScroll = -1
                state.strumSpeed = state.strumSpeed * -1
            end)
        end
    end
end

function state.changeScrollSpeed(speed, time, ease)
    ease = ease or "quartinout"
    time = time or 1
    speed = speed or love.math.random(0.5, 1)
    Flux.to(state, time, {
        strumSpeed = speed
    }):ease(ease):oncomplete(function()
        state.strumSpeed = speed
    end)
end

function state.bumpArrows(time, amount)
    amount = amount or 10
    time = time or 1
    if state.isDownScroll == -1 then
        amount = amount * -1
    end
    for i = 1, 4 do
        local y = strumLine["strum" .. i].y
        strumLine["strum" .. i].y = strumLine["strum" .. i].y - 10
        Flux.to(strumLine["strum" .. i], time, {
            y = y
        }):ease("quartout")
    end
end

function hitSound()
    hit:stop()
    hit:play()
end

function callScript(name)
    if love.filesystem.getInfo("songs/" .. nameOfSongLmao .. "/scripts/" .. name .. ".lua") ~= nil then
        local luaGlobalFunctions = loadstring(love.filesystem.read("states/GAME/luaGlobal.lua"))()
        local code = love.filesystem.read("songs/" .. nameOfSongLmao .. "/scripts/" .. name .. ".lua")
        local ok, result = pcall(sandbox.run, code, {
            env = luaGlobalFunctions
        })
        error.isShowing = not ok
        error.message = result
    end
end

function addNotesAfter(time)
    local options = json.decode(love.filesystem.read("songs/" .. nameOfSongLmao .. "/chart.json"))
    combo = 0
    for i, v in ipairs(options.notes) do
        if v.time > time then 
            state.spawnNote(v.row, v.time, v.length, v.velocity, v.hurt)
        else
            combo = combo + 1
        end
    end
end

return state
