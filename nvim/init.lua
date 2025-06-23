---@nodiscard
---@param modname string
---@return unknown|nil
_G.SafeRequire = function(modname)
    local ok, result = pcall(require, modname)
    if not ok then
        vim.notify(string.format('Error while requiring module %s. (%s)', modname, result), vim.log.levels.ERROR)
        return nil
    end
    return result
end

if vim.g.vscode then
    require('rizalachp_vscodemode');
else
    local main_module = SafeRequire('rizalachp')
    if main_module ~= nil then
        local plugins = SafeRequire('plugins')
        if plugins ~= nil then
            plugins.init()
        end
    end
end
