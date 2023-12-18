local M = {}

local draw = require 'draw'
local spec = require 'spec'
local tags = require 'tags'
local window = require 'window'

local function y()
  return window.height()
end

local function width()
  return window.width()
end

local fg = {}

local function reset()
  fg = spec.default {
    geo = { height = 128 },
    color = { '000000', '000000', '000000', '000000' },
    border = { size = 128 },
    blur = 128,
  }
end

reset()

function M.update()
  fg.geo.y = y()
  fg.geo.width = width()
end

function M.osd()
  return tags.get(fg) .. draw.box(fg)
end

return M
