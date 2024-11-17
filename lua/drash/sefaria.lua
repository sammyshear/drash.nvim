local plenary_curl = require('plenary.curl')

local M = {}

M.get_calendar = function()
  local url = 'https://www.sefaria.org/api/calendars'

  local response = plenary_curl.get(url)

  if response.status ~= 200 then
    return nil
  end

  local body = response.body
  local data = vim.json.decode(body)

  return data
end

return M
