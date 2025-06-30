---@module 'lazy'
---@type LazySpec
return {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    cond = not vim.g.vscode,
    dependencies = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-telescope/telescope-file-browser.nvim' },
        { -- If encountering errors, see telescope-fzf-native README for installation instructions
            'nvim-telescope/telescope-fzf-native.nvim',

            -- `build` is used to run some command when the plugin is installed/updated.
            -- This is only run then, not every time Neovim starts up.
            build = 'make',

            -- `cond` is a condition used to determine whether this plugin should be
            -- installed and loaded.
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    lazy = true,
    cmd = "Telescope",
    config = function()
        local telescope = require('telescope')
        local fb_action = require('telescope._extensions.file_browser.actions')
        telescope.setup({
            extensions = {
                ---@type telescope-file-browser.SetupOpts
                file_browser = {
                    -- disables netrw and use telescope-file-browser in its place
                    hijack_netrw = true,
                    grouped = true,
                    initial_mode = 'normal',
                    hidden = true,
                    no_ignore = true,
                    file_ignore_patterns = { ".git$" },
                    previewer = nil,
                    mappings = {
                        ['n'] = {
                            -- your custom normal mode mappings
                            ['a'] = fb_action.create,
                            ['c'] = fb_action.copy,
                            ['/'] = function()
                                vim.cmd('startinsert')
                            end,
                        },
                    },
                },
            },
        })
        -- Enable Telescope extensions if they are installed
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')
        telescope.load_extension('file_browser')

        local theme = require('telescope.themes').get_ivy({
            layout_config = { height = 0.5 },
        })
        local map = function(key, func, desc)
            vim.keymap.set({ 'n', 'v' }, key, func, { desc = desc, silent = true, noremap = true })
        end

        local builtin = require('telescope.builtin')
        -- See `:help telescope.builtin`
        map('<leader>?', function() builtin.oldfiles(theme) end, '[?] Find recently opened files')
        map('<leader>sf', function() builtin.find_files(theme) end, '[S]earch [F]iles')
        map('<leader>sh', function() builtin.help_tags(theme) end, '[S]earch [H]elp')
        map('<leader>ss', function() builtin.grep_string(theme) end, '[S]earch current [W]ord')
        map('<leader>sg', function() builtin.live_grep(theme) end, '[S]earch by [G]rep')
        map('<leader>sd', function() builtin.diagnostics(theme) end, '[S]earch [D]iagnostics')
        map('<leader>sm', function() builtin.man_pages(theme) end, '[S]earch [M]an Pages')
        map('<leader>sp', function() builtin.registers(theme) end, '[S]earch [P]aste (Clipboard Register)')
        map('<leader>st', function() builtin.builtin(theme) end, '[S]earch [T]elescope builtins')
        map('<leader>gf', function() builtin.git_files(theme) end, '[G]it [F]iles')
        map(';;', function() builtin.resume(theme) end, '[;][;] resume')

        map('<leader><space>', function()
            builtin.buffers(vim.tbl_deep_extend('force', {}, theme, {
                ignore_current_buffer = true,
                sort_mru = true,
                initial_mode = 'normal',
            }))
        end, '[ ] Find existing buffers')

        map('<leader>/', function() builtin.current_buffer_fuzzy_find(theme) end, '[/] Fuzzily search in current buffer]')

        map('<leader>n', function()
            telescope.extensions.file_browser.file_browser(
                vim.tbl_extend('force', {
                    path = vim.fn.expand('%:p:h'),
                }, theme)
            )
        end)
    end
}
