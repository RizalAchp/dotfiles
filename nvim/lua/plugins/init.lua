local M = {}
function M.init()
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.uv.fs_stat(lazypath) then
        vim.fn.system({
            "git", "clone", "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)

    ---@param a LazySpec[]
    ---@param b LazySpec[]
    ---@return LazySpec[]
    local tbl_merge = function(a, b)
        local len = #a
        for n, v in pairs(b) do
            table.insert(a, len + n, v)
        end
        return a
    end
    require('lazy').setup(tbl_merge({
        -- theme plugins
        require 'plugins.theme',
        -- telescope plugins
        require 'plugins.telescope',
        -- auto-session plugins for managing sessions
        -- require 'plugins.session',
        -- treesitter plugins
        require 'plugins.treesitter',
        -- Autocompletion
        require 'plugins.cmp',
        -- LSP Configuration & Plugins
        require 'plugins.lsp',
        -- Rust tools
        require 'plugins.rust',
        -- Line
        require 'plugins.line',

        require 'plugins.which-key',

        require 'plugins.indent',
        require 'plugins.git',
        require 'plugins.comment',
        require 'plugins.crates',
        require 'plugins.trouble',
    }, require 'plugins.other'))
end

return M
