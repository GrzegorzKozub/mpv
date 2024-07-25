local M = {}

local align = require 'align'
local font = require 'font'
local format = require 'format'
local size = require 'size'
local spec = require 'spec'
local tags = require 'tags'
local window = require 'window'

local fg = {}

local function y()
  return window.height() - size.margin - 0.5 * size.label.height
end

local function text()
  return format.time(mp.get_property_number 'time-pos' or 0)
    .. ' / '
    .. format.time(mp.get_property_number 'duration' or 0)
end

function M.reset()
  fg = spec.default {
    geo = {
      x = size.margin + size.button + size.margin,
      align = align.middle.left,
    },
    font = { name = font.sans_serif, size = size.label.font },
  }
end

function M.update()
  fg.geo.y = y()
end

function M.osd()
  return tags.get(fg) .. text()
end

return M
