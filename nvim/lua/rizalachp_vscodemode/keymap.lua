-- local vscode = require('vscode-neovim')

---@param mode string|table    Mode short-name, see |nvim_set_keymap()|.
---                            Can also be list of modes to create mapping on multiple modes.
---@param keys string           Left-hand side |{lhs}| of the mapping.
---@param func string|function  Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param opts table|nil Table of |:map-arguments|.
local key_map = function(mode, keys, func, opts)
    vim.keymap.set(mode, keys, func, opts)
end

vim.g.mapleader = ' '

key_map({ 'n', 'v', 'x' }, '<Space>', '<Nop>')

key_map("n", "j", "gj")
key_map("n", "k", "gk")
key_map("n", "Y", "y$")
key_map("n", "<C-d>", "<C-d>zz")
key_map("n", "<M-b>", "<CMD>bd<CR>")

--- keeping it centered
key_map("n", "n", "nzzzv")
key_map("n", "N", "Nzzzv")
key_map("n", "J", "mzJ`z")

key_map("v", "<C-k>", ":m '>+1<CR>gv=gv")
key_map("v", "<C-j>", ":m '<-2<CR>gv=gv")

key_map("n", "<M-s>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left>]])
-- map('n', 'K', '<cmd>call VSCodeNotify("editor.action.showHover")<CR>')
-- map('n', '<space>gr', '<cmd>call VSCodeNotify("editor.action.goToReferences")<CR>')
-- map('n', '<space>qf', '<cmd>call VSCodeNotify("editor.action.quickFix")<CR>')
-- map('n', '<space>gd', '<cmd>call VSCodeNotify("editor.action.revealDefinition")<CR>')
-- map('n', '<C-w>gd', '<cmd>call VSCodeNotify("editor.action.revealDefinitionAside")<CR>')
-- Commentary
key_map('x', '<M-/>', '<Plug>VSCodeCommentary', { noremap = false })
key_map('n', '<M-/>', '<Plug>VSCodeCommentary', { noremap = false })
key_map('o', '<M-/>', '<Plug>VSCodeCommentary', { noremap = false })
key_map('n', '<M-S>/', '<Plug>VSCodeCommentaryLine', { noremap = false })

-- General
key_map('n', '<space>.', '<cmd>call VSCodeNotify("workbench.action.openSettingsJson")<CR>')
key_map('n', '<space>;', '<cmd>call VSCodeNotify("workbench.action.showCommands")<CR>')
key_map('n', '<space>z', '<cmd>call VSCodeNotify("workbench.action.toggleZenMode")<CR>')
key_map('n', '<space>ca', '<cmd>call VSCodeNotify("editor.action.quickFix")<CR>')
key_map('n', '<space>rn', '<cmd>call VSCodeNotify("editor.action.rename")<CR>')
key_map('n', 'gd', '<cmd>call VSCodeNotify("editor.action.goToTypeDefinition")<CR>')
key_map('n', 'gr', '<cmd>call VSCodeNotify("editor.action.goToReferences")<CR>')
key_map('n', 'gi', '<cmd>call VSCodeNotify("editor.action.goToImplementation")<CR>')
key_map('n', 'gf', '<cmd>call VSCodeNotify("editor.action.formatDocument")<CR>')
key_map('v', 'gf', '<cmd>call VSCodeNotify("editor.action.formatSelection")<CR>')

key_map('n', 'g,', '<cmd>call VSCodeNotify("editor.action.marker.prev")<CR>')
key_map('n', 'g.', '<cmd>call VSCodeNotify("editor.action.marker.next")<CR>')

key_map('n', 'g<', '<cmd>call VSCodeNotify("editor.action.marker.prevInFiles")<CR>')
key_map('n', 'g>', '<cmd>call VSCodeNotify("editor.action.marker.nextInFiles")<CR>')

-- Show
key_map('n', '<space>sd', '<cmd>call VSCodeNotify("workbench.debug.action.toggleRepl")<CR>')
key_map('n', '<space>se', '<cmd>call VSCodeNotify("workbench.view.explorer")<CR>')
key_map('n', '<space>sg', '<cmd>call VSCodeNotify("workbench.view.scm")<CR>')

-- Open
key_map('n', '<space>od', '<cmd>call VSCodeNotify("workbench.action.files.openFolder")<CR>')
key_map('n', '<space>or', '<cmd>call VSCodeNotify("workbench.action.openRecent")<CR>')
