local M = {}

local chapters = {}

local function current()
  return mp.get_property_number('chapter', 0) + 1
end

function M.update()
  chapters = mp.get_property_native('chapter-list', {})
end

function M.any()
  return #chapters ~= 0
end

function M.current()
  if #chapters == 0 then
    return ''
  end
  return chapters[current()].title
end

function M.next()
  if #chapters == 0 then
    return
  end
  if current() == #chapters then
    mp.commandv('set', 'chapter', 1)
  else
    mp.commandv('add', 'chapter', 1)
  end
end

return M
