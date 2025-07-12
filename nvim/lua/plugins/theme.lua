---@module 'lazy'
---@type LazySpec
return {
    'aktersnurra/no-clown-fiesta.nvim',
    lazy = false,
    priority = 1000,
    cond = not vim.g.vscode,
    init = function()
        require("no-clown-fiesta").setup({
            styles = {
                comments = { italic = true },
                type = { bold = true },
                lsp = { underline = false },
                match_paren = { underline = true },
            },
        })
        -- Load the colorscheme here.
        -- Like many other themes, this one has different styles, and you could load
        -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
        vim.cmd.colorscheme 'no-clown-fiesta'
    end,
}
