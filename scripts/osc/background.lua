local M = {}

local draw = require 'draw'
local tags = require 'tags'
local window = require 'window'

local function y()
  return window.height()
end

local function width()
  return window.width()
end

local data = {
  geo = { x = 0, height = 1, align = 7 },
  border = { size = 128 },
  blur = 128,
}

function M.update()
  data.geo.y = y()
  data.geo.width = width()
end

function M.osd()
  return tags.get(data) .. draw.box(data)
end

return M
