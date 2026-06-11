---@alias FloatTermOpenOption {width?: number, height?: number, anchor?: 'center'|'top'|'bottom'}
---@alias FloatTermState {buf?: integer, win?: integer, open: boolean, open_option: FloatTermOpenOption}

local M = {}
---@type FloatTermState
M.state = {
  buf = nil,
  win = nil,
  open = false,
  open_option = {
    width = 0.8,
    height = 0.8,
    anchor = 'center',
  },
}

M.is_open = function() return M.state.open and vim.api.nvim_win_is_valid(M.state.win) end

M.close = function()
  if M.is_open() then
    vim.api.nvim_win_close(M.state.win, false)
    M.state.open = false
  end
end

M.open = function(opt)
  -- If terminal is already open, close it (toggle behavior)
  if M.is_open() then return M.close() end

  -- Create buffer if it doesn't exist or is invalid
  if not M.state.buf or not vim.api.nvim_buf_is_valid(M.state.buf) then
    M.state.buf = vim.api.nvim_create_buf(false, true)
    -- Set buffer options for better terminal experience
    vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = M.state.buf })
  end

  ---@type {width: number, height: number, anchor: 'center'|'top'|'bottom'}
  local sopt = vim.tbl_extend('keep', opt or {}, M.state.open_option)

  -- set default if number is malformed
  if not (sopt.width >= 0 and sopt.width <= 1.0) then sopt.width = M.state.open_option.width end
  if not (sopt.height >= 0 and sopt.height <= 1.0) then sopt.height = M.state.open_option.height end

  -- Calculate window dimensions
  local width = math.floor(vim.o.columns * sopt.width)
  local height = math.floor(vim.o.lines * sopt.height)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = 0

  if sopt.anchor == 'center' then
    row = math.floor((vim.o.lines - height) / 2)
  elseif sopt.anchor == 'top' then
    row = 1
  elseif sopt.anchor == 'bottom' then
    row = math.max(0, vim.o.lines - height)
  end

  -- Create the floating window
  M.state.win = vim.api.nvim_open_win(M.state.buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  -- Set transparency for the floating window
  vim.api.nvim_set_option_value('winblend', 0, { win = M.state.win })

  -- Set transparent background for the window
  vim.api.nvim_set_option_value('winhighlight', 'Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder', { win = M.state.win })

  -- Define highlight groups for transparency
  vim.api.nvim_set_hl(0, 'FloatingTermNormal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'FloatingTermBorder', { bg = 'none' })

  -- Start terminal if not already running
  local has_terminal = false
  local lines = vim.api.nvim_buf_get_lines(M.state.buf, 0, -1, false)
  for _, line in ipairs(lines) do
    if line ~= '' then
      has_terminal = true
      break
    end
  end

  if not has_terminal then vim.fn.jobstart(_G.Shell, { term = true }) end

  M.state.open = true
  vim.cmd('startinsert')

  -- Set up auto-close on buffer leave
  vim.api.nvim_create_autocmd('BufLeave', {
    group = vim.api.nvim_create_augroup('rizalachp-float-terminal-onclose', { clear = true }),
    buffer = M.state.buf,
    callback = M.close,
    once = true,
  })
end

M.toggle = function(opt)
  if M.is_open() then
    M.close()
  else
    M.open(opt)
  end
end

return M
