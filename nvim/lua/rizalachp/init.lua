do
  ---@alias KeymapMode 'n'|'t'|'v'|'V'|'c'|'s'|'S'|'r'|'R'|'x'

  ---@class Keymap
  ---@field [1]     KeymapMode|KeymapMode[]
  ---@field key      string
  ---@field cb       string|function
  ---@field desc     string
  ---@field opts?    vim.keymap.set.Opts

  function _G.P(cmd) print(vim.inspect(cmd)) end

  ---@type fun(keymaps: Keymap[])
  function _G.set_keymaps(keymaps)
    for _, k in ipairs(keymaps) do
      local opts = vim.tbl_extend('force', { desc = k.desc }, k.opts or {})
      vim.keymap.set(k[1], k.key, k.cb, opts)
    end
  end
  vim.g.float_terminal = require('rizalachp.float_terminal')
end

do
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = 'none' })

  local mySysname = vim.loop.os_uname().sysname
  local isWin = mySysname:find('Windows') and true or false

  if isWin then
    local shell = 'powershell.exe' --"powershell" for 5.x
    if vim.fn.executable('pwsh') == 1 then
      shell = 'pwsh.exe' --"pwsh" for 7.x if installed
    end
    -- vim.opt.shellcmdflag =
    -- "-NoProfile -NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';$PSStyle.OutputRendering='plaintext';Remove-Alias -Force -ErrorAction SilentlyContinue tee;"
    vim.opt.shell = shell
    -- Setting shell command flags
    vim.o.shellcmdflag =
      '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[\'Out-File:Encoding\']=\'utf8\';'

    -- Setting shell redirection
    vim.o.shellredir = '2>&1 | %{ "$_" } | Out-File %s; exit $LastExitCode'

    -- Setting shell pipe
    vim.o.shellpipe = '2>&1 | %{ "$_" } | Tee-Object %s; exit $LastExitCode'

    -- Setting shell quote options
    vim.o.shellquote = ''
    vim.o.shellxquote = ''
    _G.Shell = shell
  else
    _G.Shell = os.getenv('SHELL') or '/usr/bin/sh'
    vim.opt.shell = _G.Shell
  end

  -- Basic
  vim.opt.number = true -- line number
  vim.opt.relativenumber = true -- relative line number
  vim.opt.cursorline = true -- highlight current line
  vim.opt.wrap = false -- Don't wrap line
  vim.opt.scrolloff = 10 -- Keep 10 lines above/below cursor
  vim.opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor

  -- Indentation
  vim.opt.tabstop = 4 -- Tab width
  vim.opt.shiftwidth = 4 -- Indent width
  -- v.opt.softtabstop = 4             -- soft tab stop
  vim.opt.expandtab = true -- use spaces instead of tab
  vim.opt.smartindent = true -- auto smart indenting
  vim.opt.autoindent = true -- copy indent from current line
  vim.bo.indentexpr = [[v:lua.require('nvim-treesitter').indentexpr()]]

  -- Search settings
  vim.opt.ignorecase = true -- Case insensitive search
  vim.opt.smartcase = true -- Case sensitive if uppercase in search
  vim.opt.hlsearch = false -- Don't highlight search results
  vim.opt.incsearch = true -- Show matches as you type

  -- Visual settings
  vim.opt.termguicolors = true -- Enable 24-bit colors
  vim.opt.signcolumn = 'yes' -- Always show sign column
  vim.opt.colorcolumn = '80' -- Show column at 100 characters
  vim.opt.showmatch = true -- Highlight matching brackets
  vim.opt.matchtime = 2 -- How long to show matching bracket
  vim.opt.cmdheight = 1 -- Command line height
  vim.opt.completeopt = 'menuone,noinsert,noselect' -- Completion options
  vim.opt.showmode = false -- Don't show mode in command line
  vim.opt.pumheight = 10 -- Popup menu height
  vim.opt.pumblend = 10 -- Popup menu transparency
  vim.opt.winblend = 0 -- Floating window transparency
  vim.opt.conceallevel = 0 -- Don't hide markup
  vim.opt.concealcursor = '' -- Don't hide cursor line markup
  vim.opt.lazyredraw = true -- Don't redraw during macros
  vim.opt.synmaxcol = 300 -- Syntax highlighting limit
  vim.o.inccommand = 'split' -- Preview substitutions live, as you type!

  -- File handling
  vim.opt.backup = false -- Don't create backup files
  vim.opt.writebackup = false -- Don't create backup before writing
  vim.opt.swapfile = false -- Don't create swap files
  vim.opt.undofile = true -- Persistent undo
  vim.opt.updatetime = 250 -- Faster completion
  vim.opt.timeoutlen = 300 -- Key timeout duration
  vim.opt.ttimeoutlen = 0 -- Key code timeout
  vim.opt.autoread = true -- Auto reload files changed outside vim
  vim.opt.autowrite = false -- Don't auto save

  -- Behavior settings
  vim.opt.hidden = true -- Allow hidden buffers
  vim.opt.errorbells = false -- No error bells
  vim.opt.backspace = 'indent,eol,start' -- Better backspace behavior
  vim.opt.autochdir = false -- Don't auto change directory
  vim.opt.iskeyword:append('-') -- Treat dash as part of word
  vim.opt.path:append('**') -- include subdirectories in search
  vim.opt.selection = 'exclusive' -- Selection behavior
  vim.opt.mouse = 'a' -- Enable mouse support

  -- vim.opt.clipboard:append("unnamedplus")
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end) -- Use system clipboard
  vim.opt.modifiable = true -- Allow buffer modifications
  vim.opt.encoding = 'UTF-8' -- Set encoding
  vim.o.confirm = true -- raise a dialog asking if you wish to save the current file(s)

  -- Folding settings
  vim.opt.foldmethod = 'marker' -- Use marker for folding
  -- vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- Use treesitter for folding
  vim.opt.foldlevel = 99 -- Start with all folds open

  -- Split behavior
  vim.opt.splitbelow = true -- Horizontal splits go below
  vim.opt.splitright = true -- Vertical splits go right

  -- Key mappings
  vim.g.mapleader = ' ' -- Set leader key to space
  vim.g.maplocalleader = ' ' -- Set local leader key (NEW)

  vim.cmd([[ 
    let s:guifontsize = 10 
    let s:guifont = "JetBrainsMono Nerd Font" 
  ]])

  vim.opt.background = 'dark'
  vim.opt.grepprg = 'rg --vimgrep --smart-case --follow'
  -- Command-line completion
  vim.opt.wildmenu = true
  vim.opt.wildmode = 'noselect:lastused,full'
  vim.opt.wildoptions = 'pum,fuzzy,tagfile'
  vim.opt.wildignore:append({ '*.o', '*.obj', '*.pyc', '*.class', '*.jar' })
  -- Better diff options
  vim.opt.diffopt:append('linematch:60')
  -- Performance improvements
  vim.opt.redrawtime = 10000
  vim.opt.maxmempattern = 20000

  -- Tab display settings
  vim.opt.showtabline = 1 -- Always show tabline (0=never, 1=when multiple tabs, 2=always)
  vim.opt.tabline = '' -- Use default tabline (empty string uses built-in)

  -- Transparent tabline appearance
  vim.cmd([[ hi TabLineFill guibg=NONE ctermfg=242 ctermbg=NONE ]])
end

do
  local function open_file_newtab()
    vim.ui.input({ prompt = 'File to open in new tab: ', completion = 'file' }, function(input)
      if input and input ~= '' then vim.cmd('tabnew ' .. input) end
    end)
  end
  local function duplicate_curtab()
    local current_file = vim.fn.expand('%:p')
    if current_file ~= '' then
      vim.cmd('tabnew ' .. current_file)
    else
      vim.cmd('tabnew')
    end
  end
  local function close_tab_right()
    local current_tab = vim.fn.tabpagenr()
    local last_tab = vim.fn.tabpagenr('$')

    for i = last_tab, current_tab + 1, -1 do
      vim.cmd(i .. 'tabclose')
    end
  end
  local function close_tab_left()
    local current_tab = vim.fn.tabpagenr()

    for _ = current_tab - 1, 1, -1 do
      vim.cmd('1tabclose')
    end
  end

  local function smart_close_tab()
    local buffers_in_tab = #vim.fn.tabpagebuflist()
    if buffers_in_tab > 1 then
      vim.cmd('bdelete')
    else
      -- If it's the only buffer in tab, close the tab
      vim.cmd('tabclose')
    end
  end

  set_keymaps({
    { { 'n', 'v' }, key = '<Space>', cb = '<Nop>', desc = 'GENERAL: Set Space into <Nop>' },
    { 'n', key = '<ESC>', cb = ':nohlsearch<CR>', desc = 'GENERAL: Clear search Highlight' },
    { 'n', key = 'Y', cb = 'y$', desc = 'GENERAL: Yank to EOL' },
    { 'x', key = '<leader>p', cb = '"_dP', desc = 'GENERAL: Paste without yanking' },
    { { 'n', 'v' }, key = '<leader>d', cb = '"_d', desc = 'GENERAL: Delete without yanking' },
    { 'n', key = 'j', cb = 'gj', desc = 'GENERAL: Motion to up easier' },
    { 'n', key = 'k', cb = 'gk', desc = 'GENERAL: Motion to down easier' },

    -- keeping it centered
    { 'n', key = 'n', cb = 'nzzzv', desc = 'GENERAL: Next search result (centered)' },
    { 'n', key = 'N', cb = 'Nzzzv', desc = 'GENERAL: Prev search result (centered)' },
    { 'n', key = '<C-d>', cb = '<C-d>zz', desc = 'GENERAL: Half page down (centered)' },
    { 'n', key = '<C-u>', cb = '<C-u>zz', desc = 'GENERAL: Half page up (centered)' },

    -- Better indenting in visual mode
    { 'v', key = '<', cb = '<gv', desc = 'GENERAL: Indent left and reselect' },
    { 'v', key = '>', cb = '>gv', desc = 'GENERAL: Indent right and reselect' },

    -- Move lines up/down
    { 'n', key = '<C-j>', cb = [[:m .+1<CR>==]], desc = 'GENERAL: Move line down' },
    { 'n', key = '<C-k>', cb = [[:m .-2<CR>==]], desc = 'GENERAL: Move line up' },
    { 'v', key = '<C-j>', cb = [[:m '>+1<CR>gv=gv]], desc = 'GENERAL: Move selection down' },
    { 'v', key = '<C-k>', cb = [[:m '<-2<CR>gv=gv]], desc = 'GENERAL: Move selection up' },

    -- Windowing
    { 'n', key = '<C-h>', cb = '<C-w><C-h>', desc = 'WINDOW: Move focus to the left' },
    { 'n', key = '<C-l>', cb = '<C-w><C-l>', desc = 'WINDOW: Move focus to the right' },
    { 'n', key = '<C-j>', cb = '<C-w><C-j>', desc = 'WINDOW: Move focus to the lower' },
    { 'n', key = '<C-k>', cb = '<C-w><C-k>', desc = 'WINDOW: Move focus to the upper' },
    { 'n', key = '<leader>sv', cb = ':vsplit<CR>', desc = 'WINDOW: Split vertically' },
    { 'n', key = '<leader>sh', cb = ':split<CR>', desc = 'WINDOW: Split horizontally' },
    { 'n', key = '<C-Up>', cb = ':resize +2<CR>', desc = 'WINDOW: Increase height' },
    { 'n', key = '<C-Down>', cb = ':resize -2<CR>', desc = 'WINDOW: Decrease height' },
    { 'n', key = '<C-Left>', cb = ':vertical resize -2<CR>', desc = 'WINDOW: Decrease width' },
    { 'n', key = '<C-Right>', cb = ':vertical resize +2<CR>', desc = 'WINDOW: Increase width' },

    -- Buffers
    { 'n', key = '<M-j>', cb = ':bnext<CR>', desc = 'BUFFER: binding for togle to next tab' },
    { 'n', key = '<M-k>', cb = ':bprev<CR>', desc = 'BUFFER: binding for togle to previous tab' },
    { 'n', key = '<M-b>', cb = ':bd<CR>', desc = 'BUFFER: delete force' },
    { 'n', key = '<M-B>', cb = ':bd!<CR>', desc = 'BUFFER: delete force' },

    { 'n', key = '<M-s>', cb = [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left><Left>]], desc = 'GENERAL: Rename under cursor' },
    { { 'n', 'v' }, key = '<M-S>', cb = [[:%s///gIc<Left><Left><Left><Left><Left>]], desc = 'GENERAL: Enter search and rename' },

    {
      'n',
      key = '<leader>pa',
      cb = function()
        local path = vim.fn.expand('%:p')
        vim.fn.setreg('+', path)
        print('file:', path)
      end,
      desc = 'GENERAL: Copy current buffer full path',
    },

    -- Key mappings
    { 'n', key = '<leader>tt', cb = vim.g.float_terminal.toggle, desc = 'TERMINAL: Toggle floating terminal', opts = { silent = true } },
    { 't', key = '<Esc>', cb = vim.g.float_terminal.close, desc = 'TERMINAL: Close floating terminal', opts = { silent = true } },
    -- Alternative navigation (more intuitive)
    { 'n', key = '<leader>tn', cb = ':tabnew<CR>', desc = 'TAB: New tab' },
    { 'n', key = '<leader>tx', cb = ':tabclose<CR>', desc = 'TAB: Close tab' },
    -- Tab moving
    { 'n', key = '<leader>tm', cb = ':tabmove<CR>', desc = 'TAB: Move tab' },
    { 'n', key = '<leader>t>', cb = ':tabmove +1<CR>', desc = 'TAB: Move tab right' },
    { 'n', key = '<leader>t<', cb = ':tabmove -1<CR>', desc = 'TAB: Move tab left' },
    { 'n', key = '<leader>tO', cb = open_file_newtab, desc = 'TAB: Open file in new tab' },
    { 'n', key = '<leader>td', cb = duplicate_curtab, desc = 'TAB: Duplicate current tab' },
    { 'n', key = '<leader>tr', cb = close_tab_right, desc = 'TAB: Close tabs to the right' },
    { 'n', key = '<leader>tL', cb = close_tab_left, desc = 'TAB: Close tabs to the left' },
    { 'n', key = '<leader>tc', cb = smart_close_tab, desc = 'TAB: Smart close buffer/tab' },
  })

  if vim.g.neovide then
    local add_neovide_scale_factor = function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.05 end
    local sub_neovide_scale_factor = function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.05 end
    local reset_neovide_scale_factor = function() vim.g.neovide_scale_factor = 1 end

    set_keymaps({
      { { 'n', 'v' }, key = '<C-=>', cb = add_neovide_scale_factor, desc = '[NEOVIDE] Zoom in' },
      { { 'n', 'v' }, key = '<C-->', cb = sub_neovide_scale_factor, desc = '[NEOVIDE] Zoom out' },
      { { 'n', 'v' }, key = '<C-0>', cb = reset_neovide_scale_factor, desc = '[NEOVIDE] Zoom reset' },
    })
  end
end

local augroup = vim.api.nvim_create_augroup('rizalachp-augroup', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  group = augroup,
  callback = function() vim.highlight.on_yank() end,
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup,
  pattern = '*',
  callback = function()
    vim.cmd([[normal zR]])
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})

-- Auto-close terminal when process exits
vim.api.nvim_create_autocmd('TermClose', {
  group = augroup,
  callback = function()
    if vim.v.event.status == 0 then vim.api.nvim_buf_delete(0, {}) end
  end,
})

-- Disable line numbers in terminal
vim.api.nvim_create_autocmd('TermOpen', {
  group = augroup,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'
  end,
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd('VimResized', {
  group = augroup,
  callback = function() vim.cmd('tabdo wincmd =') end,
})

-- Create directories when saving files
vim.api.nvim_create_autocmd('BufWritePre', {
  group = augroup,
  callback = function()
    local dir = vim.fn.expand('<afile>:p:h')
    if vim.fn.isdirectory(dir) == 0 then vim.fn.mkdir(dir, 'p') end
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*.c', '*.h' },
  group = augroup,
  command = [[set filetype=c]],
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*.ino', '*.cpp', '*.hpp', '*.cc', '*.hh' },
  group = augroup,
  command = [[set filetype=cpp]],
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = { 'javascript', 'typescript', 'json', 'html', 'css' },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

require('rizalachp.plugins')
