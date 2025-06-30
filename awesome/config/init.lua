---@class Config
local cfg = {
    keybind = require('config.keybind'),
    mousebind = require('config.mousebind'),
    layouts = require('config.layouts'),
    startups = require('config.startups'),
    rules = require('config.rules'),
    signals = require('config.signals'),
}

function cfg:init()
    -- Run session and settings daemon
    self.startups:run()
    Awful.layout.layouts = self.layouts

    -- Wibar
    screen.connect_signal('property::geometry', Beautiful.set_wallpaper)
    Awful.screen.connect_for_each_screen(Beautiful.on_each_screen)

    -- Keybind
    root.buttons(self.mousebind.buttons())
    root.keys(self.keybind.global())

    Awful.rules.rules = self.rules(self)
    self.signals:init()
end

return cfg
