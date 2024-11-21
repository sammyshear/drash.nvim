local telescope = require('telescope')

local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local previewers = require('telescope.previewers')
local conf = require('telescope.config').values

local M = {}

M.search_sefaria = function(opts)
  opts = opts or { prompt = '', opts.text_language }

  local searcher = function(prompt)
    if not prompt or prompt == '' then
      return {}
    end

    local search_list = require('drash.sefaria').post_search(prompt)
    if search_list == nil then
      return {}
    end

    return search_list.hits.hits
  end

  pickers
    .new(opts, {
      prompt_title = 'Search Sefaria',
      finder = finders.new_table({
        results = searcher(opts.prompt),
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry._id or entry.id,
            ordinal = entry._id or entry.id,
          }
        end,
      }),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selected = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selected == nil then
            return
          end

          local response = require('drash.sefaria').get_text(
            opts.text_language,
            selected.value._source.ref or selected.value.source.ref
          )
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
          local response = require('drash.sefaria').get_text(
            opts.text_language,
            entry.value._source.ref or entry.value.source.ref
          )
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

M.browse_commentaries = function(opts)
  opts = opts or {
    commentaries = {},
    text_language = 'english',
  }

  pickers
    .new(opts, {
      prompt_title = 'Browse Commentaries',
      finder = finders.new_table({
        results = opts.commentaries,
      }),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selected = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selected == nil then
            return
          end

          local response = require('drash.sefaria').get_text(opts.text_language, selected.value)
          local text = {}
          if response == nil then
            text = { 'Error fetching text' }
          elseif
            response.versions ~= nil
            and response.versions[1] ~= nil
            and response.versions[1].text ~= nil
          then
            text = require('telescope.utils').flatten({ response.versions[1].text })
          else
            text = { 'No text found' }
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
          local response = require('drash.sefaria').get_text(opts.text_language, entry.value)
          local text = {}
          if response == nil then
            text = { 'Error fetching text' }
          elseif
            response.versions ~= nil
            and response.versions[1] ~= nil
            and response.versions[1].text ~= nil
          then
            text = require('telescope.utils').flatten({ response.versions[1].text })
          else
            text = { 'No text found' }
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
  exports = {
    search_sefaria = M.search_sefaria,
    browse_commentaries = M.browse_commentaries,
  },
})
