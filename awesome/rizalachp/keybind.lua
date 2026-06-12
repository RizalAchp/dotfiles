-- stylua: ignore start
local keybind = {}

---@format disable-next
function keybind.global()
    local function focus_hist()
        Awful.client.focus.history.previous()
        if client.focus then client.focus:raise() end
    end

    local function restore_minimize()
        local c = Awful.client.restore()
        if c then
            c:emit_signal(
                'request::activate', 'key.unminimize', { raise = true }
            )
        end
    end

    local function toggle_wibox()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
    end

    local function useless_gaps_resize(thatmuch, s, t)
        local scr = s or Awful.screen.focused()
        local tag = t or scr.selected_tag
        tag.gap = tag.gap + tonumber(thatmuch)
        Awful.layout.arrange(scr)
    end


    local tbl = Gears.table.join(

        Awful.key({ ModKey, 'Control' }, 'r',   awesome.restart,                                { description = 'reload awesome',               group = 'awesome' }),
        Awful.key({ ModKey }, 's',              HotkeysPopup.show_help,                         { description = 'show help',                    group = 'awesome' }),
        Awful.key({ ModKey }, 'b',              toggle_wibox,                                   { description = 'toggle wibox',                 group = 'awesome' }),

        Awful.key({ ModKey }, 'Left',           Awful.tag.viewprev,                             { description = 'view previous',                group = 'tag' }),
        Awful.key({ ModKey }, 'Right',          Awful.tag.viewnext,                             { description = 'view next',                    group = 'tag' }),
        Awful.key({ ModKey }, 'Escape',         Awful.tag.history.restore,                      { description = 'go back',                      group = 'tag' }),
        Awful.key({ ModKey, 'Control' }, '=',   function() useless_gaps_resize(1) end,          { description = 'increment useless gaps',       group = 'tag' }),
        Awful.key({ ModKey, 'Control' }, '-',   function() useless_gaps_resize(-1) end,         { description = 'decrement useless gaps',       group = 'tag' }),

        -- Layout manipulation
        Awful.key({ ModKey },            'j',   function() Awful.client.focus.byidx(1) end,     { description = 'focus next by index',          group = 'client' }),
        Awful.key({ ModKey },            'k',   function() Awful.client.focus.byidx(-1) end,    { description = 'focus prev by index',          group = 'client' }),
        Awful.key({ ModKey, 'Shift' },   'j',   function() Awful.client.swap.byidx(1) end,      { description = 'swap with next client',        group = 'client' }),
        Awful.key({ ModKey, 'Shift' },   'k',   function() Awful.client.swap.byidx(-1) end,     { description = 'swap with prev client',        group = 'client' }),
        Awful.key({ ModKey, },           'u',   Awful.client.urgent.jumpto,                     { description = 'jump to urgent client',        group = 'client' }),
        Awful.key({ ModKey, },           'Tab', focus_hist,                                     { description = 'go back',                      group = 'client' }),
        Awful.key({ ModKey, 'Control' }, 'n',   restore_minimize,                               { description = 'restore minimized',            group = 'client' }),

        Awful.key({ ModKey, 'Control' }, 'j',   function() Awful.screen.focus_relative(1) end,  { description = 'focus the next screen',        group = 'screen' }),
        Awful.key({ ModKey, 'Control' }, 'k',   function() Awful.screen.focus_relative(-1) end, { description = 'focus the previous screen',    group = 'screen' }),

        Awful.key({ ModKey, },           'l',   function() Awful.tag.incmwfact(0.05) end,       { description = 'increase master width factor', group = 'layout' }),
        Awful.key({ ModKey, },           'h',   function() Awful.tag.incmwfact(-0.05) end,      { description = 'decrease master width factor', group = 'layout' }),
        Awful.key({ ModKey, 'Shift' },   'h',   function() Awful.tag.incnmaster(1,nil,true) end,{ description = 'incr of master clients',       group = 'layout' }),
        Awful.key({ ModKey, 'Shift' },   'l',   function() Awful.tag.incnmaster(-1,nil,true)end,{ description = 'decr of master clients',       group = 'layout' }),
        Awful.key({ ModKey, 'Control' }, 'h',   function() Awful.tag.incncol(1,nil,true) end,   { description = 'incr number of columns',       group = 'layout' }),
        Awful.key({ ModKey, 'Control' }, 'l',   function() Awful.tag.incncol(-1,nil,true) end,  { description = 'decr number of columns',       group = 'layout' }),
        Awful.key({ ModKey, },         'space', function() Awful.layout.inc(1) end,             { description = 'select next',                  group = 'layout' }),
        Awful.key({ ModKey, 'Shift' }, 'space', function() Awful.layout.inc(-1) end,            { description = 'select previous',              group = 'layout' }),

        -- Prompt
        Awful.key({ ModKey, 'Shift' },   'q',   Apps.power_menu.run,                                 { description = 'powermenu',        group = 'launcher' }),
        -- Awful.key({ ModKey }, 'r', function() Awful.screen.focused().mypromptbox:run() end,  { description = 'run prompt', group = 'launcher' }),
        -- -- Builtin Menubar
        Awful.key({ ModKey }, 'p',              function() Menubar.show() end,                  { description = 'show the menubar', group = 'launcher' }),
        -- -- Dmenu
        -- Awful.key({ ModKey }, "p",              Apps.dmenu.spawn,               { description = 'show dmenu',       group = 'launcher' }),

        Awful.key({ ModKey }, 'Return',         Apps.terminal.run,    { description = 'open a terminal',    group = 'application' }),
        Awful.key({ ModKey,   'Shift' }, 'b',   Apps.browser.run,     { description = 'open a browser',     group = 'application' }),
        Awful.key({ ModKey,   'Shift' }, 'm',   Apps.filemanager.run, { description = 'open a filemanager', group = 'application' }),
        Awful.key({ }, 'XF86WWW',               Apps.browser.run,     { description = 'open a browser',     group = 'application' }),
        Awful.key({ }, 'XF86Explorer',          Apps.filemanager.run, { description = 'open a filemanager', group = 'application' }),
        Awful.key({ }, 'XF86Calculator',        Apps.calculator.run,  { description = 'open a calculator',  group = 'hotkeys' }),


        Awful.key({ ModKey, 'Shift' },   's',   Apps.screenshot_select.run, { description = 'take selected area screenshot',    group = 'hotkeys' }),
        Awful.key({ ModKey, 'Shift' },   'w',   Apps.screenshot_window.run, { description = 'take current window screenshot',   group = 'hotkeys' }),
        Awful.key({ }, 'Print',                 Apps.screenshot_full.run,   { description = 'take full screenshot',            group = 'hotkeys' }),
        Awful.key({ }, 'XF86ScreenSaver',       Apps.screenlock.run,        { description = 'lock screen',                      group = 'hotkeys' }),

        -- Awful.key({ }, 'XF86AudioRaiseVolume',  Apps.alsa_up.run,           { description = 'volume up',                        group = 'hotkeys' }),
        -- Awful.key({ }, 'XF86AudioLowerVolume',  Apps.alsa_down.run,         { description = 'volume down',                      group = 'hotkeys' }),
        -- Awful.key({ }, 'XF86AudioMute',         Apps.alsa_mute.run,         { description = 'toggle mute',                      group = 'hotkeys' }),

        Awful.key({ }, 'XF86Launch1',           Apps.xrandr.xrandr,              { description = 'toggle mute',                      group = 'hotkeys' }),
        Awful.key({ 'Control' },       'space', Naughty.destroy_all_notifications, { description = 'destroy all notifications', group = 'hotkeys' })

    -- awful.key({ ModKey }, 'x',
    --     function()
    --         awful.prompt.run {
    --             prompt       = 'Run Lua code: ',
    --             textbox      = awful.screen.focused().mypromptbox.widget,
    --             exe_callback = awful.util.eval,
    --             history_path = awful.util.get_cache_dir() .. '/history_eval'
    --         }
    --     end,
    --     { description = 'lua execute prompt', group = 'awesome' }),
    -- Menubar
    )
    for i = 1, 9 do
        tbl = Gears.table.join(tbl,
            -- View tag only.
            Awful.key({ ModKey }, '#' .. i + 9,
                function()
                    local screen = Awful.screen.focused()
                    local tag = screen.tags[i]
                    if tag then tag:view_only() end
                end,
                { description = 'view tag #' .. i, group = 'tag' }),
            -- Toggle tag display.
            Awful.key({ ModKey, 'Control' }, '#' .. i + 9,
                function()
                    local screen = Awful.screen.focused()
                    local tag = screen.tags[i]
                    if tag then Awful.tag.viewtoggle(tag) end
                end,
                { description = 'toggle tag #' .. i, group = 'tag' }),
            -- Move client to tag.
            Awful.key({ ModKey, 'Shift' }, '#' .. i + 9,
                function()
                    if client.focus then
                        local tag = client.focus.screen.tags[i]
                        if tag then client.focus:move_to_tag(tag) end
                    end
                end,
                { description = 'move focused client to tag #' .. i, group = 'tag' }),
            -- Toggle tag on focused client.
            Awful.key({ ModKey, 'Control', 'Shift' }, '#' .. i + 9,
                function()
                    if client.focus then
                        local tag = client.focus.screen.tags[i]
                        if tag then client.focus:toggle_tag(tag) end
                    end
                end,
                { description = 'toggle focused client on tag #' .. i, group = 'tag' })
        )
    end

    return tbl
end

---@format disable-next
function keybind.client()
    local function toggle_fullscr(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end
    local function unmaximize(c)
        c.maximized = not c.maximized
        c:raise()
    end
    -- local function unmaximize_vert(c)
    --     c.maximized_vertical = not c.maximized_vertical
    --     c:raise()
    -- end
    -- local function unmaximize_horz(c)
    --     c.maximized_horizontal = not c.maximized_horizontal
    --     c:raise()
    -- end
    return Gears.table.join(
        Awful.key({ ModKey },            'f',      toggle_fullscr,                                   { description = 'toggle fullscreen',         group = 'client' }),
        Awful.key({ ModKey, 'Shift' },   'c',      function(c) c:kill() end,                         { description = 'close',                     group = 'client' }),
        Awful.key({ ModKey, 'Control' }, 'space',  Awful.client.floating.toggle,                     { description = 'toggle floating',           group = 'client' }),
        Awful.key({ ModKey, 'Control' }, 'Return', function(c) c:swap(Awful.client.getmaster()) end, { description = 'move to master',            group = 'client' }),
        Awful.key({ ModKey },            'o',      function(c) c:move_to_screen() end,               { description = 'move to screen',            group = 'client' }),
        Awful.key({ ModKey },            't',      function(c) c.ontop = not c.ontop end,            { description = 'toggle keep on top',        group = 'client' }),

        --[[ The client currently has the input focus, so it cannot be minimized, since minimized clients can't have the focus. ]] --
        -- Awful.key({ ModKey },            'n',      function(c) c.minimized = true end,               { description = 'minimize',                  group = 'client' }),
        Awful.key({ ModKey },            'm',      unmaximize,                                       { description = '(un)maximize',              group = 'client' })
        -- Awful.key({ ModKey, 'Control' }, 'm',      unmaximize_vert,                                  { description = '(un)maximize vertically',   group = 'client' }),
        -- Awful.key({ ModKey, 'Shift' },   'm',      unmaximize_horz,                                  { description = '(un)maximize horizontally', group = 'client' })
    )
end

-- stylua: ignore end

return keybind
