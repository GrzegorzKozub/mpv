local M = {}

local draw = require 'draw'
local size = require 'size'
local spec = require 'spec'
local tags = require 'tags'
local window = require 'window'

local fg = {}

local function width()
  return window.width()
end

local function y()
  return window.height()
end

function M.reset()
  fg = spec.default {
    geo = { height = size.ui.height },
    color = { '000000', '000000', '000000', '000000' },
    border = { size = size.ui.height },
    blur = size.ui.height,
  }
end

function M.update()
  fg.geo.width = width()
  fg.geo.y = y()
end

function M.osd()
  return tags.get(fg) .. draw.box(fg)
end

return M
