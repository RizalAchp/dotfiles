require("rizalachp.set")
require("rizalachp.globals")


-- set all keymaps
local keymap = require("rizalachp.keymap")
for _, km in ipairs(keymap) do
    local opts = { noremap = true, desc = km.desc }
    if km.opts then
        opts = vim.tbl_deep_extend('force', opts, km.opts)
    end
    vim.keymap.set(km[1], km.key, km.cb, opts)
end

local augroup = vim.api.nvim_create_augroup('rizalachp.augrup', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    group = augroup,
    callback = function() vim.highlight.on_yank() end,
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    pattern = '*',
    callback = function()
        vim.cmd([[normal zR]])
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})


vim.api.nvim_create_autocmd('LspAttach', {
    group = augroup,
    callback = function(event) OnAttachLsp(event.data, event.buf) end
})

-- Auto-close terminal when process exits
vim.api.nvim_create_autocmd("TermClose", {
    group = augroup,
    callback = function()
        if vim.v.event.status == 0 then
            vim.api.nvim_buf_delete(0, {})
        end
    end,
})

-- Disable line numbers in terminal
vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup,
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
    end,
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
    group = augroup,
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

-- Create directories when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    callback = function()
        local dir = vim.fn.expand('<afile>:p:h')
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, 'p')
        end
    end,
})


vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    pattern = { '*.c', '*.h' },
    group = augroup,
    command = [[set filetype=c]]
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    pattern = { '*.ino' },
    group = augroup,
    command = [[set filetype=cpp]]
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = { "javascript", "typescript", "json", "html", "css" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
    end,
})
