local sources = {}

function screenshot()
    screenshotThread:start()
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
        return ("%3d"):format(1 / love.timer.getDelta())
    end
end

function switchScene(new)
    if new then
        if sceneThing.switching then
            Timer.after(0.5, function()
                sceneThing.switching = true
                Flux.to(sceneThing, 0.5, {
                    y = 0
                }):ease("quartout"):oncomplete(function()
                    Timer.after(0.1, function()
                        Scene.switch(new)
                        Flux.to(sceneThing, 0.5, {
                            y = love.graphics.getHeight()
                        }):ease("quartin"):oncomplete(function()
                            sceneThing.switching = false
                            sceneThing.y = -love.graphics.getHeight()
                        end)
                    end)
                end)
            end)
        else
            sceneThing.switching = true
            Flux.to(sceneThing, 0.5, {
                y = 0
            }):ease("quartout"):oncomplete(function()
                Timer.after(0.1, function()
                    Scene.switch(new)
                    Flux.to(sceneThing, 0.5, {
                        y = love.graphics.getHeight()
                    }):ease("quartin"):oncomplete(function()
                        sceneThing.switching = false
                        sceneThing.y = -love.graphics.getHeight()
                    end)
                end)
            end)
        end
    end
end

function startGame(name)
    Components.stars:uninit()
    song = name
    -- MenuSong:stop()
    Components.button:clear()
    Timer.clear()
    health = healthMax
    misses = 0
    scores.score = 0
    scores.comboScore = 0
    effect = Moonshine(Moonshine.effects.pixelate)
    switchScene(Scenes.game)
end

function showCursor()

end

function hideCursor()

end

function coolNoteHit(gain)
    health = health + gain
    table.insert(ratingThing, {
        y = love.graphics.getHeight(),
        x = circleStrum4.x + 100,
        type = "cool",
        colour = {35 / 255, 196 / 255, 29 / 255},
        speed = 1000
    })
    -- scores.score = scores.score + love.math.random(90, 120)
    Flux.to(scores, 1, {score = scores.score + 100})
end

function miss(lose)
    health = health - lose
    misses = misses + 1
    table.insert(ratingThing, {
        y = love.graphics.getHeight(),
        x = circleStrum4.x + 100,
        type = "miss",
        colour = {224 / 255, 0, 26 / 255},
        speed = 1000
    })
    scores.score = scores.score - love.math.random(90, 120)
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
    if num >= 0 then
        num = math.floor(num + 0.5)
    else
        num = math.ceil(num - 0.5)
    end
    return num / decimals
end

function listFiles(dir)
    local files = love.filesystem.getDirectoryItems(dir)
    for k, file in ipairs(files) do
        return file
    end
end
