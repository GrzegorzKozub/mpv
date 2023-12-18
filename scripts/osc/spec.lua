local M = {}

local font = require 'font'
local util = require 'util'

local default = {
  geo = { x = 0, y = 0, width = 0, height = 0, align = 7 },
  color = { 'ffffff', '000000', 'ffffff', '000000' },
  alpha = { 64, 0, 64, 0 },
  border = { size = 0, radius = 0 },
  blur = 0,
  font = { name = font.monospace, size = 32 },
}

function M.default(also)
  return util.merge(util.copy(default), also)
end

function M.hover(spec)
  spec.alpha[1] = 0
  spec.border.size = 2
  spec.blur = 10
end

return M
