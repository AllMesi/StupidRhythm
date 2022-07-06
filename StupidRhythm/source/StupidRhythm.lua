local oldlgsc = love.graphics.setColor
local oldlggc = love.graphics.getColor
local oldlgc = love.graphics.clear
local oldlgscc = love.graphics.setScissor
local ffi = require("ffi")
local SDL2 = ffi.load("SDL2")
local windowAlpha = 1

ffi.cdef [[
  typedef struct SDL_Window SDL_Window;
  int SDL_SetWindowOpacity(SDL_Window* window, float opacity);
  SDL_Window *SDL_GL_GetCurrentWindow(void);
]]

-- Sets window opacity
function love.window.setAlpha(n)
    if n > 0 and n < 1.1 then
        SDL2.SDL_SetWindowOpacity(SDL2.SDL_GL_GetCurrentWindow(), n)
        windowAlpha = n
    end
end

function love.window.getAlpha()
    return windowAlpha
end

local major, minor, revision, codename = love.getVersion()

local soundsActive = {}

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

function love.graphics.setScissor(x1, y1, x2, y2)
    x1 = x1 or 0
    y1 = y1 or 0
    x2 = x2 or love.graphics.getWidth()
    y2 = y2 or love.graphics.getHeight()
    oldlgscc(x1, y1, x2 - x1, y2 - y1)
end

function love.graphics.clear(r, g, b, a)
    if not a then
        a = 255
    end
    if not r then
        r = 255
    end
    if not g then
        g = 255
    end
    if not b then
        b = 255
    end
    oldlgc(r / 255, g / 255, b / 255, a / 255)
end
stateManager = require "stateManager"
grid = require "gridBackground"
flash = require "flashCircle"
button = require "button"
Flux = require "libs.flux"
timer = require "libs.timer"
camera = require "libs.camera"
lume = require "libs.lume"
json = require "libs.json"
arson = require "libs.arson"
if systemOS() == "Windows" then
    discordRPC = require "libs.discordRPC"
end
lily = require "libs.lily"

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
        local ok = testingMode
        if ok then
            testingMode = false
        end
        wasScreenshot = true
        currentTime = os.time()
        love.filesystem.createDirectory(self.path)
        love.graphics
            .captureScreenshot(self.path .. "/screenshot-" .. currentTime .. love.math.random(0, 100) .. ".png")
        timer.after(0.1, function()
            wasScreenshot = false
            if ok then
                testingMode = true
            end
        end)
    end
}

null = nil

currentUser = "Guest"

loadTime = 0

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
    love.filesystem.write("songs/" .. name .. "/chart.json", json.encode({
        song = name,
        bpm = bpm,
        speed = 1,
        audio = "audio.ogg",
        notes = {{
            velocity = 1,
            row = 0,
            length = 0,
            time = 0,
            hurt = false
        }, {
            velocity = 1,
            row = 1,
            length = 0,
            time = 150,
            hurt = false
        }, {
            velocity = 1,
            row = 2,
            length = 0,
            time = 300,
            hurt = false
        }, {
            velocity = 1,
            row = 3,
            length = 0,
            time = 1250,
            hurt = false
        }}
    }))
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
    return url:match "[^.]+$"
end

function readSave()
    local values = json.decode(love.filesystem.read("settings.json"))
    return values.keys, values.vsync, values.notePressType, values.autoPlay
end

function love.graphics.linerectangle(x1, y2, x3, y4)
    love.graphics.line(x1, y2, x3, y2)
    love.graphics.line(x3, y2, x3, y4)
    love.graphics.line(x3, y4, x1, y4)
    love.graphics.line(x1, y4, x1, y2)
end

function love.graphics.newRectangle(type, x1, y1, x2, y2)
    love.graphics.rectangle(type, x1, y1, x2 - x1, y2 - y1)
end

function formatTime(time)
    local seconds = time % 60
    local minutes = time / 60
    if seconds < 10 then
        return math.floor(minutes) .. ":0" .. math.floor(seconds)
    else
        return math.floor(minutes) .. ":" .. math.floor(seconds)
    end
end

function getTimer()
    return love.timer.getTime() * 1000
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

states = {
    main = require "states.menus.menus",
    songSelect = require "states.menus.songSelect",
    options = require "states.menus.options",
    loading = require "states.loading",
    game = require "states.GAME.game",
    chartingeditor = require "states.GAME.chartingeditor"
}

function OpenSaveDirectory()
    love.system.openURL("file://" .. love.filesystem.getSaveDirectory())
end

function getImageScaleForNewDimensions(image, newWidth, newHeight)
    local currentWidth, currentHeight = image:getDimensions()
    return (newWidth / currentWidth), (newHeight / currentHeight)
end
