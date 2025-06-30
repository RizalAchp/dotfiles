-- crates for cargo.toml plugins
return {
    'saecki/crates.nvim',
    cond = not vim.g.vscode,
    lazy = true,
    event = { "BufRead Cargo.toml" },
    tag = 'stable',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('crates').setup({
            -- curl_args = { "-sL", "--retry", "5" },
            expand_crate_moves_cursor = true,
            completion = {
                cmp = {
                    enabled = true,
                },
                crates = {
                    enabled = true,  -- disabled by default
                    max_results = 10, -- The maximum number of search results to display
                    min_chars = 3,   -- The minimum number of charaters to type before completions begin appearing
                },
            },
            popup = {
                autofocus = false,
            },
            lsp = {
                enabled = true,
                actions = true,
                completion = true,
                hover = true,
                on_attach = function(client, bufnr)
                    local crates = require("crates")
                    local map = function(mode, key, func, desc)
                        ---@type vim.keymap.set.Opts
                        local opts = { silent = true, desc = "CRATES: " .. desc, buffer = bufnr }
                        vim.keymap.set(mode, key, func, opts)
                    end
                    OnAttachLsp(client, bufnr)

                    map("n", "<leader>ct", crates.toggle, "Toggle UI elements")
                    map("n", "<leader>cr", crates.reload, "Reload data")

                    map("n", "<leader>cv", crates.show_versions_popup, "show version popup")
                    map("n", "<leader>cf", crates.show_features_popup, "show features popup")
                    map("n", "<leader>cd", crates.show_dependencies_popup, "show dependencies popup")

                    map("n", "<leader>cu", crates.update_crate, "update crate")
                    map("v", "<leader>cu", crates.update_crates, "update crates")
                    map("n", "<leader>ca", crates.update_all_crates, "update all crates")
                    map("n", "<leader>cU", crates.upgrade_crate, "upgrade crate")
                    map("v", "<leader>cU", crates.upgrade_crates, "upgrade crates")
                    map("n", "<leader>cA", crates.upgrade_all_crates, "upgrade all crates")

                    map("n", "<leader>cx", crates.expand_plain_crate_to_inline_table,
                        "expand plain crate to inline table")
                    map("n", "<leader>cX", crates.extract_crate_into_table, "extract crate into table")

                    map("n", "<leader>cH", crates.open_homepage, "open homepage")
                    map("n", "<leader>cR", crates.open_repository, "open repository")
                    map("n", "<leader>cD", crates.open_documentation, "open documentation")
                    map("n", "<leader>cC", crates.open_crates_io, "open crates.io")
                end,
            }
        })
        require("crates.completion.cmp").setup()
    end,
}
