local awful      = require("awful")
awful.util.shell = "bash"
local naughty    = require("naughty")
local screenshot = os.getenv("HOME") .. "/Pictures/Screenshots/$(date +%F_%H_%M_%S).png"
local beautiful  = require("beautiful")

function Spawn_cmd_msg(cmd, args)
    awful.spawn.easy_async_with_shell(cmd, function(_)
        naughty.notify({
            text = args,
            timeout = 1.0
        })
    end)
end

function Spawn_cmd(cmd)
    awful.spawn.easy_async_with_shell(cmd, function(_) end)
end

awful.util.shell = "bash"
local function scrot(cmd, args)
    awful.spawn.easy_async_with_shell(cmd, function(_)
        naughty.notify({
            text = args,
            timeout = 1.0
        })
    end)
end

local M = {}

M.scrot_full = function()
    local ss_path = screenshot
    scrot("scrot -m " .. ss_path .. " -e 'xclip -selection clipboard -target image/png < $f'",
        "Take a screenshot of entire screen")
end

M.scrot_selection = function()
    local ss_path = screenshot
    scrot("scrot -s " .. ss_path .. " -e 'xclip -selection clipboard -target image/png < $f'",
        "Take a screenshot of focused window")
end


M.alsa_volume = function(isup)
    Spawn_cmd_msg("amixer -q set " .. beautiful.volume.channel .. " 5%" .. isup,
        string.format("Volume changed: %s", beautiful.volume.channel))
    beautiful.volume.update()
end

M.alsa_mute = function()
    Spawn_cmd_msg("amixer -q set " .. beautiful.volume.channel .. " toggle",
        string.format("Volume changed: %s", beautiful.volume.channel))
    beautiful.volume.update()
end

M.mpc = function(mode)
    Spawn_cmd_msg("mpc " .. mode, "mpc mode: " .. mode)
    beautiful.mpd.update()
end

M.alsa_toggle_auto_mute = function()
    Spawn_cmd_msg("amixer -c 0 sset 'Auto-Mute Mode' Enabled", "set automute on")
end

M.dmenu_program = function()
    Spawn_cmd(string.format("dmenu_run -i -nb '%s' -nf '%s' -sb '%s' -sf '%s' -l 10 -c -b -p 'Run Program: '",
        beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
end

return M
