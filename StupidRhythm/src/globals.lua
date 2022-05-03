GameConfig = require "config"

require("game.functions")

RELEASE = false

StupidRhythm = {}

StupidRhythm.build = "0"

StupidRhythm.name = "StupidRhythm"

currentOS = love.system.getOS()

StupidRhythm.fullname = StupidRhythm.name .. " build " .. StupidRhythm.build

StupidRhythm.addToTitle = " | " .. StupidRhythm.fullname .. " | Running on " .. currentOS .. "..."

onMobile = false

DEBUG = not RELEASE

appId = "956876051252920320"

CONFIG = {
    FPS = 240,
    graphics = {
        filter = {
            down = "nearest",
            up = "nearest",
            anisotropy = 1
        }
    },
}

local function makeFont(path)
    return setmetatable({}, {
        __index = function(t, size)
            local f = love.graphics.newFont(path, size)
            rawset(t, size, f)
            return f
        end
    })
end

Fonts = {
    default = nil,
    regular = makeFont "fonts/Roboto-Regular.ttf",
    bold = makeFont "fonts/Roboto-Bold.ttf",
    light = makeFont "fonts/Roboto-Light.ttf",
    thin = makeFont "fonts/Roboto-Thin.ttf",
    regularItalic = makeFont "fonts/Roboto-Italic.ttf",
    boldItalic = makeFont "fonts/Roboto-BoldItalic.ttf",
    lightItalic = makeFont "fonts/Roboto-LightItalic.ttf",
    thinItalic = makeFont "fonts/Roboto-Italic.ttf",
    monospace = makeFont "fonts/RobotoMono-Regular.ttf"
}
Fonts.default = Fonts.regular

Lume = require "libs.lume"
Husl = require "libs.husl"
Scene = require "libs.scene"
Camera = require "libs.camera"
Timer = require "libs.timer"
Flux = require "libs.flux"
LoveBPM = require "libs.lovebpm"
discordRPC = require "libs.discordRPC"
LoveLoader = require "libs.loveLoader"
Moonshine = require "libs.moonshine"
suit = require "libs.suit"
Bitser = require "libs.bitser"

gr = love.graphics
fi = love.filesystem
au = love.audio
wi = love.window
ev = love.event
mo = love.mouse
im = love.image
ke = love.keyboard
vi = love.video

revamped12 = love.graphics.newFont("fonts/Revamped.otf", 12)
revamped32 = love.graphics.newFont("fonts/Revamped.otf", 32)
revamped50 = love.graphics.newFont("fonts/Revamped.otf", 50)

gr.setColour = gr.setColor

logs = {}

loadingText = "Loading..."

CursorAlpha1 = 1
CursorAlpha2 = 0.3

function getImageScaleForNewDimensions(image, newWidth, newHeight)
    local currentWidth, currentHeight = image:getDimensions()
    return (newWidth / currentWidth), (newHeight / currentHeight)
end

logo = {}
logo.size = 700
logo.xOffset = 0

showingCursor = true

bpm = 0
song = ""

TimeGameOpened = os.time()

Scenes = {
    game = require "game.scenes.game",
    menus = {
        menu = require "game.scenes.menus.menu",
        options = require "game.scenes.menus.options",
        songSelect = require "game.scenes.menus.songSelect"
    },
    beforeMenu = require "game.scenes.beforeMenu",
    charter = require "game.scenes.charter",
    gameOver = require "game.scenes.gameOver",
    l = require "game.scenes.l"
}

Components = {
    hud = require "game.components.hud",
    note = require "game.components.note",
    button = require "game.components.button",
    stars = require "game.components.stars",
    loading = require "game.components.loading",
    playPlace = require "game.components.playPlace",
    logger = require "game.components.logger"
}

noteRow1 = {}
noteRow2 = {}
noteRow3 = {}
noteRow4 = {}

showStats = false

misses = 0
scores = {
    score = 0,
    comboScore = 0
}
healthMax = 1000
health = healthMax

noteSliderRow1 = {}
noteSliderRow2 = {}
noteSliderRow3 = {}
noteSliderRow4 = {}

circleStrum1 = {
    curRadius = 30,
    radiusIdle = 30,
    radiusPressed = 20,
    radiusReleased = 30,
    x = 0,
    y = 0
}
circleStrum2 = {
    curRadius = 30,
    radiusIdle = 30,
    radiusPressed = 20,
    radiusReleased = 30,
    x = 0,
    y = 0
}
circleStrum3 = {
    curRadius = 30,
    radiusIdle = 30,
    radiusPressed = 20,
    radiusReleased = 30,
    x = 0,
    y = 0
}
circleStrum4 = {
    curRadius = 30,
    radiusIdle = 30,
    radiusPressed = 20,
    radiusReleased = 30,
    x = 0,
    y = 0
}
circleNoteSpawn1 = {
    radius = 30,
    x = 0,
    y = 0
}
circleNoteSpawn2 = {
    radius = 30,
    x = 0,
    y = 0
}
circleNoteSpawn3 = {
    radius = 30,
    x = 0,
    y = 0
}
circleNoteSpawn4 = {
    radius = 30,
    x = 0,
    y = 0
}

noteBarRow = {}

ratingThing = {}

sceneThing = {}
sceneThing.y = -love.graphics.getHeight()
sceneThing.switching = false

chartingMode = false
dumb = false
