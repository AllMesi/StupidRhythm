local oldlgsc = love.graphics.setColor
local oldlggc = love.graphics.getColor
local oldlgc = love.graphics.clear

-- ive made this because i 0-1 colour range

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
LoveLoader = require "libs.loveLoader"
lovebpm = require "libs.lovebpm"
bitser = require "libs.bitser"
xml = require "libs.xml.xml"
grid = require "gridBackground"
discordRPC = require "libs.discordRPC"
moonshine = require "libs.moonshine"

love.filesystem.mount(love.filesystem.getSourceBaseDirectory(), "")

local currentTime = 0

screenshots = {}

blur1, blur2 = love.graphics.newShader [[
    vec4 effect(vec4 color, Image texture, vec2 vTexCoord, vec2 pixel_coords)
    {
        vec4 sum = vec4(0.0);
        number blurSize = .5;

        // take nine samples, with the distance blurSize between them
        sum += texture2D(texture, vec2(vTexCoord.x - 4.0*blurSize, vTexCoord.y)) * 0.05;
        sum += texture2D(texture, vec2(vTexCoord.x - 3.0*blurSize, vTexCoord.y)) * 0.09;
        sum += texture2D(texture, vec2(vTexCoord.x - 2.0*blurSize, vTexCoord.y)) * 0.12;
        sum += texture2D(texture, vec2(vTexCoord.x - blurSize, vTexCoord.y)) * 0.15;
        sum += texture2D(texture, vec2(vTexCoord.x, vTexCoord.y)) * 0.16;
        sum += texture2D(texture, vec2(vTexCoord.x + blurSize, vTexCoord.y)) * 0.15;
        sum += texture2D(texture, vec2(vTexCoord.x + 2.0*blurSize, vTexCoord.y)) * 0.12;
        sum += texture2D(texture, vec2(vTexCoord.x + 3.0*blurSize, vTexCoord.y)) * 0.09;
        sum += texture2D(texture, vec2(vTexCoord.x + 4.0*blurSize, vTexCoord.y)) * 0.05;

        return sum;
    }
]], love.graphics.newShader [[
    vec4 effect(vec4 color, Image texture, vec2 vTexCoord, vec2 pixel_coords)
    {
        vec4 sum = vec4(0.0);
        number blurSize = .1;

        // take nine samples, with the distance blurSize between them
        sum += texture2D(texture, vec2(vTexCoord.x, vTexCoord.y - 4.0*blurSize)) * 0.05;
        sum += texture2D(texture, vec2(vTexCoord.x, vTexCoord.y - 3.0*blurSize)) * 0.09;
        sum += texture2D(texture, vec2(vTexCoord.x, vTexCoord.y - 2.0*blurSize)) * 0.12;
        sum += texture2D(texture, vec2(vTexCoord.x, vTexCoord.y- blurSize)) * 0.15;
        sum += texture2D(texture, vec2(vTexCoord.x, vTexCoord.y)) * 0.16;
        sum += texture2D(texture, vec2(vTexCoord.x, vTexCoord.y + blurSize)) * 0.15;
        sum += texture2D(texture, vec2(vTexCoord.x, vTexCoord.y + 2.0*blurSize)) * 0.12;
        sum += texture2D(texture, vec2(vTexCoord.x, vTexCoord.y + 3.0*blurSize)) * 0.09;
        sum += texture2D(texture, vec2(vTexCoord.x, vTexCoord.y + 4.0*blurSize)) * 0.05;

        return sum;
    }
]]

local testingMode = false

local canScreenshot = true

screenshot = {
    path = "screenshots",
    start = function(self)
        canScreenshot = false
        currentTime = os.time()
        love.filesystem.createDirectory(self.path)
        love.graphics.captureScreenshot(self.path .. "/screenshot-" .. currentTime .. ".png")
    end
}

null = nil

LoveTween = Flux
LoveTimer = timer
LoveStateManager = stateManager
LoveCamera = camera
LoveSave = bitser

xmlhandler = require("libs.xml.xmlhandler.tree")
xmlparser = xml.parser(xmlhandler)

window = {
    translate = {
        x = 0,
        y = 0
    },
    zoom = 1
}
dscale = 2 ^ (1 / 6)
k = 0

local cooldata = love.filesystem.read("Settings.xml")
xmlparser:parse(cooldata)

WindowWidth = xmlhandler.root.StupidRhythm.WindowSettings._attr.width
WindowHeight = xmlhandler.root.StupidRhythm.WindowSettings._attr.height
WindowTitle = xmlhandler.root.StupidRhythm.WindowSettings._attr.title
KeyBinds = xmlhandler.root.StupidRhythm.GameSettings._attr.keys
NoteSize = xmlhandler.root.StupidRhythm.GameSettings._attr.noteSize
NoteSpeed = xmlhandler.root.StupidRhythm.GameSettings._attr.noteSpeed

function chars(str)
    strc = {}
    for i = 1, #str do
        table.insert(strc, string.sub(str, i, i))
    end
    return strc
end

function reversetable(t)
    local n = #t
    local i = 1
    while i < n do
        t[i], t[n] = t[n], t[i]
        i = i + 1
        n = n - 1
    end
end

notekey1 = chars(KeyBinds)[1]
notekey2 = chars(KeyBinds)[3]
notekey3 = chars(KeyBinds)[5]
notekey4 = chars(KeyBinds)[7]

saveFile = "save.dat"

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

function love.graphics.linerectangle(x1, y2, x3, y4)
    love.graphics.line(x1, y2, x3, y2)
    love.graphics.line(x3, y2, x3, y4)
    love.graphics.line(x3, y4, x1, y4)
    love.graphics.line(x1, y4, x1, y2)
    return x1, y2, x3, y4
end

function love.audio.getCurSourceTime(source)
    local sourcetell = math.floor(source:tell())
    local minutes = math.floor(sourcetell / 60)
    local seconds = sourcetell - (minutes * 60)
    if seconds < 10 then
        seconds = "0" .. seconds
    end
    return minutes .. ":" .. seconds
end

function love.audio.getTotalSourceTime(source)
    local sourcetell = math.floor(source:getDuration())
    local minutes = math.floor(sourcetell / 60)
    local seconds = sourcetell - (minutes * 60)
    if seconds < 10 then
        seconds = "0" .. seconds
    end
    return minutes .. ":" .. seconds
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
    savefile = require "states.menus.savefile",
    loading = require "states.loading",
    game = require "states.GAME.game",
    chartingeditor = require "states.GAME.chartingeditor"
}

curSong = {
    name = "",
    bpm = 100
}

logs = {}

function print(...)
    love.filesystem.createDirectory("/logfiles/" .. gameStarted)
    for i, v in ipairs({...}) do
        io.write("[" .. os.date("%H:%M %p") .. " | StupidRhythm] " .. tostring(v) .. "\n")
        table.insert(logs, "[" .. os.date("%H:%M %p") .. " | StupidRhythm] " .. tostring(v))
        love.filesystem.append("logfiles/" .. gameStarted .. "/log.log",
            "[" .. os.date("%H:%M %p") .. " | StupidRhythm] " .. tostring(v) .. "\n")
    end
end

function OpenSaveDirectory()
    love.system.openURL("file://" .. love.filesystem.getSaveDirectory())
end

function getImageScaleForNewDimensions(image, newWidth, newHeight)
    local currentWidth, currentHeight = image:getDimensions()
    return (newWidth / currentWidth), (newHeight / currentHeight)
end
