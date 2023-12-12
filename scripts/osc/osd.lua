local M = {}

local osd = mp.create_osd_overlay 'ass-events'

local window = require 'window'

function M.setup()
  osd.res_x = window.width()
  osd.res_y = window.height()
end

function M.show(data)
  if data == osd.data then
    return
  end
  osd.data = data
  osd:update()
end

function M.hide()
  M.show ''
end

return M
