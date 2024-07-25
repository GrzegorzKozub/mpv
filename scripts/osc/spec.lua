local M = {}

local align = require 'align'
local font = require 'font'
local size = require 'size'
local util = require 'util'

local default = {
  geo = { x = 0, y = 0, width = 0, height = 0, align = align.top.left },
  color = { 'ffffff', '00ff00', 'ffffff', 'ff0000' },
  alpha = { 64, 0, 64, 0 },
  border = { size = 0, radius = 0 },
  blur = 0,
  font = { name = font.monospace, size = size.button },
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
