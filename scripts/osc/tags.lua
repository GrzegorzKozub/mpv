local M = {}

function M.get(spec)
  local tags = '{'
  tags = tags .. string.format('\\pos(%f,%f)\\an%d', spec.geo.x, spec.geo.y, spec.geo.align)
  tags = tags
    .. string.format('\\1c&H%s&\\2c&H%s&\\3c&H%s&\\4c&H%s&', spec.color[1], spec.color[2], spec.color[3], spec.color[4])
  tags = tags
    .. string.format('\\1a&H%x&\\2a&H%x&\\3a&H%x&\\4a&H%x&', spec.alpha[1], spec.alpha[2], spec.alpha[3], spec.alpha[4])
  tags = tags .. string.format('\\bord%.2f', spec.border.size)
  tags = tags .. string.format('\\blur%.2f', spec.blur)
  tags = tags .. '\\fn' .. spec.font.name .. string.format('\\fs%.2f', spec.font.size)
  tags = tags .. '}'
  return tags
end

return M
