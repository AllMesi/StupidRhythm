GameConfig = require "config"

require("game.functions")

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !! This flag controls the ability to toggle the debug view.         !!
-- !! You will want to turn this to 'true' when you publish your game. !!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
RELEASE = false

StupidRhythm = {}

StupidRhythm.ver = "0.1.4"

StupidRhythm.name = "StupidRhythm"

currentOS = love.system.getOS()

StupidRhythm.fullname = StupidRhythm.name .. " " .. StupidRhythm.ver

StupidRhythm.addToTitle = " | " .. StupidRhythm.fullname .. " | Running on " .. currentOS .. "..."

onMobile = false

DEBUG = not RELEASE

appId = "956876051252920320"

CONFIG = {
    FPS = 240,
    graphics = {
        filter = {
            -- FilterModes: linear (blurry) / nearest (blocky)
            -- Default filter used when scaling down
            down = "nearest",
            -- Default filter used when scaling up
            up = "nearest",
            -- Amount of anisotropic filter performed
            anisotropy = 1
        }
    },
    debug = {
        -- The key (scancode) that will toggle the debug state.
        -- Scancodes are independent of keyboard layout so it will always be in the same
        -- position on the keyboard. The positions are based on an American layout.
        key = "`",
        stats = {
            font = nil, -- set after fonts are created
            fontSize = 16,
            lineHeight = 18,
            foreground = {1, 1, 1, 1},
            shadow = {0, 0, 0, 1},
            shadowOffset = {x = 1, y = 1},
            position = {x = 8, y = 6},
            kilobytes = false
        },
        -- Error screen config
        error = {
            font = nil, -- set after fonts are created
            fontSize = 16,
            background = {.1, .31, .5},
            foreground = {1, 1, 1},
            shadow = {0, 0, 0, .88},
            shadowOffset = {x = 1, y = 1},
            position = {x = 70, y = 70}
        }
    }
}

local function makeFont(path)
    return setmetatable(
        {},
        {
            __index = function(t, size)
                local f = love.graphics.newFont(path, size)
                rawset(t, size, f)
                return f
            end
        }
)
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

CONFIG.debug.stats.font = Fonts.monospace
CONFIG.debug.error.font = Fonts.monospace

Lume = require "libs.lume"
Husl = require "libs.husl"
Scene = require "libs.scene"
Camera = require "libs.camera"
Timer = require "libs.timer"
Flux = require "libs.flux"
LoveBPM = require "libs.lovebpm"
discordRPC = require "libs.discordRPC"
LoveLoader = require "libs.loveLoader"

gr = love.graphics
fi = love.filesystem
au = love.audio
wi = love.window
ev = love.event
mo = love.mouse
im = love.image
ke = love.keyboard
vi = love.video

gr.setColour = gr.setColor

buttons = {}

logs = {}

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
    menu = require "game.scenes.menu",
    options = require "game.scenes.options",
    beforeMenu = require "game.scenes.beforeMenu",
    songSelect = require "game.scenes.songSelect",
    charter = require "game.scenes.charter",
}

Components = {
    hud = require "game.components.hud",
    note = require "game.components.note",
    button = require "game.components.button",
    stars = require "game.components.stars",
    loading = require "game.components.loading"
}

noteRow1 = {}
noteRow2 = {}
noteRow3 = {}
noteRow4 = {}

noteSliderRow1 = {}
noteSliderRow2 = {}
noteSliderRow3 = {}
noteSliderRow4 = {}

noteBarRow = {}

chartingMode = false
dumb = false
