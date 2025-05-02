require("rizalachp.set")
require("rizalachp.keymap")

function R(name)
    require("plenary.reload").reload_module(name)
end

function P(cmd)
    print(vim.inspect(cmd))
end

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function() vim.highlight.on_yank() end,
    group = highlight_group,
    pattern = '*',
})

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
    nmap('g,', vim.diagnostic.goto_prev, '[G]oto Prev Diagnostic')
    nmap('g.', vim.diagnostic.goto_next, '[G]oto Next Diagnostic')

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
