local mousebind = {}

function mousebind.buttons()
    local my_mainmenu = Awful.menu({
        items = {
            { 'awesome', {
                { 'hotkeys',     function() HotkeysPopup.show_help(nil, Awful.screen.focused()) end },
                { 'manual',      Apps.terminal.name .. ' -e man awesome' },
                { 'edit config', Apps.editor_cmd.name .. ' ' .. awesome.conffile },
                { 'restart',     awesome.restart },
                { 'quit',        function() Beautiful.confirm_action(awesome.quit, 'Quit') end },
            }, Beautiful.awesome_icon },

            { 'open terminal', Apps.terminal.run },
            { 'htop',          Apps.terminal.name .. ' -e htop' },
        }
    })

    return Gears.table.join(
    -- No Mouse!
        Awful.button({}, 3, function() my_mainmenu:toggle() end),
        Awful.button({}, 4, Awful.tag.viewnext),
        Awful.button({}, 5, Awful.tag.viewprev)
    )
end

function mousebind.clientbutton()
    return Gears.table.join(
        Awful.button({}, 1, function(c) c:emit_signal('request::activate', 'mouse_click', { raise = true }) end),
        Awful.button({ ModKey }, 1, function(c)
            c:emit_signal('request::activate', 'mouse_click', { raise = true })
            Awful.mouse.client.move(c)
        end),
        Awful.button({ ModKey }, 3, function(c)
            c:emit_signal('request::activate', 'mouse_click', { raise = true })
            Awful.mouse.client.resize(c)
        end)
    )
end

return mousebind
