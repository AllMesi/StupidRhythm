local oldlgsc = love.graphics.setColor
local oldlggc = love.graphics.getColor
local oldlgc = love.graphics.clear

local major, minor, revision, codename = love.getVersion()

local soundsActive = {}

tab = "    "

-- did because i hate the 0-1 colour range

function love.graphics.setColor(r, g, b, a)
    if not a then
        a = 255
    end
    oldlgsc(r / 255, g / 255, b / 255, a / 255)
end

function love.graphics.getColor()
    local r, g, b, a = oldlggc()
    return r * 255, g * 255, b * 255, a * 255
end

function print(...)
    love.filesystem.createDirectory("/logfiles/" .. gameStarted)
    for i, v in ipairs({...}) do
        io.write("[" .. os.date("%H:%M %p") .. " | StupidRhythm] " .. tostring(v) .. "\n")
        table.insert(logs, "[" .. os.date("%H:%M %p") .. " | StupidRhythm] " .. tostring(v))
        love.filesystem.append("logfiles/" .. gameStarted .. "/log.log",
            "[" .. os.date("%H:%M %p") .. " | StupidRhythm] " .. tostring(v) .. "\n")
    end
end

function love.graphics.clear(r, g, b, a)
    if not a then
        a = 255
    end
    oldlgc(r / 255, g / 255, b / 255, a / 255)
end
Flux = require "libs.flux"
timer = require "libs.timer"
stateManager = require "stateManager"
camera = require "libs.camera"
grid = require "gridBackground"
discordRPC = require "libs.discordRPC"

local currentTime = 0

screenshots = {}

local testingMode = false

wasScreenshot = false

function love.getVersion()
    return major .. "." .. minor
end

screenshot = {
    path = "screenshots",
    start = function(self)
        wasScreenshot = true
        currentTime = os.time()
        love.filesystem.createDirectory(self.path)
        love.graphics
            .captureScreenshot(self.path .. "/screenshot-" .. currentTime .. love.math.random(0, 100) .. ".png")
        timer.after(0.1, function()
            wasScreenshot = false
        end)
    end
}

null = nil

keybindsHaha = {}

currentUser = "Guest"

function saveGame(keybinds, vsync, pressType, autoPlay)
    keybinds = keybinds or {"v", "b", "delete", "end"}
    vsync = vsync or true
    if vsync == true then
        vsync = 1
    else
        vsync = 0
    end
    pressType = pressType or "none"
    autoPlay = autoPlay or false
    love.filesystem.write("config.txt",
        "vs=" .. tostring(vsync) .. ",\nkb={\"" .. keybinds[1] .. "\",\"" .. keybinds[2] .. "\",\"" .. keybinds[3] ..
            "\",\"" .. keybinds[4] .. "\"},\npt=\"" .. pressType .. "\",\nap=" .. tostring(autoPlay))
end

function setSave(keybindVar)
    local code = loadstring("return {" .. love.filesystem.read("config.txt") .. "}")()
    love.window.setVSync(code.vs)
    keybindsHaha = code.kb
end

function readSave()
    local code = loadstring("return {" .. love.filesystem.read("config.txt") .. "}")()
    return code.kb, code.vs, code.pt, code.ap
end

function playSound(path)
    for i, s in ipairs(soundsActive) do
        if not s:isPlaying() then
            love.audio.play(s)
            return
        end
    end
    table.insert(soundsActive, love.audio.newSource(path, 'static'))
    love.audio.play(soundsActive[#soundsActive])
end

bruh = {}

window = {
    translate = {
        x = 0,
        y = 0
    },
    zoom = 1
}
dscale = 2 ^ (1 / 6)
k = 0

function reversedipairs(t)
    local function reversedipairsiter(t, i)
        i = i - 1
        if i ~= 0 then
            return i, t[i]
        end
    end
    return reversedipairsiter, t, #t + 1
end

function makeNewSong(name, bpm)
    love.filesystem.createDirectory("songs/" .. name .. "/scripts")
    love.filesystem.write("songs/" .. name .. "/.sr", "[\n    bpm=" .. bpm ..
        ",\n    audio='',\n    chart=[\n        [0,1000,1000],[1,1000,1000],[2,1000,1000],[3,1000,1000]\n    ]\n]")
    love.filesystem.write("songs/" .. name .. "/scripts/onBeat.lua", "")
    love.filesystem.write("songs/" .. name .. "/scripts/onEnd.lua", "")
    love.filesystem.write("songs/" .. name .. "/scripts/onStart.lua", "")
    love.filesystem.write("songs/" .. name .. "/scripts/onStep.lua", "")
    love.filesystem.write("songs/" .. name .. "/scripts/onUpdate.lua", "")
    love.system.openURL("file://" .. love.filesystem.getSaveDirectory() .. "/songs/" .. name)
end

function getFiles(rootPath, tree)
    tree = tree or {}
    local lfs = love.filesystem
    local filesTable = lfs.getDirectoryItems(rootPath)
    for i, v in ipairs(filesTable) do
        local path = rootPath .. "/" .. v
        if lfs.isFile(path) then
            tree[#tree + 1] = path
        elseif lfs.isDirectory(path) then
            fileTree = getFiles(path, tree)
        end
    end
    return tree
end

function getFileExtension(url)
    return url:match"[^.]+$"
end

function love.graphics.linerectangle(x1, y2, x3, y4)
    love.graphics.line(x1, y2, x3, y2)
    love.graphics.line(x3, y2, x3, y4)
    love.graphics.line(x3, y4, x1, y4)
    love.graphics.line(x1, y4, x1, y2)
end

function love.audio.getCurSourceTime(source)
    local sourcetell = math.floor(source:getTime())
    local minutes = math.floor(sourcetell / 60)
    local seconds = sourcetell - (minutes * 60)
    if seconds < 10 then
        seconds = "0" .. seconds
    end
    return minutes .. ":" .. seconds
end

function love.audio.getTotalSourceTime(source)
    local sourcetell = math.floor(source:getTotalTime())
    local minutes = math.floor(sourcetell / 60)
    local seconds = sourcetell - (minutes * 60)
    if seconds < 10 then
        seconds = "0" .. seconds
    end
    return minutes .. ":" .. seconds
end

function love.audio.getFullSourceTime(source)
    local sourcetell = math.floor(source:getTotalTime())
    local sourcetell2 = math.floor(source:getTime())
    local minutes = math.floor(sourcetell / 60)
    local minutes2 = math.floor(sourcetell2 / 60)
    local seconds = sourcetell - (minutes * 60)
    local seconds2 = sourcetell2 - (minutes2 * 60)
    if seconds < 10 then
        seconds = "0" .. seconds
    end
    return minutes .. ":" .. seconds .. " / " .. minutes2 .. ":" .. seconds2
end

function OpenSaveDirectory()
    love.system.openURL("file://" .. love.filesystem.getSaveDirectory())
end

gameStarted = os.time()

images = {}
sounds = {}
music = {}
songs = {}
fonts = {}

errorMode = false

finishedLoading = false

loadingFunction = function()

end

loadingFunctionAfter = function()

end

function startLoading(loadFunc, loadFuncAfter)
    loadingFunction = loadFunc
    loadingFunctionAfter = loadFuncAfter
    stateManager:switch(states.loading, false)
end

states = {
    main = require "states.menus.menus",
    songSelect = require "states.menus.songSelect",
    options = require "states.menus.options",
    loading = require "states.loading",
    game = require "states.GAME.game",
    chartingeditor = require "states.GAME.chartingeditor"
}

curSong = {
    name = "",
    bpm = 100
}

logs = {}

function OpenSaveDirectory()
    love.system.openURL("file://" .. love.filesystem.getSaveDirectory())
end

function getImageScaleForNewDimensions(image, newWidth, newHeight)
    local currentWidth, currentHeight = image:getDimensions()
    return (newWidth / currentWidth), (newHeight / currentHeight)
end
