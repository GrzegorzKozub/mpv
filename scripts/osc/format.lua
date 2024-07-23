local M = {}

function M.time(time)
  local h = math.floor(time / 3600)
  time = time - (h * 3600)
  local m = math.floor(time / 60)
  local s = time - (m * 60)
  if h > 0 then
    return string.format('%.2d:%.2d:%.2d', h, m, s)
  end
  return string.format('%.2d:%.2d', m, s)
end

return M
