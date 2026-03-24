local M = {}

function M.has_next()
  local count = mp.get_property_number('playlist-count', 0)
  local pos = mp.get_property_number('playlist-pos', 0)
  return pos + 1 < count
end

function M.next()
  mp.commandv('playlist-next')
end

return M
