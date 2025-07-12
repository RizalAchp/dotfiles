if vim.g.vscode then
    require('rizalachp_vscodemode');
else
    require('rizalachp')
end
require('plugins').init()
