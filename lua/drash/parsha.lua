local sefaria = require('drash.sefaria')
local M = {}

M.parsha = function(opts)
  local calendar = sefaria.get_calendar()
  if calendar == nil then
    return nil
  end
  local parsha_ref = ''
  local parsha_title = ''
  for _, item in ipairs(calendar.calendar_items) do
    if item.title.en == 'Parashat Hashavua' then
      parsha_ref = item.ref
      parsha_title = item.displayValue.en
    end
  end

  local parsha = sefaria.get_text(opts.text_language, parsha_ref)
  if parsha == nil then
    return nil
  end

  local text = parsha.versions[1].text

  local related = sefaria.get_related(parsha_ref)
  if related == nil then
    return nil
  end

  local commentaries = {}
  for _, item in ipairs(related.links) do
    if item.type == 'commentary' then
      commentaries[#commentaries + 1] = item.ref
    end
  end

  return {
    parsha_ref = parsha_ref,
    parsha_title = parsha_title,
    text = text,
    commentaries = commentaries,
  }
end

return M
