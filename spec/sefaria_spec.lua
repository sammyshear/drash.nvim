---@diagnostic disable: undefined-global
local sefaria = require('drash.sefaria')

describe('sefaria', function()
  it('should return a table', function()
    assert.are.same(type(sefaria.get_calendar()), 'table')
  end)
  it('should return a table with a key of "calendar_items"', function()
    assert.are.same(type(sefaria.get_calendar().calendar_items), 'table')
  end)
end)
