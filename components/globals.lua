-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !! This flag controls the ability to toggle the debug view.         !!
-- !! You will want to turn this to 'true' when you publish your game. !!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
RELEASE = false

-- Enables the debug stats
DEBUG = not RELEASE

CONFIG = {
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

    window = {icon = 'assets/images/logox60.png'},

    debug = {
        -- The key (scancode) that will toggle the debug state.
        -- Scancodes are independent of keyboard layout so it will always be in the same
        -- position on the keyboard. The positions are based on an American layout.
        key = '`',

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
            background = {0, 0, 0},
            foreground = {1, 1, 1},
            shadow = {1, 1, 1, 0},
            shadowOffset = {x = 1, y = 1},
            position = {x = 10, y = 10}
        }
    },

    mobile = false
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

    regular = makeFont 'assets/fonts/Roboto-Regular.ttf',
    bold = makeFont 'assets/fonts/Roboto-Bold.ttf',
    light = makeFont 'assets/fonts/Roboto-Light.ttf',
    thin = makeFont 'assets/fonts/Roboto-Thin.ttf',
    regularItalic = makeFont 'assets/fonts/Roboto-Italic.ttf',
    boldItalic = makeFont 'assets/fonts/Roboto-BoldItalic.ttf',
    lightItalic = makeFont 'assets/fonts/Roboto-LightItalic.ttf',
    thinItalic = makeFont 'assets/fonts/Roboto-Italic.ttf',

    monospace = makeFont 'assets/fonts/RobotoMono-Regular.ttf'
}
Fonts.default = Fonts.regular

CONFIG.debug.stats.font = Fonts.monospace
CONFIG.debug.error.font = Fonts.monospace

Lume = require 'libs.lume'
Husl = require 'libs.husl'
Class = require 'libs.class'
Vector = require 'libs.vector'
State = require 'libs.state'
Signal = require 'libs.signal'
Inspect = require 'libs.inspect'
Camera = require 'libs.camera'
Timer = require 'libs.timer'
Gradient = require 'libs.gradient'
Ser = require 'libs.ser'
Wave = require 'libs.wave'
LoveBPM = require 'libs.lovebpm'
LoveSize = require 'libs.lovesize'
Json = require 'libs.json'

Keyboard = love.keyboard
Graphics = love.graphics

States = {
    game = require 'states.game',
    menu = require 'states.menu',
    keybinds = require 'states.keybinds',
    splash = require 'states.splash'
}

Components = {
    note = require 'components.game.note',
    huds = {
        hudCircles = require 'components.game.huds.hudCircles',
        hudLines = require 'components.game.huds.hudLines',
        hudLinesOutLines = require 'components.game.huds.hudLinesOutLines',
        hudOther = require 'components.game.huds.hudOther',
    },
    inputs = require 'components.game.inputs',
    start = require 'components.menu.startGame'
}

GameVars = {
    inputPlace = {y = 0, x = 0, size = 30},
    inputPlace2 = {y = 0, x = 0, size = 30},
    inputPlace3 = {y = 0, x = 0, size = 30},
    inputPlace4 = {y = 0, x = 0, size = 30},
    inputPlace5 = {y = 0, x = 0, size = 30},
    inputPlace6 = {y = 0, x = 0, size = 30},
    inputPlace7 = {y = 0, x = 0, size = 30},
    inputPlace8 = {y = 0, x = 0, size = 30},
    rating = "",
    chartingMode = false,
    bruh = false,
    speed = 1500,
    notes = {},
    notes2 = {},
    notes3 = {},
    notes4 = {},
    notes5 = {},
    notes6 = {},
    notes7 = {},
    notes8 = {},
    sliders = {},
    sliders2 = {},
    sliders3 = {},
    sliders4 = {},
    song = {
        bpm = 0,
        name = "",
    },
    second = false,
    paused = false
}
