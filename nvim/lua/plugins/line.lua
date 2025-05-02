---@type LazySpec
return {
    'nvim-lualine/lualine.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons", opts = {} },
    opts = {
        options = {
            theme = vim.g.colors_name or "auto",
            -- disabled_filetypes = { "dashboard", "NvimTree", "packer" },
            always_divide_middle = true,
            icons_enabled = true,
            section_separators = { left = "", right = "" },
            component_separators = { left = "", right = "" },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", { "diagnostics", sources = { "nvim_diagnostic" } } },
            -- lualine_c = { { "filename", file_status = true } },
            lualine_c = {
                function()
                    return require('auto-session.lib').current_session_name(true)
                end,
                { "filename", file_status = true }
            },
            lualine_x = {
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                    symbols = { error = " ", warn = " ", info = " ", hint = " " },
                },
                "encoding",
                "filetype",
            },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { { "filename", file_status = true, path = 1 } },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {},
        -- extensions = { "fugitive" },
    },
    init = function()
    end,
}
