-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, 'luarocks.loader')
pcall(function() jit.on() end)

-- Localization
-- os.setlocale(os.getenv('LANG'))

_G.HomeDir = os.getenv('HOME')
-- Standard awesome library
_G.Gears = require('gears')
_G.Awful = require('awful')

require('awful.autofocus')

-- Widget and layout library
_G.Wibox = require('wibox')
-- Theme handling library
_G.Beautiful = require('beautiful')
-- Notification library
_G.Naughty = require('naughty')
_G.Menubar = require('menubar')

_G.HotkeysPopup = require('awful.hotkeys_popup')
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require('awful.hotkeys_popup.keys')


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    Naughty.notify({
        preset = Naughty.config.presets.critical,
        title = 'Oops, there were errors during startup!',
        text = awesome.startup_errors
    })
end
-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal('debug::error', function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        Naughty.notify({
            preset = Naughty.config.presets.critical,
            title = 'Oops, an error happened!',
            text = tostring(err)
        })
        in_error = false
    end)
end
-- }}}

---@class Application
---@field name string | table | function
---@field run function

---@param name string | table | function
---@return Application
local function app(name)
    ---@type Application
    return {
        name = name,
        run = function()
            if type(name) == 'function' then
                name()
            else
                Awful.spawn.spawn(name, true)
            end
        end
    }
end

_G.Apps                   = {
    terminal    = app(os.getenv('TERMINAL') or 'alacritty'),
    browser     = app(os.getenv('BROWSER') or 'brave'),
    filemanager = app(os.getenv('FILEMANAGER') or 'thunar'),
    editor      = app(os.getenv('EDITOR') or 'nvim'),

    dmenu       = app({
        'dmenu_run', '-i',
        '-fn', 'Monospace',
        '-nb', Beautiful.bg_normal,
        '-nf', Beautiful.fg_normal,
        '-sb', Beautiful.bg_focus,
        '-sf', Beautiful.fg_focus
    }),
    calculator  = app('galculator'),
    power_menu  = app(HomeDir .. '/.local/bin/powermenu.sh')
}
_G.Apps.editor_cmd        = app(Apps.terminal.name .. ' -e ' .. Apps.editor.name)

local screenshots         = require('utils.screenshots')
_G.Apps.screenshot_full   = app(screenshots('', 'full'))
_G.Apps.screenshot_select = app(screenshots('-s', 'select'))
_G.Apps.screenshot_window = app(function()
    local focused = client.focus
    if focused then
        screenshots('-i ' .. focused.window, 'select')
    else
        Naughty.notify({
            preset = Naughty.config.presets.warn,
            title = 'No focused window',
            text = 'Please focus a window before taking a screenshot of the window.'
        })
    end
end)
_G.Apps.screenlock        = app('lock.sh')

-- Default MODKEY.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
_G.ModKey                 = 'Mod4'
_G.AltKey                 = 'Mod1'

Menubar.utils.terminal    = Apps.terminal.name -- Set the TERMINAL for applications that require it

_G.Xrandr                 = require('utils.xrandr');

-- Themes define colours, icons, font and wallpapers.
require('theme'):init()

require('config'):init()


Gears.timer {
    timeout   = 5,
    call_now  = true,
    autostart = true,
    callback  = function()
        collectgarbage()
    end
}
