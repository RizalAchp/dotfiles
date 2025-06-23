local key_map = function(mode, keys, func, desc)
    vim.keymap.set(mode, keys, func, { noremap = true, desc = desc })
end
key_map('n', '<ESC>', '<cmd>nohlsearch<CR>')
key_map('t', '<ESC>', '<C-\\><C-n>', 'TERMINAL: Exit terminal mode')

key_map('n', '<C-h>', '<C-w><C-h>', '[WINDOW] Move focus to the left window')
key_map('n', '<C-l>', '<C-w><C-l>', '[WINDOW] Move focus to the right window')
key_map('n', '<C-j>', '<C-w><C-j>', '[WINDOW] Move focus to the lower window')
key_map('n', '<C-k>', '<C-w><C-k>', '[WINDOW] Move focus to the upper window')

key_map({ 'n', 'v' }, '<Space>', '<Nop>', 'GENERAL: set Space into <Nop>')
key_map('n', '<Leader>tt', '<CMD>vnew term://bash<CR>', 'OPEN TERMINAL')
-- navigation
key_map('n', 'j', 'gj', 'GENERAL: Motion to up easier')
key_map('n', 'k', 'gk', 'GENERAL: Motion to down easier')
key_map('n', 'Y', 'y$', 'GENERAL: bind shift -u to copy from cursor position to the end of line')
key_map('n', '<C-d>', '<C-d>zz')
key_map('n', '<M-b>', '<CMD>bd<CR>', 'BUFFER: delete')
key_map('n', '<M-B>', '<CMD>bd!<CR>', 'BUFFER: delete force')

--- keeping it centered
key_map('n', 'n', 'nzzzv', 'keep center while doing next on n bind')
key_map('n', 'N', 'Nzzzv', 'keep center while doing next on shift-n bind')

---
key_map('v', '<C-j>', [[:m '>+1<CR>gv=gv]], 'move blocked text / visual mode to bottom')
key_map('v', '<C-k>', [[:m '<-2<CR>gv=gv]], 'move blocked text / visual mode to top')
-- greatest remap ever
key_map('x', '<leader>p', [["_dP]])

-- next greatest remap ever : asbjornHaland
key_map({ 'n', 'v' }, '<leader>y', [["+y]])
key_map('n', '<leader>Y', [["+Y]])

--- buffline
key_map('n', '<M-j>', '<CMD>bNext<CR>', 'BUFFER: binding for togle to next tab')
key_map('n', '<M-k>', '<CMD>bnext<CR>', 'BUFFER: binding for togle to previous tab')

key_map('n', '<M-s>', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left><Left>]], 'GENERIC: Rename under cursor')
key_map({'n', 'v'}, '<M-S>', [[:%s///gIc<Left><Left><Left><Left><Left>]], 'GENERIC: Enter search and rename')

if vim.g.neovide then
    local add_neovide_scale_factor = function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.05; end
    local sub_neovide_scale_factor = function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.05; end
    local reset_neovide_scale_factor = function() vim.g.neovide_scale_factor = 1 end

    key_map({ 'n', 'v' }, '<C-=>', add_neovide_scale_factor, '[NEOVIDE ZOOM+] IN')
    key_map({ 'n', 'v' }, '<C-->', sub_neovide_scale_factor, '[NEOVIDE ZOOM-] OUT')
    key_map({ 'n', 'v' }, '<C-0>', reset_neovide_scale_factor, '[NEOVIDE ZOOM] RESET')
end
