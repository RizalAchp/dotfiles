---@alias ScreenshotKind 'full' | 'select' | 'window'

local xdg_pictures = os.getenv('XDG_PICTURES_DIR') or (HomeDir .. '/Pictures')
local screenshots = {
  full = { dir = xdg_pictures .. '/Screenshots/' },
  select = { dir = xdg_pictures .. '/Screenshots/select/' },
  window = { dir = xdg_pictures .. '/Screenshots/window/' },
}
for mode, item in pairs(screenshots) do
  local ok, err = Gears.filesystem.make_directories(item.dir)
  if not ok then
    Naughty.notify({
      preset = Naughty.config.presets.warn,
      title = string.format('Failed Create Screenshots (%s) Directory', mode),
      text = string.format('Failed to create screenshot (mode: %s), directory. (dir: %q). %s', mode, item.dir, err),
    })
  end
end

---@class ThumbnailScreenshot
local thumbnail = {}

function thumbnail:close()
  if self.timer and self.timer.started then self.timer:stop() end

  if self.popup then
    self.popup.visible = false
    self.popup = nil
  end

  self.timer = nil
end

function thumbnail:show(image_path)
  self:close()

  local widget = Wibox.widget({
    image = image_path,
    forced_height = 180,
    forced_width = 320,
    widget = Wibox.widget.imagebox,
  })
  widget:buttons(Gears.table.join(Awful.button({}, 1, function()
    self:close()
    Awful.spawn.with_shell('xdg-open \'' .. image_path .. '\'')
  end)))

  self.popup = Awful.popup({
    widget = widget,
    border_color = '#FFFFFF',
    border_width = 2,
    ontop = true,
    visible = true,
    placement = function(d)
      Awful.placement.bottom_right(d, {
        margins = {
          bottom = 50,
          right = 50,
        },
      })
    end,
    screen = Awful.screen.focused(),
  })

  self.timer = Gears.timer({
    timeout = 3,
    autostart = true,
    single_shot = true,
    callback = function()
      Gears.timer({
        timeout = 0.6,
        autostart = true,
        single_shot = true,
        callback = function() self:close() end,
      })
    end,
  })
end

---@param filepath string
local function copy_to_clipboard(filepath)
  Awful.spawn.easy_async(
    { 'xclip', '-selection', 'clipboard', '-t', 'image/png', '-i', filepath },
    ---@param _ string
    ---@param stderr string
    ---@param exit_reason string
    ---@param exit_code integer
    function(_, stderr, exit_reason, exit_code)
      if exit_code == 0 then return thumbnail:show(filepath) end
      Naughty.notify({
        preset = Naughty.config.presets.warn,
        title = 'Failed Copy Screenshot to Clipboard',
        text = string.format(
          'Screenshot %q cannot copied to clipboard, using `xclip`.\nmake sure `xclip` installed.\n\nERROR(%s: %d):%s',
          filepath,
          stderr,
          exit_reason,
          exit_code
        ),
      })
    end
  )
end

---@param dir string
---@param kind ScreenshotKind kind of the screenshot filename
local function gen_filename(dir, kind)
  local d = os.date('%d-%m-%Y_%H-%M-%S')
  return dir .. d .. '_' .. kind .. '.png'
end

---@param mode ScreenshotKind
---@param stderr string
---@param exit_reason string
---@param exit_code integer
local function fail_screenshot(mode, stderr, exit_reason, exit_code)
  Naughty.notify({
    preset = Naughty.config.presets.warn,
    title = string.format('Failed get Screenshot (%s)', mode),
    text = string.format(
      'Failed to get Screenshot (mode: %s), using `maim`.\nmake sure `maim` installed.\n\nERROR(%s: %d): %s',
      mode,
      stderr,
      exit_reason,
      exit_code
    ),
  })
end

function screenshots.full:call()
  local mode = 'full'
  local filename = gen_filename(self.dir, mode)

  Awful.spawn.easy_async({ 'maim', '-q', filename }, function(_, stderr, exit_reason, exit_code)
    if exit_code == 0 then return copy_to_clipboard(filename) end
    fail_screenshot(mode, stderr, exit_reason, exit_code)
  end)
end

function screenshots.select:call()
  local mode = 'select'
  local filename = gen_filename(self.dir, mode)

  Awful.spawn.easy_async({ 'maim', '-q', '-D', '-s', filename }, function(_, stderr, exit_reason, exit_code)
    if exit_code == 0 then return copy_to_clipboard(filename) end
    fail_screenshot(mode, stderr, exit_reason, exit_code)
  end)
end

function screenshots.window:call()
  local mode = 'window'
  local filename = gen_filename(self.dir, mode)

  if client.focus or client.focus:isvisible() then
    Awful.spawn.easy_async({ 'maim', '-q', '-D', '-i', client.focus.window, '-s', filename }, function(_, stderr, exit_reason, exit_code)
      if exit_code == 0 then return copy_to_clipboard(filename) end
      fail_screenshot(mode, stderr, exit_reason, exit_code)
    end)
  else
    Naughty.notify({
      preset = Naughty.config.presets.warn,
      title = 'No focused window',
      text = 'Please focus a window before taking a screenshot of the window.',
    })
  end
end

local M = {}
M.full = function() return screenshots.full:call() end
M.select = function() return screenshots.select:call() end
M.window = function() return screenshots.window:call() end
return M
