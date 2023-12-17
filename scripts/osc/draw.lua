local M = {}

local assdraw = require 'mp.assdraw'

function M.box(data)
  local radius = data.border and data.border.radius or 0
  local ass = assdraw.ass_new()
  ass:new_event()
  ass:draw_start()
  ass:round_rect_cw(0, 0, data.geo.width, data.geo.height, radius, radius)
  ass:draw_stop()
  return ass.text
end

return M
