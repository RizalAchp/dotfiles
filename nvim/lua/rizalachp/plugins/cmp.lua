-- [[ Snippet Engine ]]
RzPkg({
  {
    'L3MON4D3/LuaSnip',
    version = vim.version.range('2.*'),
    enabled = vim.fn.has('win32') ~= 1,
    build = { 'make', 'install_jsregexp' },
  },

  'saghen/blink.lib',
  'saghen/blink.cmp',
  'rafamadriz/friendly-snippets',
  'disrupted/blink-cmp-conventional-commits',
})

do
  require('luasnip').setup({})
  require('luasnip.loaders.from_vscode').lazy_load()
  require('luasnip.loaders.from_snipmate').lazy_load()
  require('luasnip.loaders.from_lua').lazy_load()
end

require('blink.cmp').build():pwait()
require('blink.cmp').setup({
  -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
  -- 'super-tab' for mappings similar to vscode (tab to accept)
  -- 'enter' for enter to accept
  -- 'none' for no mappings
  --
  -- default presets have the following mappings:
  -- ['<C-space>']    = { 'show', 'show_documentation', 'hide_documentation' },
  -- ['<C-e>']        = { 'hide', 'fallback' },
  -- ['<C-y>']        = { 'select_and_accept', 'fallback' },
  -- ['<Up>']         = { 'select_prev', 'fallback' },
  -- ['<Down>']       = { 'select_next', 'fallback' },
  -- ['<C-p>']        = { 'select_prev', 'fallback_to_mappings' },
  -- ['<C-n>']        = { 'select_next', 'fallback_to_mappings' },
  -- ['<C-b>']        = { 'scroll_documentation_up', 'fallback' },
  -- ['<C-f>']        = { 'scroll_documentation_down', 'fallback' },
  -- ['<Tab>']        = { 'snippet_forward', 'fallback' },
  -- ['<S-Tab>']      = { 'snippet_backward', 'fallback' },
  -- ['<C-k>']        = { 'show_signature', 'hide_signature', 'fallback' },
  --
  -- See :h blink-cmp-config-keymap for defining your own keymap
  keymap = {
    preset = 'default',
    ['<CR>'] = { 'select_and_accept', 'fallback' },
  },

  -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
  -- Adjusts spacing to ensure icons are aligned
  appearance = { nerd_font_variant = 'mono' },

  term = { enabled = true },
  ---@type blink.cmp.CmdlineConfigPartial
  cmdline = {
    enabled = true,
    -- sources = function()
    --   local type = vim.fn.getcmdtype()
    --   -- Search forward and backward
    --   if type == '/' or type == '?' then return { 'buffer' } end
    --   -- Commands
    --   if type == ':' or type == '@' then return { 'cmdline', 'buffer' } end
    --   return {}
    -- end,
  },

  completion = {
    -- By default, you may press `<c-space>` to show the documentation.
    -- Optionally, set `auto_show = true` to show the documentation after a delay.
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
  },

  snippets = {
    preset = 'luasnip',
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer', 'conventional_commits' },
    providers = {
      conventional_commits = {
        name = 'Conventional Commits',
        module = 'blink-cmp-conventional-commits',
        enabled = function() return vim.bo.filetype == 'gitcommit' end,
        -- ---@module 'blink-cmp-conventional-commits'
        -- ---@type blink-cmp-conventional-commits.Options
        -- opts = {
        --   -- See Configuration section below for available options
        -- },
      },
      snippets = {
        opts = {
          friendly_snippets = true,
          extended_filetypes = {
            markdown = { 'jekyll' },
            typescript = { 'tsdoc' },
            javascript = { 'jsdoc' },
            lua = { 'luadoc' },
            python = { 'pydoc' },
            rust = { 'rustdoc' },
            cs = { 'csharpdoc' },
            java = { 'javadoc' },
            c = { 'cdoc' },
            cpp = { 'cppdoc' },
            php = { 'phpdoc' },
            kotlin = { 'kdoc' },
            ruby = { 'rdoc' },
            sh = { 'shelldoc' },
          },
        },
      },
    },
  },

  -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
  -- which automatically downloads a prebuilt binary when enabled.
  --
  -- By default, we use the Lua implementation instead, but you may enable
  -- the rust implementation via `'prefer_rust_with_warning'`
  --
  -- See `:help blink-cmp-config-fuzzy` for more information
  fuzzy = {
    implementation = 'rust',
  },

  -- Shows a signature help window while you type arguments for a function
  signature = { enabled = true },
})
