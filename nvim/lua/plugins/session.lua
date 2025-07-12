---@module 'lazy'
---@type LazySpec
return {
    'rmagatti/auto-session',
    lazy = false,
    config = function()
        require("auto-session").setup {
            suppressed_dirs = { '~/Downloads/**', '~/Documents/', '/', '/run/media/rizal/Data/**' },
            auto_restore_last_session = vim.loop.cwd() == vim.loop.os_homedir(),
            auto_create = function()
                local cmd = 'git rev-parse --is-inside-work-tree'
                return vim.fn.system(cmd) == 'true\n'
            end,
            args_allow_files_auto_save = function()
                local supported = 0

                local buffers = vim.api.nvim_list_bufs()
                for _, buf in ipairs(buffers) do
                    -- Check if the buffer is valid and loaded
                    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
                        local path = vim.api.nvim_buf_get_name(buf)
                        if vim.fn.filereadable(path) ~= 0 then supported = supported + 1 end
                    end
                end

                -- If we have more 2 or more supported buffers, save the session
                return supported >= 2
            end,

            -- ⚠️ This will only work if Telescope.nvim is installed
            -- The following are already the default values, no need to provide them if these are already the settings you want.
            session_lens = {
                -- If load_on_setup is false, make sure you use `:SessionSearch` to open the picker as it will initialize everything first
                load_on_setup = true,
                previewer = true,
                mappings = {
                    -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
                    delete_session = { "i", "<C-D>" },
                    alternate_session = { "i", "<C-S>" },
                    copy_session = { "i", "<C-Y>" },
                },
                -- Can also set some Telescope picker options
                -- For all options, see: https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt#L112
                theme_conf = require('telescope.themes').get_ivy({
                    border = true,
                    layout_config = { height = 0.5 },
                })
            },
        }

        local key_map = function(mode, keys, func, desc)
            vim.keymap.set(mode, keys, func, { noremap = true, desc = desc })
        end
        -- :SessionSave " saves a session based on the `cwd` in `root_dir`
        -- :SessionSave my_session " saves a session called `my_session` in `root_dir`
        --
        -- :SessionRestore " restores a session based on the `cwd` from `root_dir`
        -- :SessionRestore my_session " restores `my_session` from `root_dir`
        --
        -- :SessionDelete " deletes a session based on the `cwd` from `root_dir`
        -- :SessionDelete my_session " deletes `my_sesion` from `root_dir`
        --
        -- :SessionDisableAutoSave " disables autosave
        -- :SessionDisableAutoSave! " enables autosave (still does all checks in the config)
        -- :SessionToggleAutoSave " toggles autosave
        --
        -- :SessionPurgeOrphaned " removes all orphaned sessions with no working directory left.
        key_map({ 'n', 'v' }, '<leader>es', '<CMD>SessionSearch<CR>', 'S[E]ssion [S]earch')
        key_map({ 'n', 'v' }, '<leader>eo', '<CMD>Autosession search<CR>', 'S[E]ssion Search and [O]pen')
        key_map({ 'n', 'v' }, '<leader>ed', '<CMD>Autosession delete<CR>', 'S[E]ssion Search and [O]pen')
    end,
}
