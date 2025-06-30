local startups = {
    table = {
        { cmd = 'lxsession -a -n -r -s awesome -e LXDE', once = true },
        { cmd = 'lxpolkit',                              once = true },
        { cmd = 'thunar --daemon',                       once = true },
        { cmd = 'monitor.py 1',                          once = true },
    }
}

local function run_once(cmd)
    Awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
end

function startups:run()
    for _, value in ipairs(self.table) do
        if type(value.cmd) == 'string' then
            if value.once then
                run_once(value.cmd)
            else
                Awful.spawn.spawn(value.cmd, true)
            end
        else
            value.cmd()
        end
    end
end

return startups
