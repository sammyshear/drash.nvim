local telescope = require('telescope')
local drash_parsha = require('drash.parsha')
local telescope_drash = require('telescope._extensions.drash')
local M = {}

M.setup = function(opts)
  opts = opts or {
    text_language = 'english',
  }

  telescope.load_extension('drash')
  vim.api.nvim_create_user_command('SearchSefaria', function(opt)
    telescope_drash.exports.search_sefaria({ prompt = opt.args, text_language = opts.text_language })
  end, { nargs = '?' })
  vim.api.nvim_create_user_command('Parsha', function()
    local parsha_info = drash_parsha.parsha(opts)
    if parsha_info == nil then
      return nil
    end

    local bufnr = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, parsha_info.text[1])
    vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
    vim.api.nvim_win_set_buf(0, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'Commentaries', function()
      telescope_drash.exports.browse_commentaries({
        commentaries = parsha_info.commentaries,
        text_language = opts.text_language,
      })
    end, {})
  end, {})
end

return M
