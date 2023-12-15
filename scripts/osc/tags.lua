local M = {}

function M.get(data)
  local tags = '{'
  tags = tags .. string.format('\\pos(%f,%f)\\an%d', data.geo.x, data.geo.y, data.geo.align)
  if data.color then
    tags = tags
      .. string.format(
        '\\1c&H%s&\\2c&H%s&\\3c&H%s&\\4c&H%s&',
        data.color[1],
        data.color[2],
        data.color[3],
        data.color[4]
      )
  end
  local alpha = data.alpha or { 0, 0, 0, 0 }
  tags = tags .. string.format('\\1a&H%x&\\2a&H%x&\\3a&H%x&\\4a&H%x&', alpha[1], alpha[2], alpha[3], alpha[4])
  local border = data.border or 0
  tags = tags .. string.format('\\bord%.2f', border)
  if data.blur then
    tags = tags .. string.format('\\blur%.2f', data.blur)
  end
  if data.font then
    tags = tags .. '\\fn' .. data.font.name .. string.format('\\fs%.2f', data.font.size)
  end
  tags = tags .. '}'
  return tags
end

return M
