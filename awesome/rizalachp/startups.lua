local startups = {
  table = {
    { cmd = { 'lxsession', '-a', '-n', '-r', '-s', 'awesome', '-e', 'LXDE' }, once = true },
    { cmd = 'lxpolkit', once = true },
    { cmd = { 'thunar', '--daemon' }, once = true },
    -- { cmd = 'monitor.py 1',                          once = true },
  },
}

function startups:run()
  for _, value in ipairs(self.table) do
    if value.once then
      Awful.spawn.once(value.cmd)
    else
      Awful.spawn.spawn(value.cmd, false)
    end
  end
end

return startups
