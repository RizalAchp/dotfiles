RzPkg({
  'neovim/nvim-lspconfig',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  'mrjones2014/codesettings.nvim',
  -- GH 'folke/neoconf.nvim',
  'saecki/crates.nvim',
  {
    'mrcjkb/rustaceanvim',
    -- To avoid being surprised by breaking changes,
    -- I recommend you set a version range
    version = vim.version.range('^9'),
  },
})

local augroup = vim.api.nvim_create_augroup('rizalachp.plugins.lsp', { clear = true })

-- require 'neoconf'.setup({})
require('codesettings').setup({
  --- Look for these config files
  config_file_paths = { '.vscode/settings.json', 'codesettings.json', 'lspsettings.json' },
  --- Set filetype to jsonc when opening a file specified by `config_file_paths`,
  --- make sure you have the json tree-sitter parser installed for highlighting
  jsonc_filetype = true,
  --- Integrate with jsonls to provide LSP completion for LSP settings based on schemas
  jsonls_integration = true,
  --- Enable live reloading of settings when config files change
  --- via the `workspace/didChangeConfiguration` notification; after notifying,
  --- an autocmd `User CodesettingsFilesChanged` will be emitted. You
  --- can use this autocmd to handle edge cases like restarting servers
  --- that don't respond to `workspace/didChangeConfiguration` by
  --- restarting it.
  live_reload = false,
  --- List of loader extensions to use when loading settings; `string` values will be `require`d
  loader_extensions = { 'codesettings.extensions.vscode' },
  --- Set up library paths for `lua_ls` automatically to pick up the generated type
  --- annotations provided by codesettings.nvim; to enable for only your nvim config,
  --- you can also do something like:
  --- lua_ls_integration = function()
  ---   return vim.uv.cwd() == ('%s/.config/nvim'):format(vim.env.HOME)
  --- end,
  --- This integration also works for emmylua_ls
  lua_ls_integration = true,
  --- How to merge lists; 'append' (default), 'prepend' or 'replace'
  merge_lists = 'append',
  --- Controls placeholder string substitution in LSP schema descriptions.
  --- - true (default): use bundled English NLS files
  --- - false: disable substitution (raw placeholders visible)
  --- - string: path to a directory of per-LSP NLS JSON files (e.g. "/path/to/dir" containing jsonls.nls.json, lua_ls.nls.json, etc.)
  --- - table: flat `{ ["key"] = "value" }` NLS table applied to all LSPs
  --- - function(lsp_name) -> table: per-LSP resolver
  --- Note that only certain schemas support this, see the bundled *.nls.json files at
  --- ./after/codesettings-nls/*.nls.json
  nls = true,
  --- Provide your own root dir; can be a string or function returning a string.
  --- It should be/return the full absolute path to the root directory.
  --- If not set, defaults to `require('codesettings.util').get_root()`
  root_dir = nil,
})

local before_init_lsp_config = function(_, config)
  local codesettings = require('codesettings')
  codesettings.with_local_settings(config.name, config)
end

vim.lsp.config('*', { before_init = before_init_lsp_config })

vim.lsp.config('rust-analyzer', {
  before_init = function(init_params, config)
    local codesettings = require('codesettings')
    codesettings.with_local_settings(config.name, config)
    -- Some settings must be passed at init time, for example rust-analyzer.workspace.discoverConfig
    if config.default_settings and config.default_settings[config.name] then init_params.initializationOptions = config.default_settings[config.name] end
  end,
})

---@type table<string, vim.lsp.Config>
local servers = {
  clangd = { before_init = before_init_lsp_config },
  stylua = { before_init = before_init_lsp_config }, -- Used to format Lua code

  -- Special Lua Config, as recommended by neovim help docs
  lua_ls = {
    before_init = before_init_lsp_config,
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath('config') and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
      end

      ---@diagnostic disable-next-line: param-type-mismatch
      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          version = 'LuaJIT',
          path = { 'lua/?.lua', 'lua/?/init.lua' },
        },
        workspace = {
          checkThirdParty = false,
          -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
          --  See https://github.com/neovim/nvim-lspconfig/issues/3189
          library = vim.tbl_extend(
            'force',
            vim.tbl_filter(function(d) return not d:match(vim.fn.stdpath('config') .. '/?a?f?t?e?r?') end, vim.api.nvim_get_runtime_file('', true)),
            {
              '${3rd}/luv/library',
              '${3rd}/busted/library',
            }
          ),
        },
      })
    end,
    ---@type lspconfig.settings.lua_ls
    settings = {
      Lua = {
        codeLens = { enable = false },
        format = { enable = false }, -- Disable formatting (formatting is done by stylua)
        hint = { enable = false },
      },
    },
  },
}
require('mason').setup()
local ensure_installed = vim.tbl_keys(servers or {})
-- vim.list_extend(ensure_installed, {
--     -- You can add other tools here that you want Mason to install
-- })
require('mason-tool-installer').setup({ ensure_installed = ensure_installed })
for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  -- vim.lsp.enable(name)
end
require('mason-lspconfig').setup()

-- require('mason-lspconfig').setup({
--     ensure_installed = {},
--     automatic_installation = false,
--     handlers = {
--         ---@type fun(server_name: string)
--         function(server_name)
--             local server = servers[server_name] or {}
--             -- This handles overriding only values explicitly passed
--             -- by the server configuration above. Useful when disabling
--             -- certain features of an LSP (for example, turning off formatting for tsserver)
--             server.capabilities = vim.tbl_deep_extend('force', capabilities, server.capabilities or {})
--             -- server.on_attach = on_attach_lsp
--             require('lspconfig')[server_name].setup(server)
--         end,
--     },
-- })

---@type fun(client?: vim.lsp.Client, buf: integer, extended_keymap: nil|Keymap[])
local function on_attach_lsp(client, buf, extended_keymap)
  local opts = { buffer = buf, remap = false }
  ---@type Keymap[]
  local keymaps = vim.list_extend(extended_keymap or {}, {
    {
      'n',
      key = 'K',
      cb = vim.lsp.buf.hover,
      desc = '[LSP]: Hover Documentation',
      opts = opts,
    },
    {
      'n',
      key = '<leader>K',
      cb = vim.lsp.buf.signature_help,
      desc = '[LSP]: [S]ignature [D]ocumentation',
      opts = opts,
    },
    {
      'n',
      key = '<leader>rn',
      cb = vim.lsp.buf.rename,
      desc = '[LSP]: [R]e[n]ame',
      opts = opts,
    },
    {
      'n',
      key = '<F2>',
      cb = vim.lsp.buf.rename,
      desc = '[LSP]: [R]e[n]ame',
      opts = opts,
    },
    {
      'n',
      key = 'gd',
      cb = vim.lsp.buf.definition,
      desc = '[LSP]: [G]oto [D]efinition',
      opts = opts,
    },
    {
      'n',
      key = 'gi',
      cb = vim.lsp.buf.implementation,
      desc = '[LSP]: [G]oto [I]mplementation',
      opts = opts,
    },
    {
      'n',
      key = 'gf',
      cb = vim.lsp.buf.format,
      desc = '[LSP]: [G]o [F]ormat Documents',
      opts = opts,
    },
    {
      'n',
      key = 'gc',
      cb = vim.lsp.buf.declaration,
      desc = '[LSP]: [G]oto [D]eclaration',
      opts = opts,
    },
    {
      'n',
      key = 'g,',
      cb = function() vim.diagnostic.jump({ count = 1 }) end,
      desc = '[LSP]: [G]oto Prev Diagnostic',
      opts = opts,
    },
    {
      'n',
      key = 'g.',
      cb = function() vim.diagnostic.jump({ count = 1 }) end,
      desc = '[LSP]: [G]oto Next Diagnostic',
      opts = opts,
    },
    {
      'n',
      key = '<leader>dh',
      cb = vim.diagnostic.hide,
      desc = '[LSP]: [D]iagnostic [H]ide',
      opts = opts,
    },
    {
      'n',
      key = '<leader>ds',
      cb = vim.diagnostic.show,
      desc = '[LSP]: [D]iagnostic [S]how',
      opts = opts,
    },
    {
      'n',
      key = '<leader>ca',
      cb = vim.lsp.buf.code_action,
      desc = '[LSP]: [C]ode [A]ction',
      opts = opts,
    },
    {
      'n',
      key = '<leader>f',
      cb = function()
        if vim.lsp.buf.format then
          vim.lsp.buf.format({ bufnr = buf })
        elseif vim.lsp.buf.formatting then
          vim.lsp.buf.formatting()
        end
      end,
      desc = '[LSP]: [F]ormat Document',
      opts = opts,
    },
  })

  if client and client:supports_method('textDocument/documentHighlight', buf) then
    local highlight_augroup = vim.api.nvim_create_augroup('rizalachp.plugins.lsp.highlight', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('rizalachp.plugins.lsp.detach', { clear = true }),
      callback = function(event)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds({ group = 'rizalachp.plugins.lsp.highlight', buffer = event.buf })
      end,
    })
  end

  -- vim.api.nvim_buf_create_user_command(event.buf, client.name, 'LspExtra', {force})

  -- The following code creates a keymap to toggle inlay hints in your
  -- code, if the language server you are using supports them
  --
  -- This may be unwanted, since they displace some of your code
  if client and client:supports_method('textDocument/inlayHint', buf) then
    keymaps[#keymaps + 1] = {
      'n',
      key = '<leader>th',
      cb = function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf })) end,
      desc = 'LSP: [T]oggle Inlay [H]ints',
    }
  end
  set_keymaps(keymaps)
end

---@module 'rustaceanvim'
---@return rustaceanvim.Config
vim.g.rustaceanvim = function()
  return {
    server = {
      on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, remap = true }
        ---@type function
        ---@param cmd string|string[]
        ---@return function
        local f = function(cmd)
          return function() vim.cmd.RustLsp(cmd) end
        end
        on_attach_lsp(client, bufnr, {
          {
            'n',
            key = 'J',
            cb = f('joinLines'),
            desc = '[J]oin [L]ines',
            opts = opts,
          },
          {
            'n',
            key = '<leader>em',
            cb = f('expandMacro'),
            desc = '[E]xpand [M]acro',
            opts = opts,
          },
          {
            'n',
            key = '<leader>oc',
            cb = f('openCargo'),
            desc = '[O]pen [C]argo.toml',
            opts = opts,
          },
          {
            'n',
            key = '<leader>rpm',
            cb = f('rebuildProcMacros'),
            desc = '[R]ebuild [P]roc [M]acro',
            opts = opts,
          },
          {
            'n',
            key = '<leader>st',
            cb = f('syntaxTree'),
            desc = '[S]intax [T]ree',
            opts = opts,
          },
          {
            'n',
            key = '<leader>ca',
            cb = f('codeAction'),
            desc = '[C]ode [A]ction',
            opts = opts,
          },
          {
            'n',
            key = 'K',
            cb = f({ 'hover', 'actions' }),
            desc = 'Hover Action Documentation',
            opts = opts,
          },
          {
            { 'n', 'v' },
            key = 'K',
            cb = f({ 'hover', 'range' }),
            desc = 'Hover Range Documentation',
            opts = opts,
          },
          {
            'n',
            key = 'g,',
            cb = f({ 'renderDiagnostic', 'cycle' }),
            desc = '[G]oto Diagnostic (cycling)',
            opts = opts,
          },
          {
            'n',
            key = 'g.',
            cb = f({ 'renderDiagnostic', 'cycle' }),
            desc = '[G]oto Diagnostic (cycling)',
            opts = opts,
          },
          {
            'n',
            key = '<leader>rd',
            cb = f({ 'renderDiagnostic', 'current' }),
            desc = '[R]render current [D]diagnostic',
            opts = opts,
          },
          {
            'n',
            key = '<leader>ee',
            cb = f({ 'explainError', 'current' }),
            desc = '[E]xplain [E]rror',
            opts = opts,
          },
          {
            'n',
            key = '<F8>',
            cb = f({ 'flyCheck', 'run' }),
            desc = '[R]render current [D]diagnostic',
            opts = opts,
          },
        })
      end,

      default_settings = {
        ['rust-analyzer'] = {
          check = {
            command = 'clippy',
          },
          cargo = {
            allTargets = true,
            allFeatures = true,
            buildScripts = { enable = true },
          },
          procMacro = { enable = true },
          completion = { postfix = { enable = false } },
        },
      },
    },
  }
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup,
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    on_attach_lsp(client, event.buf)
  end,
})

vim.api.nvim_create_autocmd('BufRead', {
  group = augroup,
  pattern = 'Cargo.toml',
  callback = function()
    require('crates').setup({
      -- curl_args = { "-sL", "--retry", "5" },
      expand_crate_moves_cursor = true,
      completion = {
        cmp = {
          enabled = true,
        },
        crates = {
          enabled = true, -- disabled by default
          max_results = 10, -- The maximum number of search results to display
          min_chars = 3, -- The minimum number of charaters to type before completions begin appearing
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
          local crates = require('crates')
          on_attach_lsp(client, bufnr, {
            {
              'n',
              key = '<leader>ct',
              cb = crates.toggle,
              desc = '[CRATES]: Toggle UI elements',
              opts = { silent = true },
            },
            {
              'n',
              key = '<leader>cr',
              cb = crates.reload,
              desc = '[CRATES]: Reload data',
              opts = { silent = true },
            },
            {
              'n',
              key = '<leader>cv',
              cb = crates.show_versions_popup,
              desc = '[CRATES]: show version popup',
              opts = { silent = true },
            },
            {
              'n',
              key = '<leader>cf',
              cb = crates.show_features_popup,
              desc = '[CRATES]: show features popup',
              opts = { silent = true },
            },
            {
              'n',
              key = '<leader>cd',
              cb = crates.show_dependencies_popup,
              desc = '[CRATES]: show dependencies popup',
              opts = { silent = true },
            },
            {
              'n',
              key = '<leader>cu',
              cb = crates.update_crate,
              desc = '[CRATES]: update crate',
              opts = { silent = true },
            },
            {
              'v',
              key = '<leader>cu',
              cb = crates.update_crates,
              desc = '[CRATES]: update crates',
              opts = { silent = true },
            },
            {
              'n',
              key = '<leader>ca',
              cb = crates.update_all_crates,
              desc = '[CRATES]: update all crates',
              opts = { silent = true },
            },
            {
              'n',
              key = '<leader>cU',
              cb = crates.upgrade_crate,
              desc = '[CRATES]: upgrade crate',
              opts = { silent = true },
            },
            {
              'v',
              key = '<leader>cU',
              cb = crates.upgrade_crates,
              desc = '[CRATES]: upgrade crates',
              opts = { silent = true },
            },
            {
              'n',
              key = '<leader>cA',
              cb = crates.upgrade_all_crates,
              desc = '[CRATES]: upgrade all crates',
              opts = { silent = true },
            },
            {
              'n',
              key = '<leader>cx',
              cb = crates.expand_plain_crate_to_inline_table,
              desc = '[CRATES]: expand plain crate to inline table',
              opts = { silent = true },
            },
            {
              'n',
              key = '<leader>cX',
              cb = crates.extract_crate_into_table,
              desc = '[CRATES]: extract crate into table',
              opts = { silent = true },
            },
            {
              'n',
              key = '<leader>cH',
              cb = crates.open_homepage,
              desc = '[CRATES]: open homepage',
              opts = { silent = true },
            },
            {
              'n',
              key = '<leader>cR',
              cb = crates.open_repository,
              desc = '[CRATES]: open repository',
              opts = { silent = true },
            },
            {
              'n',
              key = '<leader>cD',
              cb = crates.open_documentation,
              desc = '[CRATES]: open documentation',
              opts = { silent = true },
            },
            {
              'n',
              key = '<leader>cC',
              cb = crates.open_crates_io,
              desc = '[CRATES]: open crates.io',
              opts = { silent = true },
            },
          })
        end,
      },
    })
    require('crates.completion.cmp').setup()
  end,
})
