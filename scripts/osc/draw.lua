local M = {}

local assdraw = require 'mp.assdraw'

function M.box(width, height, radius)
  local ass = assdraw.ass_new()
  ass:new_event()
  ass:draw_start()
  ass:round_rect_cw(0, 0, width, height, radius, radius)
  ass:draw_stop()
  return ass.text
end

return M
