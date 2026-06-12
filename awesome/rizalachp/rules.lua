---comment

---@param cfg Config
---@return table
local rules = function(cfg)
  local function TGN(idx) return Beautiful.tagnames[idx] end
  return {
    -- All clients will match this rule.
    {
      rule = {},
      properties = {
        border_width = Beautiful.border_width,
        border_color = Beautiful.border_normal,
        focus = Awful.client.focus.filter,
        raise = true,
        keys = cfg.keybind.client(),
        buttons = cfg.mousebind.clientbutton(),
        screen = Awful.screen.preferred,
        placement = Awful.placement.no_overlap + Awful.placement.no_offscreen,
      },
    },

    -- Floating clients.
    {
      rule_any = {
        instance = {
          'DTA', -- Firefox addon DownThemAll.
          'copyq', -- Includes session name in class.
          'pinentry',
        },
        class = {
          'Arandr',
          'Blueman-manager',
          'Gpick',
          'Kruler',
          'MessageWin', -- kalarm.
          'Sxiv',
          'Tor Browser', -- Needs a fixed window size to avoid fingerprinting by screen size.
          'Wpa_gui',
          'veromix',
          'xtightvncviewer',
        },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          'Event Tester', -- xev.
        },
        role = {
          'AlarmWindow', -- Thunderbird's calendar.
          'ConfigManager', -- Thunderbird's about:config.
          'pop-up', -- e.g. Google Chrome's (detached) Developer Tools.
        },
      },
      properties = { floating = true },
    },

    -- Add titlebars to normal clients and dialogs
    {
      rule_any = { type = { 'normal', 'dialog' } },
      properties = { titlebars_enabled = false },
    },

    { rule_any = { role = { 'browser' } }, properties = { tag = TGN(2), switchtotag = true } },
    { rule = { class = 'Thunar' }, properties = { tag = TGN(3), switchtotag = true } },
    { rule = { class = 'KiCad' }, properties = { tag = TGN(4), switchtotag = true } },
    { rule = { class = 'neovide' }, properties = { floating = true } },

    {
      rule = { class = 'com-st-microxplorer-maingui-STM32CubeMX' },
      properties = { tag = TGN(4), switchtotag = true },
    },
  }
end

return rules
