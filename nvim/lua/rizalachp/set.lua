local v = vim

v.lsp.set_log_level("OFF")
v.opt.cursorline = true
v.opt.winblend = 0
v.opt.wildoptions = "pum"
v.opt.pumblend = 5
v.opt.background = "dark"

vim.cmd [[
    let s:guifontsize = 10
    let s:guifont = "JetBrainsMono\\ Nerd\\ Font"
]]

v.opt.termguicolors = true
v.opt.list = true

v.opt.undofile = true

v.opt.clipboard = v.opt.clipboard + "unnamedplus"
v.opt.wrap = false
v.opt.showmatch = true
v.opt.showmode = false
v.opt.cursorline = true
v.opt.number = true
v.opt.relativenumber = true

v.opt.grepprg = "rg --vimgrep --smart-case --follow"
v.opt.incsearch = true
v.opt.hlsearch = true

v.opt.ignorecase = true
v.opt.smartcase = true

v.opt.scrolloff = 6
v.opt.sidescrolloff = 6
v.opt.backspace = "indent,start,eol"
v.opt.mouse = 'a'
v.wo.signcolumn = 'yes'
v.g.netrw_keepdir = 0
v.o.breakindent = true
-- set.softtabstop = 4
v.opt.expandtab = true
v.opt.textwidth = 100
-- v.opt.showtabline = 4
v.opt.shiftwidth = 4
v.opt.tabstop = 4
v.opt.smarttab = true
v.opt.smartindent = true
v.opt.autoindent = true
v.opt.shiftround = true
v.opt.splitbelow = true
v.opt.splitright = true
v.opt.laststatus = 2
v.opt.colorcolumn = "120"
v.opt.autochdir = false
v.opt.hidden = true
v.opt.inccommand = "split"
v.opt.completeopt = "menuone,noselect,noinsert"
v.opt.shortmess = v.opt.shortmess + "c"
v.opt.lazyredraw = true

v.opt.foldmethod = 'marker'
v.opt.sessionoptions='blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

v.g.mapleader = ' '
v.g.maplocalleader = ' '

v.g.mkdp_browser = '/usr/bin/brave'
v.g.mkdp_echo_preview_url = 1

v.api.nvim_create_autocmd({ 'BufReadPost', 'FileReadPost' }, { pattern = '*', command = [[normal zR]] })
v.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    pattern = { '*.c', '*.h' },
    command = [[set filetype=c]]
})
vim.g.zig_fmt_autosave = 0
