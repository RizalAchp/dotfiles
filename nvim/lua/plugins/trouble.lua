return {
    'folke/trouble.nvim',
    opts = {
        fold_open = "v",
        fold_closed = ">",
        indent_lines = true,
        use_diagnostic_signs = "true",
    },
    cond = not vim.g.vscode,
    lazy = true,
    keys = {
        {
            "<leader>xx",
            "<cmd>Trouble diagnostics toggle focus=true<cr>",
            desc = "TROUBLE: Diagnostics (Trouble)",
        },
        {
            "<leader>xX",
            "<cmd>Trouble diagnostics toggle focus=true filter.buf=0<cr>",
            desc = "TROUBLE: Buffer Diagnostics (Trouble)",
        },
        {
            "<leader>cs",
            "<cmd>Trouble symbols toggle focus=true<cr>",
            desc = "TROUBLE: Symbols (Trouble)",
        },
        {
            "<leader>cl",
            "<cmd>Trouble lsp toggle focus=true win.position=right<cr>",
            desc = "TROUBLE: LSP Definitions / references / ... (Trouble)",
        },
        {
            "<leader>xL",
            "<cmd>Trouble loclist toggle<cr>",
            desc = "TROUBLE: Location List (Trouble)",
        },
        {
            "<leader>xQ",
            "<cmd>Trouble qflist toggle focus=true<cr>",
            desc = "TROUBLE: Quickfix List (Trouble)",
        },
    },
}
