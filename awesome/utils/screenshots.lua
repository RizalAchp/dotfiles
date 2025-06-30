SSDIR = os.getenv('HOME') .. '/Pictures/Screenshots/' .. os.date('%d_%m_%Y')

---@param command string
---@param kind 'full' | 'select' | 'window'
---@return function
return function(command, kind)
    return function()
        if not Gears.filesystem.dir_readable(SSDIR) then
            Gears.filesystem.make_directories(SSDIR)
        end
        local path = string.format('%s/%s-%s.png', SSDIR, kind, os.date('%H_%M_%S'))
        local command_str = string.format(
            "maim -q -f png %s | tee '%s' | xclip -selection clipboard -target image/png",
            command, path
        )

        Awful.spawn.easy_async({ Awful.util.shell, '-c', command_str }, function()
            Naughty.notify({
                preset = Naughty.config.presets.normal,
                title = 'Screenshot Captured!',
                text = string.format(
                    "Your screenshot has been successfully saved at:\n'%s'\n\n It has also been copied to your clipboard!",
                    path
                )
            })
        end)
    end
end
