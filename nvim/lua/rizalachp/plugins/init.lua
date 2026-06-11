---@class RzPkgSpec
--- Version to use for install and updates. Can be:
--- - `nil` (no value, default) to use repository's default branch (usually `main` or `master`).
--- - String to use specific branch, tag, or commit hash.
--- - Output of |vim.version.range()| to install the greatest/last semver tag
---   inside the version constraint.
---@field [1] string
---@field build? string[]|string|fun(name: string):string[]
---@field enabled? boolean|(fun():boolean)
---@field cmd? string|table
---@field version? string|vim.VersionRange

---@class RzPkgEvents
---@field build? string[]
---@field cmd? string|table

---@type table<string, RzPkgEvents>
local on_install_update_pkgs = {}

---@param cmd string[]|string|fun(name: string):string[]
---@param name string
---@return string[]
local norm_cmd = function(cmd, name)
  if type(cmd) == 'function' then
    return cmd(name)
  elseif type(cmd) == 'string' then
    return { cmd }
  else
    return cmd
  end
end

---@param spec RzPkgSpec
---@return vim.pack.Spec|nil
local rzpkgspec_to_pack_spec = function(spec)
  ---@type string[]|nil
  local name_splitted = vim.split(spec[1], '/', { plain = true })
  assert(name_splitted and #name_splitted == 2, 'name of package should be <author_pkg>/<pkg_name>')
  local _, pkgname = name_splitted[1], name_splitted[2]

  if spec.cmd ~= nil then on_install_update_pkgs[pkgname] = { cmd = spec.cmd } end
  if spec.build ~= nil then
    local build_cmd = norm_cmd(spec.build, spec[1])
    local enabled = spec.enabled or true
    -- if opt.enabled not provided. its mena enabled
    if vim.fn.executable(build_cmd[1]) == 1 and (enabled == true or (type(enabled) == 'function' and enabled())) then
      on_install_update_pkgs[pkgname] = vim.tbl_extend('force', on_install_update_pkgs[pkgname] or {}, { build = build_cmd })
    else
      return nil
    end
  end

  return { src = 'https://github.com/' .. spec[1], version = spec.version, name = pkgname }
end

---function extension for [vim.pkg.add] to add filter pkg that needed build, disabled, etc
---@param specs (string|RzPkgSpec)[] name or full spec of package to add
function RzPkg(specs)
  ---@type vim.pack.Spec[]
  local pack_specs = {}
  for _, spec in ipairs(specs) do
    local pack_spec = nil
    if type(spec) == 'string' then
      pack_spec = rzpkgspec_to_pack_spec({ spec })
    else
      pack_spec = rzpkgspec_to_pack_spec(spec)
    end
    if pack_spec ~= nil then pack_specs[#pack_specs + 1] = pack_spec end
  end
  if #pack_specs ~= 0 then vim.pack.add(pack_specs) end
end

local function run_build(name, cmd, cwd)
  local result = vim.system(cmd, { cwd = cwd }):wait()
  if result.code ~= 0 then
    local stderr = result.stderr or ''
    local stdout = result.stdout or ''
    local output = stderr ~= '' and stderr or stdout
    if output == '' then output = 'No output from build command.' end
    vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
  end
end

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then return end

    local pkg = on_install_update_pkgs[name]
    if pkg == nil then return end
    if pkg.build then
      run_build(name, pkg.build, ev.data.path)
      return
    end
    if pkg.cmd then
      if not ev.data.active then vim.cmd.packadd(name) end
      vim.cmd(pkg.cmd)
      return
    end
  end,
})

RzPkg({
  -- GH("nvim-tree/nvim-web-devicons"), -- icons
  'nvim-lua/plenary.nvim',
  'aktersnurra/no-clown-fiesta.nvim', -- theme
  'nvim-mini/mini.nvim', --  A collection of various small independent plugins/modules
  'mbbill/undotree', -- undotree. visual tree of undofile
  'sindrets/diffview.nvim', -- Diff integration
  'NeogitOrg/neogit',
  'folke/trouble.nvim',
})

function _G.R(name) require('plenary.reload').reload_module(name) end

require('no-clown-fiesta').setup({
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
vim.cmd.colorscheme('no-clown-fiesta')
require('mini.icons').setup({
  -- Icon style: 'glyph' or 'ascii'
  style = 'glyph',
})
MiniIcons.mock_nvim_web_devicons()

require('mini.pairs').setup()
require('mini.git').setup()
require('mini.diff').setup({
  view = {
    style = 'sign',
    signs = { add = '+', change = '~', delete = '-' },
  },
})

require('mini.notify').setup({
  window = {
    config = function()
      local has_statusline = vim.o.laststatus > 0
      local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
      return { anchor = 'SE', col = vim.o.columns, row = vim.o.lines - pad }
    end,
    max_width_share = 0.2,
  },
})
vim.notify = MiniNotify.make_notify()

require('mini.hipatterns').setup({
  highlighters = {
    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
    todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
    note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

    -- Highlight hex color strings (`#rrggbb`) using that color
    hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
  },
})
-- require('mini.trailspace').setup()

require('mini.align').setup({
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    start = '<leader>a',
    start_with_preview = '<leader>A',
  },

  -- Modifiers changing alignment steps and/or options
  -- modifiers = {
  -- -- Main option modifiers
  -- ['s'] = --<function: enter split pattern>,
  -- ['j'] = --<function: choose justify side>,
  -- ['m'] = --<function: enter merge delimiter>,

  -- -- Modifiers adding pre-steps
  -- ['f'] = --<function: filter parts by entering Lua expression>,
  -- ['i'] = --<function: ignore some split matches>,
  -- ['p'] = --<function: pair parts>,
  -- ['t'] = --<function: trim parts>,

  -- -- Delete some last pre-step
  -- ['<BS>'] = --<function: delete some last pre-step>,

  -- -- Special configurations for common splits
  -- ['='] = --<function: enhanced setup for '='>,
  -- [','] = --<function: enhanced setup for ','>,
  -- ['|'] = --<function: enhanced setup for '|'>,
  -- [' '] = --<function: enhanced setup for ' '>,
  -- },
})

-- -- Highlight todo, notes, etc in comments
-- -- require('todo-comments').setup { signs = false }
--
-- -- Better Around/Inside textobjects
-- --
-- -- Examples:
-- --  - va)  - [V]isually select [A]round [)]paren
-- --  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
-- --  - ci'  - [C]hange [I]nside [']quote
-- require('mini.ai').setup({
--   -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
--   mappings = {
--     around_next = 'aa',
--     inside_next = 'ii',
--   },
--   n_lines = 500,
-- })

-- -- Add/delete/replace surroundings (brackets, quotes, etc.)
-- --
-- -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- -- - sd'   - [S]urround [D]elete [']quotes
-- -- - sr)'  - [S]urround [R]eplace [)] [']
-- require('mini.surround').setup()

-- Simple and easy statusline.
--  You could remove this setup call if you don't like it,
--  and try some other statusline plugin
-- Set `use_icons` to true if you have a Nerd Font
require('mini.statusline').setup({ use_icons = true })
-- You can configure sections in the statusline by overriding their
-- default behavior. For example, here we set the section for
-- cursor location to LINE:COLUMN
---@diagnostic disable-next-line: duplicate-set-field
MiniStatusline.section_location = function() return '%2l:%-2v' end

require('mini.comment').setup({
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Toggle comment (like `gcip` - comment inner paragraph) for both
    -- Normal and Visual modes
    comment = '<M-?>',

    -- Toggle comment on current line
    comment_line = '<M-/>',

    -- Toggle comment on visual selection
    comment_visual = '<M-/>',

    -- Define 'comment' textobject (like `dgc` - delete whole comment block)
    -- Works also in Visual mode if mapping differs from `comment_visual`
    textobject = '<M-?>',
  },
})

require('mini.indentscope').setup({
  -- Draw options
  draw = {
    -- Delay (in ms) between event and start of drawing scope indicator
    delay = 50,
    animation = require('mini.indentscope').gen_animation.none(),
  },
  -- Module mappings. Use `''` (empty string) to disable one.
  -- mappings = {
  -- 	-- Textobjects
  -- 	object_scope = "ii",
  -- 	object_scope_with_border = "ai",
  --
  -- 	-- Motions (jump to respective border line; if not present - body line)
  -- 	goto_top = "[i",
  -- 	goto_bottom = "]i",
  -- },

  -- Which character to use for drawing scope indicator
  symbol = '╎',
})

do
  require('trouble').setup({
    fold_open = 'v',
    fold_closed = '>',
    indent_lines = true,
    use_diagnostic_signs = 'true',
  })

  ---@type Keymap[]
  set_keymaps({
    {
      'n',
      key = '<leader>xx',
      cb = '<cmd>Trouble diagnostics toggle focus=true<cr>',
      desc = 'TROUBLE: Diagnostics',
    },
    {
      'n',
      key = '<leader>xX',
      cb = '<cmd>Trouble diagnostics toggle focus=true filter.buf=0<cr>',
      desc = 'TROUBLE: Buffer Diagnostics',
    },
    {
      'n',
      key = '<leader>xs',
      cb = '<cmd>Trouble symbols toggle focus=true<cr>',
      desc = 'TROUBLE: Symbols)',
    },
    {
      'n',
      key = '<leader>xl',
      cb = '<cmd>Trouble lsp toggle focus=true win.position=right<cr>',
      desc = 'TROUBLE: LSP Definitions / references / ...',
    },
    {
      'n',
      key = '<leader>xL',
      cb = '<cmd>Trouble loclist toggle<cr>',
      desc = 'TROUBLE: Location List',
    },
    {
      'n',
      key = '<leader>xq',
      cb = '<cmd>Trouble qflist toggle focus=true<cr>',
      desc = 'TROUBLE: Quickfix List',
    },
  })
end

require('neogit').setup({})

-- telescope plugins
require('rizalachp.plugins.telescope')
-- LSP Configuration & Plugins
require('rizalachp.plugins.lsp')
-- Autocompletion
require('rizalachp.plugins.cmp')
-- treesitter plugins
require('rizalachp.plugins.treesitter')

local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = { 'n', 'x' }, keys = '<Leader>' },

    -- `[` and `]` keys
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },

    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = { 'n', 'x' }, keys = 'g' },

    -- Marks
    { mode = { 'n', 'x' }, keys = [[']] },
    { mode = { 'n', 'x' }, keys = '`' },

    -- Registers
    { mode = { 'n', 'x' }, keys = '"' },
    { mode = { 'i', 'c' }, keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = { 'n', 'x' }, keys = 'z' },
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
  window = {
    -- Floating window config
    config = {
      width = 'auto',
    },

    -- Delay before showing clue window
    delay = 100,

    -- Keys to scroll inside the clue window
    scroll_down = '<C-d>',
    scroll_up = '<C-u>',
  },
})
