local plenary_curl = require('plenary.curl')
local drash_utils = require('drash.util')

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
    body = '{ "query":"' .. query .. '", "source_proj":true }',
    headers = {
      ['Content-Type'] = 'application/json',
      accept = 'application/json',
    },
  })

  if response.status ~= 200 then
    return nil
  end

  local data = vim.fn.json_decode(response.body)
  return data
end

M.post_find_refs = function(title, body)
  local url = 'https://www.sefaria.org/api/find-refs'
  local response = plenary_curl.post(url, {
    body = '{ "text": {"title":"' .. title .. '", "body":"' .. body .. '"}, "lang":"en" }',
    headers = {
      ['Content-Type'] = 'application/json',
    },
  })

  if response.status ~= 200 then
    return nil
  end

  local data = vim.fn.json_decode(response.body)
  return data
end

M.get_text = function(ref)
  ref = drash_utils.url_encode(ref)
  local url = 'https://www.sefaria.org/api/v3/texts/' .. ref

  local response = plenary_curl.get(url, {
    query = { version = 'english', return_format = 'text_only' },
  })

  if response.status ~= 200 then
    return nil
  end

  local data = vim.fn.json_decode(response.body)
  return data
end

M.get_related = function(ref)
  ref = drash_utils.url_encode(ref)
  local url = 'https://www.sefaria.org/api/related/' .. ref

  local response = plenary_curl.get(url)

  if response.status ~= 200 then
    return nil
  end

  local data = vim.fn.json_decode(response.body)
  return data
end

return M
