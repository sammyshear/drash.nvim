local plenary_curl = require('plenary.curl')
local drash_util = require('drash.util')

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

M.post_search = function(query)
  if query == nil then
    return nil
  end
  local url = 'https://www.sefaria.org/api/search-wrapper'

  local response = plenary_curl.post(url, {
    body = '{ "query":"' .. query .. '" }',
    headers = {
      ['Content-Type'] = 'application/json',
    },
  })

  if response.status ~= 200 then
    return nil
  end

  local body = response.body

  local data = vim.json.decode(body)
  return data
end

M.get_text = function(id)
  id = drash_util.url_encode(id)
  local url = 'https://www.sefaria.org/api/v3/texts/'
    .. id
    .. '?version=english&return_format=text_only'
  print(url)

  local response = plenary_curl.get(url)

  if response.status ~= 200 then
    return nil
  end

  local body = response.body
  local data = vim.json.decode(body)

  return data
end

return M
