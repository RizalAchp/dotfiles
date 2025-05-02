---@type LazySpec
return {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    ft = 'rust',
    dependencies = {
        "nvim-lua/plenary.nvim",
        "mfussenegger/nvim-dap",
        "lvimuser/lsp-inlayhints.nvim",
    },
    lazy = false, -- This plugin is already lazy
    config = function()
        ---@type fun():rustaceanvim.Opts
        vim.g.rustaceanvim = function()
            return {
                ---@type rustaceanvim.tools.Opts
                tools = {
                    executor = 'termopen',
                    test_executor = 'termopen',
                },
                ---@type rustaceanvim.lsp.ClientOpts
                server = {
                    -- cmd = { 'rustup', 'run', 'rust-analyzer' },
                    standalone = false,
                    on_attach = function(c, bufnr)
                        OnAttachLsp(c, bufnr)

                        ---@param keys string
                        ---@param cmd any
                        ---@param desc string|nil
                        ---@param mode string|table|nil
                        local map = function(keys, cmd, desc, mode)
                            ---@type vim.keymap.set.Opts
                            local opt = { buffer = bufnr, noremap = true, desc = 'RUSTLSP: ' .. desc }

                            if type(cmd) == "function" then
                                vim.keymap.set(mode or 'n', keys, cmd, opt)
                            else
                                vim.keymap.set(mode or 'n', keys, function() vim.cmd.RustLsp(cmd) end, opt)
                            end
                        end

                        map('J', 'joinLines', '[J]oin [L]ines')

                        map('<leader>em', 'expandMacro', '[E]xpand [M]acro')
                        map('<leader>tt', 'testables', '[R]un [T]ests')
                        map('<leader>oc', 'openCargo', '[O]pen [C]argo.toml')
                        map('<leader>rpm', 'rebuildProcMacros', '[R]ebuild [P]roc [M]acro')
                        map('<leader>st', 'syntaxTree', '[S]intax [T]ree')
                        map('<leader>ca', 'codeAction', '[C]ode [A]ction')

                        -- map('K', vim.lsp.buf.hover, 'Hover Documentation')
                        map('K', { 'hover', 'actions' }, 'Hover Action Documentation', 'n')
                        map('K', { 'hover', 'range' }, 'Hover Range Documentation', 'v')
                        -- map('g,', vim.diagnostic.goto_prev, '[G]oto Prev Diagnostic')
                        map('g,', { 'renderDiagnostic', 'cycle' }, '[G]oto Diagnostic (cycling)')
                        map('g.', { 'renderDiagnostic', 'cycle' }, '[G]oto Diagnostic (cycling)')
                        map('<leader>rd', { 'renderDiagnostic', 'current' }, '[R]render current [D]diagnostic')
                        map('<leader>ee', { 'explainError', 'current' }, '[E]xplain [E]rror')
                        -- map('<F12>r', { 'flyCheck', 'run' }, "[R]render current [D]diagnostic ")
                    end,
                    default_settings = {
                        ['rust-analyzer'] = {
                            cargo = {
                                allTargets = true,
                                allFeatures = true,
                                buildScripts = { enable = true }
                            },
                            procMacro = { enable = true },
                            completion = { postfix = { enable = false } }
                        },
                    },
                }
            }
        end
    end
}
