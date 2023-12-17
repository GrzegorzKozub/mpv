local M = {}

function M.get(data)
  local tags = '{'
  tags = tags .. string.format('\\pos(%f,%f)\\an%d', data.geo.x, data.geo.y, data.geo.align)
  local color = data.color or { 'ffffff', '000000', 'ffffff', '000000' }
  tags = tags .. string.format('\\1c&H%s&\\2c&H%s&\\3c&H%s&\\4c&H%s&', color[1], color[2], color[3], color[4])
  local alpha = data.alpha or { 64, 0, 64, 0 }
  tags = tags .. string.format('\\1a&H%x&\\2a&H%x&\\3a&H%x&\\4a&H%x&', alpha[1], alpha[2], alpha[3], alpha[4])
  local border = data.border and data.border.size or 0
  if border then
    tags = tags .. string.format('\\bord%.2f', border)
  end
  if data.blur then
    tags = tags .. string.format('\\blur%.2f', data.blur)
  end
  local font_name = data.font and data.font.name or (require('env').win() and 'CaskaydiaCove NF' or 'monospace')
  local font_size = data.font and data.font.size or 32
  tags = tags .. '\\fn' .. font_name .. string.format('\\fs%.2f', font_size)
  tags = tags .. '}'
  return tags
end

return M
