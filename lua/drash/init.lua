local sefaria = require('drash.sefaria')
local telescope = require('telescope')
_ = sefaria
local M = {}

M.setup = function(spec, opts)
  _ = spec
  _ = opts

  vim.api.nvim_create_user_command('PostSearch', function(opt)
    local query = opt.args
    local data = sefaria.post_search(query)

    if data == nil then
      vim.notify('failed', vim.log.levels.ERROR, {})
      return
    end

    vim.notify(vim.fn.string(data.hits.hits or ''), vim.log.levels.DEBUG, {})
  end, { nargs = '?' })

  telescope.load_extension('drash')
end

return M
