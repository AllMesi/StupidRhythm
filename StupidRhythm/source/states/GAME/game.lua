local state = {}

local noteRow1 = {}
local noteRow2 = {}
local noteRow3 = {}
local noteRow4 = {}

local noteTimers = {}

local ratings = {}

local strumSettings = {
    s1 = {
        y = 100,
        realy = love.graphics.getHeight() - 100,
        x = love.graphics.getWidth() / 2 - NoteSize * 2,
        size = NoteSize,
        texture = love.graphics.newImage('assets/images/notes/notekey.png')
    },
    s2 = {
        y = 100,
        realy = love.graphics.getHeight() - 100,
        x = love.graphics.getWidth() / 2 - NoteSize,
        size = NoteSize,
        overlayalpha = 0,
        texture = love.graphics.newImage('assets/images/notes/notekey.png')
    },
    s3 = {
        y = 100,
        realy = love.graphics.getHeight() - 100,
        x = love.graphics.getWidth() / 2,
        size = NoteSize,
        overlayalpha = 0,
        texture = love.graphics.newImage('assets/images/notes/notekey.png')
    },
    s4 = {
        y = 100,
        realy = love.graphics.getHeight() - 100,
        x = love.graphics.getWidth() / 2 + NoteSize,
        size = NoteSize,
        overlayalpha = 0,
        texture = love.graphics.newImage('assets/images/notes/notekey.png')
    }
}

local amountOfNotes = 0
local amountOfNotesLeftToSpawn = 0

local notes
local charts = {}

local speed = 1

local songname = "k;lasd;klsad;lkads;lkads;lk"
local songbpm = 69420
local songoffset = 0

local songs = {}

local firstNote = true

local spawnArea = 0

function state.preenter()
    love.keyboard.setKeyRepeat(false)
end

function state.enter()
    noteCam1.x = 0
    noteCam2.x = 0
    noteCam3.x = 0
    noteCam4.x = 0
    local files = love.filesystem.getDirectoryItems("assets/songs/" .. curSong.name .. "/audios")
    local cooldata = love.filesystem.read("assets/songs/" .. curSong.name .. "/song.xml")
    for k, file in ipairs(files) do
        if file:find("ogg") then
            table.insert(songs, love.audio
                .newSource("assets/songs/" .. curSong.name .. "/audios/" .. file, "static"))
            test, test2 = love.audio.getCurSourceTime(songs[k]), love.audio.getTotalSourceTime(songs[k])
        end
    end
    for i, v in ipairs(songs) do
        v:play()
    end
    -- parseXMLAndSpawnNotes(cooldata)
    -- timer.every(1, function()
    --     for i = 1, 10000 do
    --         table.insert(noteRow1, {
    --             x = 30 * 2,
    --             y = -i / 16,
    --             size = 30,
    --             alpha = 0,
    --             holdregister = true,
    --             texture = images.n1
    --         })
    --     end
    --     reversetable(noteRow1)
    -- end)
    timer.every(5, function()
        for i = 1, 100000 do
            table.insert(noteRow2, {
                x = 60 * 2,
                y = -i / 16,
                size = 30,
                alpha = 0,
                holdregister = true,
                texture = images.n2
            })
        end
        reversetable(noteRow2)
    end)
    files = nil
    cooldata = nil
end

function state.draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("Song: " .. songname .. "\nBPM: " .. songbpm,
        love.graphics.getWidth() - revamped12:getWidth("Song: " .. songname .. "\nBPM: " .. songbpm), 0)

    noteCam1:attach()
    love.graphics.draw(strumSettings.s1.texture, strumSettings.s1.x, love.graphics.getHeight() - strumSettings.s1.y, 0,
        noteSizeK1X, noteSizeK1Y)
    love.graphics.setColor(255, 255, 255, strumSettings.s1.overlayalpha)
    love.graphics.draw(images.nko, strumSettings.s1.x, love.graphics.getHeight() - strumSettings.s1.y, 0, noteSizeKO1X,
        noteSizeKO1Y)
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", strumSettings.s1.x, love.graphics.getHeight() - strumSettings.s1.y, 30, 30)
    for i, v in ipairs(noteRow1) do
        if v.y > spawnArea and v.y < love.graphics.getHeight() then
            love.graphics.draw(v.texture, v.x, v.y, 0, noteSize1X, noteSize1Y)
        end
    end
    noteCam1:detach()

    noteCam2:attach()
    love.graphics.draw(strumSettings.s2.texture, strumSettings.s2.x, love.graphics.getHeight() - strumSettings.s2.y, 0,
        noteSizeK2X, noteSizeK2Y)
    love.graphics.setColor(255, 255, 255, strumSettings.s2.overlayalpha)
    love.graphics.draw(images.nko, strumSettings.s2.x, love.graphics.getHeight() - strumSettings.s2.y, 0, noteSizeKO2X,
        noteSizeKO2Y)
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", strumSettings.s2.x, love.graphics.getHeight() - strumSettings.s2.y, 30, 30)
    for i, v in ipairs(noteRow2) do
        if v.y > spawnArea and v.y < love.graphics.getHeight() then
            love.graphics.draw(v.texture, v.x, v.y, 0, noteSize2X, noteSize2Y)
        end
    end
    noteCam2:detach()

    noteCam3:attach()
    love.graphics.draw(strumSettings.s3.texture, strumSettings.s3.x, love.graphics.getHeight() - strumSettings.s3.y, 0,
        noteSizeK3X, noteSizeK3Y)

    love.graphics.setColor(255, 255, 255, strumSettings.s3.overlayalpha)
    love.graphics.draw(images.nko, strumSettings.s3.x, love.graphics.getHeight() - strumSettings.s3.y, 0, noteSizeKO3X,
        noteSizeKO3Y)
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", strumSettings.s3.x, love.graphics.getHeight() - strumSettings.s3.y, 30, 30)
    for i, v in ipairs(noteRow3) do
        if v.y > spawnArea and v.y < love.graphics.getHeight() then
            love.graphics.draw(v.texture, v.x, v.y, 0, noteSize3X, noteSize3Y)
        end
    end
    noteCam3:detach()

    noteCam4:attach()
    love.graphics.draw(strumSettings.s4.texture, strumSettings.s4.x, love.graphics.getHeight() - strumSettings.s4.y, 0,
        noteSizeK4X, noteSizeK4Y)
    love.graphics.setColor(255, 255, 255, strumSettings.s4.overlayalpha)
    love.graphics.draw(images.nko, strumSettings.s4.x, love.graphics.getHeight() - strumSettings.s4.y, 0, noteSizeKO4X,
        noteSizeKO4Y)
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", strumSettings.s4.x, love.graphics.getHeight() - strumSettings.s4.y, 30, 30)
    for i, v in ipairs(noteRow4) do
        if v.y > spawnArea and v.y < love.graphics.getHeight() then
            love.graphics.draw(v.texture, v.x, v.y, 0, noteSize3X, noteSize4Y)
        end
    end
    noteCam4:detach()

    love.graphics.print("Amount of notes: " .. tostring(amountOfNotes) .. "\nAmount of notes left to spawn: " ..
                            tostring(amountOfNotesLeftToSpawn) .. "\nSong Offset: " .. tostring(songoffset) ..
                            "\nTime: " .. tostring(test) .. " / " .. tostring(test2) .. "\nSpeed: " ..
                            tostring(math.floor(speed * 100)) .. "%", 100, 100)

    -- love.graphics.line(love.graphics.getWidth() / 2, 0, love.graphics.getWidth() / 2, love.graphics.getHeight())

    for i, v in ipairs(ratings) do
        love.graphics.setColor(v.colour.r, v.colour.g, v.colour.b)
        love.graphics.print(v.text, v.x, v.y)
        love.graphics.setColor(255, 255, 255)
    end

    love.graphics.line(0, spawnArea, love.graphics.getWidth(), spawnArea)
end

function state.exit()
    test, test2 = nil, nil
end

function state.update(dt)
    if amountOfNotes >= 60000 then
        spawnArea = amountOfNotes * 0.0005
    end
    if songs[1]:isPlaying() then
        if love.keyboard.isDown(notekey1) then
            strumSettings.s1.overlayalpha = 255
            for i, v in ipairs(noteRow1) do
                if v.y > love.graphics.getHeight() - strumSettings.s1.y and v.holdregister then
                    table.remove(noteRow1, i)
                end
            end
        end
        if love.keyboard.isDown(notekey2) then
            strumSettings.s2.overlayalpha = 255
            for i, v in ipairs(noteRow2) do
                if v.y > love.graphics.getHeight() - strumSettings.s2.y and v.holdregister then
                    table.remove(noteRow2, i)
                end
            end
        end
        if love.keyboard.isDown(notekey3) then
            strumSettings.s3.overlayalpha = 255
            for i, v in ipairs(noteRow3) do
                if v.y > love.graphics.getHeight() - strumSettings.s3.y and v.holdregister then
                    table.remove(noteRow3, i)
                end
            end
        end
        if love.keyboard.isDown(notekey4) then
            strumSettings.s4.overlayalpha = 255
            for i, v in ipairs(noteRow4) do
                if v.y > love.graphics.getHeight() - strumSettings.s4.y and v.holdregister then
                    table.remove(noteRow4, i)
                end
            end
        end
        if strumSettings.s1.overlayalpha > 0 then
            strumSettings.s1.overlayalpha = strumSettings.s1.overlayalpha - dt * 1000
        end
        if strumSettings.s2.overlayalpha > 0 then
            strumSettings.s2.overlayalpha = strumSettings.s2.overlayalpha - dt * 1000
        end
        if strumSettings.s3.overlayalpha > 0 then
            strumSettings.s3.overlayalpha = strumSettings.s3.overlayalpha - dt * 1000
        end
        if strumSettings.s4.overlayalpha > 0 then
            strumSettings.s4.overlayalpha = strumSettings.s4.overlayalpha - dt * 1000
        end
        for i, v in ipairs(songs) do
            test, test2 = love.audio.getCurSourceTime(songs[i]), love.audio.getTotalSourceTime(songs[i])
            v:setPitch(speed)
        end
        for i, v in ipairs(ratings) do
            v.y = v.y + dt * v.speed
            v.speed = v.speed + dt * v.acceleration * speed
            if v.y > love.graphics.getHeight() then
                table.remove(ratings, i)
            end
        end
        if love.keyboard.isDown("q") then
            speed = speed - 0.01
            if speed < 0.1 then
                speed = 0.1
            end
        elseif love.keyboard.isDown("e") then
            speed = speed + 0.01
        end
        amountOfNotes = #noteRow1 + #noteRow2 + #noteRow3 + #noteRow4
        noteSize1X, noteSize1Y = getImageScaleForNewDimensions(images.n1, NoteSize, NoteSize)
        noteSize2X, noteSize2Y = getImageScaleForNewDimensions(images.n2, NoteSize, NoteSize)
        noteSize3X, noteSize3Y = getImageScaleForNewDimensions(images.n3, NoteSize, NoteSize)
        noteSize4X, noteSize4Y = getImageScaleForNewDimensions(images.n4, NoteSize, NoteSize)
        noteSizeK1X, noteSizeK1Y = getImageScaleForNewDimensions(images.nk, NoteSize, NoteSize)
        noteSizeK2X, noteSizeK2Y = getImageScaleForNewDimensions(images.nk, NoteSize, NoteSize)
        noteSizeK3X, noteSizeK3Y = getImageScaleForNewDimensions(images.nk, NoteSize, NoteSize)
        noteSizeK4X, noteSizeK4Y = getImageScaleForNewDimensions(images.nk, NoteSize, NoteSize)
        noteSizeKO1X, noteSizeKO1Y = getImageScaleForNewDimensions(images.nko, NoteSize, NoteSize)
        noteSizeKO2X, noteSizeKO2Y = getImageScaleForNewDimensions(images.nko, NoteSize, NoteSize)
        noteSizeKO3X, noteSizeKO3Y = getImageScaleForNewDimensions(images.nko, NoteSize, NoteSize)
        noteSizeKO4X, noteSizeKO4Y = getImageScaleForNewDimensions(images.nko, NoteSize, NoteSize)
        for i, v in ipairs(noteRow1) do
            v.y = v.y + dt * NoteSpeed * speed
            v.x = strumSettings.s1.x
            if v.y > love.graphics.getHeight() + 200 then
                table.remove(noteRow1, i)
                if not v.holdregister then
                    addRating("MISS!", love.graphics.getWidth() / 2 - noteCam1.x, {
                        r = 255,
                        g = 0,
                        b = 0
                    })
                end
            end
        end
        for i, v in ipairs(noteRow2) do
            v.y = v.y + dt * NoteSpeed * speed
            v.x = strumSettings.s2.x
            if v.y > love.graphics.getHeight() + 200 then
                table.remove(noteRow2, i)
                if not v.holdregister then
                    addRating("MISS!", love.graphics.getWidth() / 2 - noteCam2.x, {
                        r = 255,
                        g = 0,
                        b = 0
                    })
                end
            end
        end
        for i, v in ipairs(noteRow3) do
            v.y = v.y + dt * NoteSpeed * speed
            v.x = strumSettings.s3.x
            if v.y > love.graphics.getHeight() + 200 then
                table.remove(noteRow3, i)
                if not v.holdregister then
                    addRating("MISS!", love.graphics.getWidth() / 2 - noteCam3.x, {
                        r = 255,
                        g = 0,
                        b = 0
                    })
                end
            end
        end
        for i, v in ipairs(noteRow4) do
            v.y = v.y + dt * NoteSpeed * speed
            v.x = strumSettings.s4.x
            if v.y > love.graphics.getHeight() + 200 then
                table.remove(noteRow4, i)
                if not v.holdregister then
                    addRating("MISS!", love.graphics.getWidth() / 2 - noteCam4.x, {
                        r = 255,
                        g = 0,
                        b = 0
                    })
                end
            end
        end
        timer.update(dt)
    end
end

function state.exit()
    notes = nil
    firstNote = true
    love.keyboard.setKeyRepeat(true)
end

function parseXMLAndSpawnNotes(xmldata)
    xmlparser:parse(xmldata)
    notes = xmlhandler.root.Song.Chart
    songoffset = xmlhandler.root.Song.Settings._attr.noteoffset
    songname = xmlhandler.root.Song.Settings._attr.name
    songbpm = xmlhandler.root.Song.Settings._attr.bpm
    if #notes.Note > 1 then
        notes = notes.Note
    end

    amountOfNotesLeftToSpawn = #notes

    for i, p in pairs(notes) do
        if p._attr.Row == "1" then
            if firstNote then
                firstNote = false
            end
            amountOfNotesLeftToSpawn = amountOfNotesLeftToSpawn - 1
            if tonumber(p._attr.length) > 0 then
                table.insert(noteRow1, {
                    x = 30 * 2,
                    y = -p._attr.Time,
                    size = 30,
                    alpha = 0,
                    holdregister = false,
                    texture = images.n1
                })
                for i = 1, p._attr.length do
                    table.insert(noteRow1, {
                        x = 30 * 2,
                        y = -i,
                        size = 30,
                        alpha = 0,
                        holdregister = true,
                        texture = images.nl
                    })
                end
            else
                table.insert(noteRow1, {
                    x = 30 * 2,
                    y = -p._attr.Time,
                    size = 30,
                    alpha = 0,
                    holdregister = false,
                    texture = images.n1
                })
            end
        end
        if p._attr.Row == "2" then
            if firstNote then
                firstNote = false
            end
            amountOfNotesLeftToSpawn = amountOfNotesLeftToSpawn - 1
            table.insert(noteRow2, {
                x = 60 * 2,
                y = -p._attr.Time,
                size = 30,
                alpha = 0,
                holdregister = false,
                texture = images.n2
            })
        end
        if p._attr.Row == "3" then
            if firstNote then
                firstNote = false
            end
            amountOfNotesLeftToSpawn = amountOfNotesLeftToSpawn - 1
            table.insert(noteRow3, {
                x = 90 * 2,
                y = -p._attr.Time,
                size = 30,
                alpha = 0,
                holdregister = false,
                texture = images.n3
            })
        end
        if p._attr.Row == "4" then
            if firstNote then
                firstNote = false
            end
            amountOfNotesLeftToSpawn = amountOfNotesLeftToSpawn - 1
            table.insert(noteRow4, {
                x = 120 * 2,
                y = -p._attr.Time,
                size = 30,
                alpha = 0,
                holdregister = false,
                texture = images.n4
            })
        end
    end
end

function state.keypressed(key)
    if key == "b" then
        for i, v in ipairs(songs) do
            v:stop()
        end
        songs = {}
        noteRow1 = {}
        noteRow2 = {}
        noteRow3 = {}
        noteRow4 = {}
        firstNote = true
        amountOfNotesLeftToSpawn = 0
        amountOfNotes = 0
        songoffset = 0
        stateManager:setBackgroundColour({100, 100, 100}, 5)
        stateManager:switch("chartingeditor", true)
    end
    if songs ~= {} then
        if songs[1]:isPlaying() then
            if key == notekey1 then
                strumSettings.s1.overlayalpha = 255
                for i, v in ipairs(noteRow1) do
                    if v.y > love.graphics.getHeight() - strumSettings.s1.y - 70 then
                        table.remove(noteRow1, i)
                        addRating("COOL!", love.graphics.getWidth() / 2 - noteCam1.x, {
                            r = 0,
                            g = 255,
                            b = 0
                        })
                    end
                end
            end
            if key == notekey2 then
                strumSettings.s2.overlayalpha = 255
                for i, v in ipairs(noteRow2) do
                    if v.y > love.graphics.getHeight() - strumSettings.s2.y - 70 then
                        table.remove(noteRow2, i)
                        addRating("COOL!", love.graphics.getWidth() / 2 - noteCam2.x, {
                            r = 0,
                            g = 255,
                            b = 0
                        })
                    end
                end
            end
            if key == notekey3 then
                strumSettings.s3.overlayalpha = 255
                for i, v in ipairs(noteRow3) do
                    if v.y > love.graphics.getHeight() - strumSettings.s3.y - 70 then
                        table.remove(noteRow3, i)
                        addRating("COOL!", love.graphics.getWidth() / 2 - noteCam3.x, {
                            r = 0,
                            g = 255,
                            b = 0
                        })
                    end
                end
            end
            if key == notekey4 then
                strumSettings.s4.overlayalpha = 255
                for i, v in ipairs(noteRow4) do
                    if v.y > love.graphics.getHeight() - strumSettings.s4.y - 70 then
                        table.remove(noteRow4, i)
                        addRating("COOL!", love.graphics.getWidth() / 2 - noteCam4.x, {
                            r = 0,
                            g = 255,
                            b = 0
                        })
                    end
                end
            end
            if key == "w" then
                speed = 1
            end
        end
    end
    if key == "space" then
        for i, v in ipairs(songs) do
            if v:isPlaying() then
                v:pause()
            else
                v:play()
            end
        end
    end
end

function addRating(text, x, colour)
    table.insert(ratings, {
        text = text,
        colour = colour,
        y = 0,
        speed = 0,
        acceleration = 1000,
        x = x
    })
end

function changeKeys(image1, image2, image3, image4)
    local change1 = love.graphics.newImage(image1)
    local change2 = love.graphics.newImage(image2)
    local change3 = love.graphics.newImage(image3)
    local change4 = love.graphics.newImage(image4)
    noteSizeK1X, noteSizeK1Y = getImageScaleForNewDimensions(change1, NoteSize, NoteSize)
    noteSizeK2X, noteSizeK2Y = getImageScaleForNewDimensions(change2, NoteSize, NoteSize)
    noteSizeK3X, noteSizeK3Y = getImageScaleForNewDimensions(change3, NoteSize, NoteSize)
    noteSizeK4X, noteSizeK4Y = getImageScaleForNewDimensions(change4, NoteSize, NoteSize)
    strumSettings.s1.texture = change1
    strumSettings.s2.texture = change2
    strumSettings.s3.texture = change3
    strumSettings.s4.texture = change4
end

return state
