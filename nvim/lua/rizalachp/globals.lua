function _G.R(name)
    require("plenary.reload").reload_module(name)
end

function _G.P(cmd)
    print(vim.inspect(cmd))
end

---@type vim.lsp.client.on_attach_cb
function _G.OnAttachLsp(_, buf)
    local nmap = function(keys, func, desc)
        if desc then desc = "LSP: " .. desc end
        vim.keymap.set("n", keys, func, { buffer = buf, noremap = true, desc = desc })
    end

    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<leader>K', vim.lsp.buf.signature_help, '[S]ignature [D]ocumentation')

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<F2>', vim.lsp.buf.rename, '[R]e[n]ame')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('gf', vim.lsp.buf.format, '[G]o [F]ormat Documents')
    nmap('gc', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('g,', function() vim.diagnostic.jump({ count = 1 }) end, '[G]oto Prev Diagnostic')
    nmap('g.', function() vim.diagnostic.jump({ count = 1 }) end, '[G]oto Next Diagnostic')

    nmap('<leader>dh', vim.diagnostic.hide, '[D]iagnostic [H]ide')
    nmap('<leader>ds', vim.diagnostic.show, '[D]iagnostic [S]how')

    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")


    local telescope_builtin = require('telescope.builtin')
    nmap('gr', telescope_builtin.lsp_references, 'TelescopeBuiltin: [G]oto [R]eferences')
    nmap('<leader>td', telescope_builtin.lsp_type_definitions, 'TelescopeBuiltin: [T]ype [D]efinition')
    nmap('<leader>df', telescope_builtin.diagnostics, 'TelescopeBuiltin: [D]iagnostic [O]pen float')
    nmap('<leader>ds', telescope_builtin.lsp_document_symbols, 'TelescopeBuiltin: [D]ocument [S]ymbols')
    nmap('<leader>ws', telescope_builtin.lsp_dynamic_workspace_symbols, 'TelescopeBuiltin: [W]orkspace [S]ymbols')

    vim.api.nvim_buf_create_user_command(buf, "Format", function(_)
        if vim.lsp.buf.format then
            vim.lsp.buf.format()
        elseif vim.lsp.buf.formatting then
            vim.lsp.buf.formatting()
        end
    end, { desc = "Format current buffer with LSP" })
end

-- terminal
_G.floating_terminal_state = {
    buf = nil,
    win = nil,
    is_open = false
}

function _G.FloatingTerminal()
    -- If terminal is already open, close it (toggle behavior)
    if floating_terminal_state.is_open and vim.api.nvim_win_is_valid(floating_terminal_state.win) then
        vim.api.nvim_win_close(floating_terminal_state.win, false)
        floating_terminal_state.is_open = false
        return
    end

    -- Create buffer if it doesn't exist or is invalid
    if not floating_terminal_state.buf or not vim.api.nvim_buf_is_valid(floating_terminal_state.buf) then
        floating_terminal_state.buf = vim.api.nvim_create_buf(false, true)
        -- Set buffer options for better terminal experience
        vim.api.nvim_buf_set_option(floating_terminal_state.buf, 'bufhidden', 'hide')
    end

    -- Calculate window dimensions
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    -- Create the floating window
    floating_terminal_state.win = vim.api.nvim_open_win(floating_terminal_state.buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'rounded',
    })

    -- Set transparency for the floating window
    vim.api.nvim_win_set_option(floating_terminal_state.win, 'winblend', 0)

    -- Set transparent background for the window
    vim.api.nvim_win_set_option(floating_terminal_state.win, 'winhighlight',
        'Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder')

    -- Define highlight groups for transparency
    vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
    vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none", })

    -- Start terminal if not already running
    local has_terminal = false
    local lines = vim.api.nvim_buf_get_lines(floating_terminal_state.buf, 0, -1, false)
    for _, line in ipairs(lines) do
        if line ~= "" then
            has_terminal = true
            break
        end
    end

    if not has_terminal then
        -- vim.fn.termopen(os.getenv("SHELL"))
        vim.fn.jobstart(os.getenv("SHELL") or '/usr/bin/sh', { term = true })
    end

    floating_terminal_state.is_open = true
    vim.cmd("startinsert")

    -- Set up auto-close on buffer leave
    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = floating_terminal_state.buf,
        callback = function()
            if floating_terminal_state.is_open and vim.api.nvim_win_is_valid(floating_terminal_state.win) then
                vim.api.nvim_win_close(floating_terminal_state.win, false)
                floating_terminal_state.is_open = false
            end
        end,
        once = true
    })
end

-- Function to explicitly close the terminal
function _G.CloseFloatingTerminal()
    if floating_terminal_state.is_open and vim.api.nvim_win_is_valid(floating_terminal_state.win) then
        vim.api.nvim_win_close(floating_terminal_state.win, false)
        floating_terminal_state.is_open = false
    end
end
