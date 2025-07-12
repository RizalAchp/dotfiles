---@alias KeymapMode 'n'|'t'|'v'|'V'|'c'|'s'|'S'|'r'|'R'|'x'

---@class Keymap
---@field [1]      KeymapMode|KeymapMode[]
---@field key      string
---@field cb       string|function
---@field desc     string
---@field opts?    vim.keymap.set.Opts


---@type Keymap[]
local keymaps = {
    { { 'n', 'v' }, key = '<Space>',    cb = '<Nop>',                   desc = 'GENERAL: Set Space into <Nop>' },
    { 'n',          key = '<ESC>',      cb = ':nohlsearch<CR>',         desc = 'GENERAL: Clear search Highlight' },
    { 'n',          key = 'Y',          cb = 'y$',                      desc = 'GENERAL: Yank to EOL' },

    { 'x',          key = '<leader>p',  cb = '"_dP',                    desc = 'GENERAL: Paste without yanking' },
    { { 'n', 'v' }, key = '<leader>d',  cb = '"_d',                     desc = 'GENERAL: Delete without yanking' },

    { 'n',          key = 'j',          cb = 'gj',                      desc = 'GENERAL: Motion to up easier' },
    { 'n',          key = 'k',          cb = 'gk',                      desc = 'GENERAL: Motion to down easier' },

    -- keeping it centered
    { 'n',          key = 'n',          cb = 'nzzzv',                   desc = 'GENERAL: Next search result (centered)' },
    { 'n',          key = 'N',          cb = 'Nzzzv',                   desc = 'GENERAL: Prev search result (centered)' },
    { 'n',          key = '<C-d>',      cb = '<C-d>zz',                 desc = 'GENERAL: Half page down (centered)' },
    { 'n',          key = '<C-u>',      cb = '<C-u>zz',                 desc = 'GENERAL: Half page up (centered)' },

    -- Better indenting in visual mode
    { 'v',          key = '<',          cb = '<gv',                     desc = 'GENERAL: Indent left and reselect' },
    { 'v',          key = '>',          cb = '>gv',                     desc = 'GENERAL: Indent right and reselect' },

    -- Move lines up/down
    { 'n',          key = '<C-j>',      cb = [[:m .+1<CR>==]],          desc = 'GENERAL: Move line down' },
    { 'n',          key = '<C-k>',      cb = [[:m .-2<CR>==]],          desc = 'GENERAL: Move line up' },
    { 'v',          key = '<C-j>',      cb = [[:m '>+1<CR>gv=gv]],      desc = 'GENERAL: Move selection down' },
    { 'v',          key = '<C-k>',      cb = [[:m '<-2<CR>gv=gv]],      desc = 'GENERAL: Move selection up' },

    -- Windowing
    { 'n',          key = '<C-h>',      cb = '<C-w><C-h>',              desc = 'WINDOW: Move focus to the left' },
    { 'n',          key = '<C-l>',      cb = '<C-w><C-l>',              desc = 'WINDOW: Move focus to the right' },
    { 'n',          key = '<C-j>',      cb = '<C-w><C-j>',              desc = 'WINDOW: Move focus to the lower' },
    { 'n',          key = '<C-k>',      cb = '<C-w><C-k>',              desc = 'WINDOW: Move focus to the upper' },
    { 'n',          key = '<leader>sv', cb = ':vsplit<CR>',             desc = 'WINDOW: Split vertically' },
    { 'n',          key = '<leader>sh', cb = ':split<CR>',              desc = 'WINDOW: Split horizontally' },
    { 'n',          key = '<C-Up>',     cb = ':resize +2<CR>',          desc = 'WINDOW: Increase height' },
    { 'n',          key = '<C-Down>',   cb = ':resize -2<CR>',          desc = 'WINDOW: Decrease height' },
    { 'n',          key = '<C-Left>',   cb = ':vertical resize -2<CR>', desc = 'WINDOW: Decrease width' },
    { 'n',          key = '<C-Right>',  cb = ':vertical resize +2<CR>', desc = 'WINDOW: Increase width' },

    -- Buffers
    { 'n',          key = '<M-j>',      cb = ':bnext<CR>',              desc = 'BUFFER: binding for togle to next tab' },
    { 'n',          key = '<M-k>',      cb = ':bprev<CR>',              desc = 'BUFFER: binding for togle to previous tab' },
    { 'n',          key = '<M-b>',      cb = ':bd<CR>',                 desc = 'BUFFER: delete force' },
    { 'n',          key = '<M-B>',      cb = ':bd!<CR>',                desc = 'BUFFER: delete force' },
}


if vim.g.neovide then
    local add_neovide_scale_factor = function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.05; end
    local sub_neovide_scale_factor = function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.05; end
    local reset_neovide_scale_factor = function() vim.g.neovide_scale_factor = 1 end

    keymaps = vim.list_extend(keymaps, {
        { { 'n', 'v' }, key = '<C-=>', cb = add_neovide_scale_factor,   desc = '[NEOVIDE] Zoom in' },
        { { 'n', 'v' }, key = '<C-->', cb = sub_neovide_scale_factor,   desc = '[NEOVIDE] Zoom out' },
        { { 'n', 'v' }, key = '<C-0>', cb = reset_neovide_scale_factor, desc = '[NEOVIDE] Zoom reset' },
    });
end

local function open_file_newtab()
    vim.ui.input({ prompt = 'File to open in new tab: ', completion = 'file' }, function(input)
        if input and input ~= '' then
            vim.cmd('tabnew ' .. input)
        end
    end)
end
local function duplicate_curtab()
    local current_file = vim.fn.expand('%:p')
    if current_file ~= '' then
        vim.cmd('tabnew ' .. current_file)
    else
        vim.cmd('tabnew')
    end
end
local function close_tab_right()
    local current_tab = vim.fn.tabpagenr()
    local last_tab = vim.fn.tabpagenr('$')

    for i = last_tab, current_tab + 1, -1 do
        vim.cmd(i .. 'tabclose')
    end
end
local function close_tab_left()
    local current_tab = vim.fn.tabpagenr()

    for _ = current_tab - 1, 1, -1 do
        vim.cmd('1tabclose')
    end
end

local function smart_close_tab()
    local buffers_in_tab = #vim.fn.tabpagebuflist()
    if buffers_in_tab > 1 then
        vim.cmd('bdelete')
    else
        -- If it's the only buffer in tab, close the tab
        vim.cmd('tabclose')
    end
end

keymaps = vim.list_extend(keymaps, {
    { 'n',          key = '<M-s>', cb = [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left><Left>]], desc = 'GENERAL: Rename under cursor' },
    { { 'n', 'v' }, key = '<M-S>', cb = [[:%s///gIc<Left><Left><Left><Left><Left>]],                   desc = 'GENERAL: Enter search and rename' },
    {
        "n",
        key = "<leader>pa",
        cb = function()
            local path = vim.fn.expand("%:p")
            vim.fn.setreg("+", path)
            print("file:", path)
        end,
        desc = 'GENERAL: Copy current buffer full path'
    },
    -- Key mappings
    { "n", key = "<leader>tt", cb = FloatingTerminal,      desc = "TERMINAL: Toggle floating terminal",                   opts = { silent = true } },
    { "t", key = "<Esc>",      cb = CloseFloatingTerminal, desc = "TERMINAL: Close floating terminal from terminal mode", opts = { silent = true } },
    -- Alternative navigation (more intuitive)
    { 'n', key = '<leader>tn', cb = ':tabnew<CR>',         desc = 'TAB: New tab' },
    { 'n', key = '<leader>tx', cb = ':tabclose<CR>',       desc = 'TAB: Close tab' },
    -- Tab moving
    { 'n', key = '<leader>tm', cb = ':tabmove<CR>',        desc = 'TAB: Move tab' },
    { 'n', key = '<leader>t>', cb = ':tabmove +1<CR>',     desc = 'TAB: Move tab right' },
    { 'n', key = '<leader>t<', cb = ':tabmove -1<CR>',     desc = 'TAB: Move tab left' },
    { 'n', key = '<leader>tO', cb = open_file_newtab,      desc = 'TAB: Open file in new tab' },
    { 'n', key = '<leader>td', cb = duplicate_curtab,      desc = 'TAB: Duplicate current tab' },
    { 'n', key = '<leader>tr', cb = close_tab_right,       desc = 'TAB: Close tabs to the right' },
    { 'n', key = '<leader>tL', cb = close_tab_left,        desc = 'TAB: Close tabs to the left' },
    { 'n', key = '<leader>tc', cb = smart_close_tab,       desc = 'TAB: Smart close buffer/tab' },
})

return keymaps
