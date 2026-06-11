RzPkg({
  'nvim-telescope/telescope.nvim',
  'nvim-telescope/telescope-file-browser.nvim',
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
})

local builtin = require('telescope.builtin')
local theme = require('telescope.themes').get_ivy({
  layout_config = { height = 0.5 },
})

require('telescope').setup({
  pickers = {
    oldfiles = theme,
    find_files = theme,
    help_tags = theme,
    grep_strins = theme,
    live_gres = theme,
    man_pages = theme,
    registers = theme,
    builtis = theme,
    git_files = theme,
    resums = theme,
    buffers = vim.tbl_deep_extend('force', {}, theme, {
      ignore_current_buffer = true,
      sort_mru = true,
      initial_mode = 'normal',
    }),
    current_buffer_fuzzy_find = theme,
    lsp_references = theme,
    lsp_type_definitions = theme,
    diagnostics = theme,
    lsp_document_symbols = theme,
    lsp_dynamic_workspace_symbols = theme,
  },
  extensions = {
    ---@type telescope-file-browser.SetupOpts
    ---@diagnostic disable-next-line: missing-fields
    file_browser = vim.tbl_deep_extend('force', require('telescope.themes').get_ivy({ layout_config = { height = 0.8 } }), {
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      grouped = true,
      initial_mode = 'normal',
      hidden = true,
      no_ignore = true,
      file_ignore_patterns = { '.git$' },
      path = '%:p:h',
      mappings = {
        ['n'] = {
          -- your custom normal mode mappings
          ['a'] = require('telescope._extensions.file_browser.actions').create,
          ['c'] = require('telescope._extensions.file_browser.actions').copy,
          ['/'] = function() vim.cmd('startinsert') end,
        },
      },
    }),
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  },
})

-- Enable Telescope extensions if they are installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'file_browser')

local mode = { 'n', 'v' }

-- See `:help telescope.builtin`
set_keymaps({
  {
    mode,
    key = '<leader>?',
    cb = builtin.oldfiles,
    desc = '[Telescope]: [?] Find recently opened files',
  },
  {
    mode,
    key = '<leader>sf',
    cb = builtin.find_files,
    desc = '[Telescope]: [S]earch [F]iles',
  },
  {
    mode,
    key = '<leader>sh',
    cb = builtin.help_tags,
    desc = '[Telescope]: [S]earch [H]elp',
  },
  {
    mode,
    key = '<leader>ss',
    cb = builtin.grep_string,
    desc = '[Telescope]: [S]earch current [W]ord',
  },
  {
    mode,
    key = '<leader>sg',
    cb = builtin.live_grep,
    desc = '[Telescope]: [S]earch by [G]rep',
  },
  {
    mode,
    key = '<leader>sm',
    cb = builtin.man_pages,
    desc = '[Telescope]: [S]earch [M]an Pages',
  },
  {
    mode,
    key = '<leader>sp',
    cb = builtin.registers,
    desc = '[Telescope]: [S]earch [P]aste (Clipboard Register)',
  },
  {
    mode,
    key = '<leader>st',
    cb = builtin.builtin,
    desc = '[Telescope]: [S]earch [T]elescope builtins',
  },
  {
    mode,
    key = '<leader>gf',
    cb = builtin.git_files,
    desc = '[Telescope]: [G]it [F]iles',
  },
  {
    mode,
    key = ';;',
    cb = builtin.resume,
    desc = '[Telescope]: [;][;] resume',
  },
  {
    mode,
    key = '<leader><space>',
    cb = builtin.buffers,
    desc = '[Telescope]: [ ] Find existing buffers',
  },
  {
    mode,
    key = '<leader>/',
    cb = builtin.current_buffer_fuzzy_find,
    desc = '[Telescope]: [/] Fuzzily search in current buffer]',
  },
  {
    mode,
    key = 'gr',
    cb = builtin.lsp_references,
    desc = '[Telescope]: [G]oto [R]eferences',
  },
  {
    mode,
    key = '<leader>td',
    cb = builtin.lsp_type_definitions,
    desc = '[Telescope]: [T]ype [D]efinition',
  },
  {
    mode,
    key = '<leader>df',
    cb = builtin.diagnostics,
    desc = '[Telescope]: [D]iagnostic [O]pen float',
  },
  {
    mode,
    key = '<leader>ds',
    cb = builtin.lsp_document_symbols,
    desc = '[Telescope]: [D]ocument [S]ymbols',
  },
  {
    mode,
    key = '<leader>ws',
    cb = builtin.lsp_dynamic_workspace_symbols,
    desc = '[Telescope]: [W]orkspace [S]ymbols',
  },
  {
    mode,
    key = '<leader>n',
    cb = require('telescope').extensions.file_browser.file_browser,
    desc = '[Telescope]: Open File Browser',
  },
})
