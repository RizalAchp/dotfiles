local client        = require "awful.client"
local screen        = require "awful.screen"

local lain_util     = require("lain.util")
local M             = {}
local cycle_prev    = false

M.focus_next_idx    = function() client.focus.byidx(1) end
M.focus_prev_idx    = function() client.focus.byidx(-1) end

M.layout_next_idx   = function() client.swap.byidx(1) end
M.layout_prev_idx   = function() client.swap.byidx(-1) end

M.layout_cycle_hist = function()
    if cycle_prev then
        client.focus.history.previous()
    else
        client.focus.byidx(-1)
    end
    if client.focus then
        client.focus:raise()
    end
end

M.focus_next        = function() screen.focus_relative(1) end
M.focus_prev        = function() screen.focus_relative(-1) end

M.focus_down        = function()
    client.focus.global_bydirection("down")
    if client.focus then client.focus:raise() end
end
M.focus_up          = function()
    client.focus.global_bydirection("up")
    if client.focus then client.focus:raise() end
end
M.focus_left        = function()
    client.focus.global_bydirection("left")
    if client.focus then client.focus:raise() end
end

M.focus_right       = function()
    client.focus.global_bydirection("right")
    if client.focus then client.focus:raise() end
end

M.view_left_tags    = function()
    lain_util.tag_view_nonempty(-1)
end
M.view_right_tags   = function()
    lain_util.tag_view_nonempty(1)
end

M.inc_gaps          = function() lain_util.useless_gaps_resize(1) end
M.dec_gaps          = function() lain_util.useless_gaps_resize(-1) end


M.toggle_wibox = function()
    for s in screen do
        s.mywibox.visible = not s.mywibox.visible
        if s.mybottomwibox then s.mybottomwibox.visible = not s.mybottomwibox.visible end
    end
end

--[[ awful.key({ modkey, shifts }, "n", function() lain.util.add_tag() end,
    { description = "add new tag", group = "tag" }),
awful.key({ modkey, shifts }, "r", function() lain.util.rename_tag() end,
    { description = "rename tag", group = "tag" }),
awful.key({ modkey, shifts }, "Left", function() lain.util.move_tag(-1) end,
    { description = "move tag to the left", group = "tag" }),
awful.key({ modkey, shifts }, "Right", function() lain.util.move_tag(1) end,
    { description = "move tag to the right", group = "tag" }),
awful.key({ modkey, shifts }, "d", function() lain.util.delete_tag() end,
    { description = "delete tag", group = "tag" }), ]]
M.tags_new = function() lain_util.add_tag() end
M.tags_rename = function() lain_util.rename_tag() end
M.tags_left = function() lain_util.move_tag(-1) end
M.tags_right = function() lain_util.move_tag(1) end
M.tags_delete = function() lain_util.delete_tag() end

return M
