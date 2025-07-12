--[[
     (modified & simplyfy) Powerarrow Dark Awesome WM theme
     github.com/lcpz
--]]

local dpi                      = Beautiful.xresources.apply_dpi
local theme                    = {}
theme.dir                      = Gears.filesystem.get_configuration_dir() .. 'theme'
theme.wallpaper                = HomeDir .. '/Pictures/wallanime.jpg'
theme.font                     = 'FiraMono Nerd Font Mono Medium 8'
theme.fg_normal                = '#DDDDFF'
theme.fg_focus                 = '#EA6F81'
theme.fg_urgent                = '#CC9393'
theme.bg_normal                = '#1A1A1A'
theme.bg_focus                 = '#212121'
theme.bg_urgent                = '#1A1A1A'
theme.border_width             = dpi(1)
theme.border_normal            = '#3F3F3F'
theme.border_focus             = '#7F7F7F'
theme.border_marked            = '#CC9393'
theme.tasklist_bg_focus        = '#1A1A1A'

theme.titlebar_bg_focus        = theme.bg_focus
theme.titlebar_bg_normal       = theme.bg_normal
theme.titlebar_fg_focus        = theme.fg_focus
theme.menu_height              = dpi(20)
theme.menu_width               = dpi(120)

theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon    = true
theme.useless_gap              = dpi(0)

theme.menu_submenu_icon        = theme.dir .. '/icons/submenu.png'
theme.taglist_squares_sel      = theme.dir .. '/icons/square_sel.png'
theme.taglist_squares_unsel    = theme.dir .. '/icons/square_unsel.png'
theme.layout_tile              = theme.dir .. '/icons/tile.png'
theme.layout_tileleft          = theme.dir .. '/icons/tileleft.png'
theme.layout_tilebottom        = theme.dir .. '/icons/tilebottom.png'
theme.layout_tiletop           = theme.dir .. '/icons/tiletop.png'
theme.layout_fairv             = theme.dir .. '/icons/fairv.png'
theme.layout_fairh             = theme.dir .. '/icons/fairh.png'
theme.layout_spiral            = theme.dir .. '/icons/spiral.png'
theme.layout_dwindle           = theme.dir .. '/icons/dwindle.png'
theme.layout_max               = theme.dir .. '/icons/max.png'
theme.layout_fullscreen        = theme.dir .. '/icons/fullscreen.png'
theme.layout_magnifier         = theme.dir .. '/icons/magnifier.png'
theme.layout_floating          = theme.dir .. '/icons/floating.png'
-- theme.widget_ac                                 = theme.dir .. '/icons/ac.png'
-- theme.widget_battery                            = theme.dir .. '/icons/battery.png'
-- theme.widget_battery_low                        = theme.dir .. '/icons/battery_low.png'
-- theme.widget_battery_empty                      = theme.dir .. '/icons/battery_empty.png'
-- theme.widget_mem                                = theme.dir .. '/icons/mem.png'
-- theme.widget_cpu                                = theme.dir .. '/icons/cpu.png'
-- theme.widget_temp                               = theme.dir .. '/icons/temp.png'
-- theme.widget_net                                = theme.dir .. '/icons/net.png'
-- theme.widget_hdd                                = theme.dir .. '/icons/hdd.png'
-- theme.widget_music                              = theme.dir .. '/icons/note.png'
-- theme.widget_music_on                           = theme.dir .. '/icons/note_on.png'
-- theme.widget_vol                                = theme.dir .. '/icons/vol.png'
-- theme.widget_vol_low                            = theme.dir .. '/icons/vol_low.png'
-- theme.widget_vol_no                             = theme.dir .. '/icons/vol_no.png'
-- theme.widget_vol_mute                           = theme.dir .. '/icons/vol_mute.png'
-- theme.widget_mail                               = theme.dir .. '/icons/mail.png'
-- theme.widget_mail_on                            = theme.dir .. '/icons/mail_on.png'
-- theme.titlebar_close_button_focus               = theme.dir .. '/icons/titlebar/close_focus.png'
-- theme.titlebar_close_button_normal              = theme.dir .. '/icons/titlebar/close_normal.png'
-- theme.titlebar_ontop_button_focus_active        = theme.dir .. '/icons/titlebar/ontop_focus_active.png'
-- theme.titlebar_ontop_button_normal_active       = theme.dir .. '/icons/titlebar/ontop_normal_active.png'
-- theme.titlebar_ontop_button_focus_inactive      = theme.dir .. '/icons/titlebar/ontop_focus_inactive.png'
-- theme.titlebar_ontop_button_normal_inactive     = theme.dir .. '/icons/titlebar/ontop_normal_inactive.png'
-- theme.titlebar_sticky_button_focus_active       = theme.dir .. '/icons/titlebar/sticky_focus_active.png'
-- theme.titlebar_sticky_button_normal_active      = theme.dir .. '/icons/titlebar/sticky_normal_active.png'
-- theme.titlebar_sticky_button_focus_inactive     = theme.dir .. '/icons/titlebar/sticky_focus_inactive.png'
-- theme.titlebar_sticky_button_normal_inactive    = theme.dir .. '/icons/titlebar/sticky_normal_inactive.png'
-- theme.titlebar_floating_button_focus_active     = theme.dir .. '/icons/titlebar/floating_focus_active.png'
-- theme.titlebar_floating_button_normal_active    = theme.dir .. '/icons/titlebar/floating_normal_active.png'
-- theme.titlebar_floating_button_focus_inactive   = theme.dir .. '/icons/titlebar/floating_focus_inactive.png'
-- theme.titlebar_floating_button_normal_inactive  = theme.dir .. '/icons/titlebar/floating_normal_inactive.png'
-- theme.titlebar_maximized_button_focus_active    = theme.dir .. '/icons/titlebar/maximized_focus_active.png'
-- theme.titlebar_maximized_button_normal_active   = theme.dir .. '/icons/titlebar/maximized_normal_active.png'
-- theme.titlebar_maximized_button_focus_inactive  = theme.dir .. '/icons/titlebar/maximized_focus_inactive.png'
-- theme.titlebar_maximized_button_normal_inactive = theme.dir .. '/icons/titlebar/maximized_normal_inactive.png'

function theme.set_wallpaper(screen)
    -- Wallpaper
    if theme.wallpaper then
        local wp = theme.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wp) == 'function' then wp = wp(screen) end
        Gears.wallpaper.maximized(wp, screen, true)
    end
end

---@param arg string|function()
---@param name string
function theme.confirm_action(arg, name)
    Awful.screen.focused().mywibox:set_bg(theme.bg_urgent)
    Awful.screen.focused().mywibox:set_fg(theme.fg_urgent)
    Awful.prompt.run {
        prompt = name .. ' [y/N] ',
        textbox = Awful.screen.focused().mypromptbox_conf.widget,
        exe_callback = function(t)
            if string.lower(t) == 'y' then
                if type(arg) == 'string' then
                    Awful.spawn.spawn(arg)
                else
                    arg()
                end
            end
        end,
        history_path = nil,
        done_callback = function()
            Awful.screen.focused().mywibox:set_bg(theme.screen_highlight_bg_active)
            Awful.screen.focused().mywibox:set_fg(theme.screen_highlight_fg_active)
        end
    }
end

theme.tagnames         = { '', '', '', '', '', '', '', '', '', '' }

theme.cpu_widget       = require('theme.widgets.cpu')
theme.ram_widget       = require('theme.widgets.ram')
theme.net_speed_widget = require('theme.widgets.net-speed')
theme.bluelight_widget = require('theme.widgets.bluelight')
theme.backlight_widget = require('theme.widgets.brightness')

local sep              = require('theme.widgets.separators')

local spr              = Wibox.widget.textbox(' ')
local arrl_dl          = sep.arrow_left(theme.bg_focus, 'alpha')
local arrl_ld          = sep.arrow_left('alpha', theme.bg_focus)

function theme.on_each_screen(scr)
    theme.set_wallpaper(scr)
    -- Tags
    Awful.tag(theme.tagnames, scr, Awful.layout.layouts[1])

    -- Create a promptbox for each screen
    scr.mypromptbox = Awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    scr.mylayoutbox = Awful.widget.layoutbox(scr)
    scr.mylayoutbox:buttons(Gears.table.join(
        Awful.button({}, 1, function() Awful.layout.inc(1) end),
        Awful.button({}, 2, function() Awful.layout.set(Awful.layout.layouts[1]) end),
        Awful.button({}, 3, function() Awful.layout.inc(-1) end),
        Awful.button({}, 4, function() Awful.layout.inc(1) end),
        Awful.button({}, 5, function() Awful.layout.inc(-1) end)))

    -- Create a wibox for each screen and add it
    -- Create a taglist widget
    scr.mytaglist  = Awful.widget.taglist {
        screen  = scr,
        filter  = Awful.widget.taglist.filter.all,
        buttons = Gears.table.join(
            Awful.button({}, 1, function(t) t:view_only() end),
            Awful.button({ ModKey }, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end),
            Awful.button({}, 3, Awful.tag.viewtoggle),
            Awful.button({ ModKey }, 3, function(t) if client.focus then client.focus:toggle_tag(t) end end),
            Awful.button({}, 4, function(t) Awful.tag.viewnext(t.screen) end),
            Awful.button({}, 5, function(t) Awful.tag.viewprev(t.screen) end)
        )

    }

    -- Create a tasklist widget
    scr.mytasklist = Awful.widget.tasklist {
        screen  = scr,
        filter  = Awful.widget.tasklist.filter.currenttags,
        buttons = Gears.table.join(
            Awful.button({}, 1, function(c)
                if c == client.focus then
                    c.minimized = true
                else
                    c:emit_signal('request::activate', 'tasklist', { raise = true })
                end
            end),
            Awful.button({}, 3, function() Awful.menu.client_list({ theme = { width = 250 } }) end),
            Awful.button({}, 4, function() Awful.client.focus.byidx(1) end),
            Awful.button({}, 5, function() Awful.client.focus.byidx(-1) end)
        )
    }

    -- Create the wibox
    scr.mywibox    = Awful.wibar({
        position = 'top',
        screen = scr,
        height = dpi(14),
        bg = theme.bg_normal,
        fg = theme.fg_normal,
    })

    -- Add widgets to the wibox
    scr.mywibox:setup {
        layout = Wibox.layout.align.horizontal,
        { -- Left widgets
            layout = Wibox.layout.fixed.horizontal,
            scr.mytaglist,
            scr.mypromptbox,
        },
        scr.mytasklist, -- Middle widget
        {               -- Right widgets
            layout = Wibox.layout.fixed.horizontal,
            Wibox.widget.systray(),
            -- spr,
            arrl_ld,
            Wibox.container.background(theme.bluelight_widget, theme.bg_focus),
            Wibox.container.background(spr, theme.bg_focus),
            Wibox.container.background(spr, theme.bg_focus),
            Wibox.container.background(spr, theme.bg_focus),
            Wibox.container.background(theme.backlight_widget({ program = 'xbacklight' }), theme.bg_focus),
            Wibox.container.background(theme.ram_widget({
                timeout = 2,
                color_used = theme.fg_focus,
                color_free = theme.border_normal,
                color_buf = theme.border_focus,
            }), theme.bg_focus),
            Wibox.container.background(theme.cpu_widget({
                color = theme.fg_focus,
                timeout = 2,
            }), theme.bg_focus),
            arrl_dl,
            Wibox.widget.textclock(),
            spr,
            arrl_ld,
            Wibox.container.background(scr.mylayoutbox, theme.bg_focus),
        },
    }
end

return theme
