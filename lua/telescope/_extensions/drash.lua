local telescope = require('telescope')

local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local previewers = require('telescope.previewers')
local make_entry = require('telescope.make_entry')
local conf = require('telescope.config').values

local M = {}

M.search_sefaria = function(opts)
  opts = opts or { prompt = '' }
  opts.entry_maker = make_entry.gen_from_string(opts)
  print(opts.prompt)

  local searcher = function(prompt)
    if not prompt or prompt == '' then
      return {}
    end

    local search_list = require('drash.sefaria').post_search(prompt)
    if search_list == nil then
      return {}
    end

    local hits = search_list.hits.hits
    for i, hit in ipairs(search_list.hits.hits) do
      hits[i] = hit._id
    end

    return hits
  end

  pickers
    .new(opts, {
      prompt_title = 'Search Sefaria',
      finder = finders.new_table({
        results = searcher(opts.prompt),
        entry_maker = opts.entry_maker,
      }),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selected = action_state.get_selected_entry()
          print(vim.inspect(selected))
          actions.close(prompt_bufnr)
          if selected == nil then
            return
          end

          local response = require('drash.sefaria').get_text(selected[1])
          local text = {}
          if response == nil then
            text = { 'Error fetching text' }
          else
            text = require('telescope.utils').flatten({ response.versions[1].text })
          end
          local bufnr = vim.api.nvim_create_buf(true, true)
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, text)
          vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
          vim.api.nvim_open_win(bufnr, true, {
            split = 'right',
            win = 0,
          })
        end)
        return true
      end,
      previewer = previewers.new_buffer_previewer({
        define_preview = function(self, entry)
          local response = require('drash.sefaria').get_text(entry[1])
          local text = {}
          if response == nil then
            text = { 'Error fetching text' }
          else
            text = require('telescope.utils').flatten({ response.versions[1].text })
          end
          self.state.bufnr = self.state.bufnr or vim.api.nvim_get_current_buf()
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, text)
        end,
      }),
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

return telescope.register_extension({
  setup = function()
    vim.api.nvim_create_user_command('SearchSefaria', function(opts)
      M.search_sefaria({ prompt = opts.args })
    end, { nargs = '?' })
  end,
  exports = {
    search_sefaria = M.search_sefaria,
  },
})
