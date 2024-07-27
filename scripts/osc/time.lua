local M = {}

local align = require 'align'
local chapters = require 'chapters'
local font = require 'font'
local format = require 'format'
local size = require 'size'
local spec = require 'spec'
local tags = require 'tags'
local window = require 'window'

local fg = {}

local function x()
  return 2 * size.margin + size.button + (chapters.any() and (size.margin + size.button) or 0)
end

local function y()
  return window.height() - size.margin - 0.5 * size.label.height
end

local function text()
  return format.time(mp.get_property_number('time-pos', 0))
    .. ' / '
    .. format.time(mp.get_property_number('duration', 0))
    .. (chapters.any() and '    ' .. chapters.current() or '')
end

function M.reset()
  fg = spec.default {
    geo = { align = align.middle.left },
    font = { name = font.sans_serif, size = size.label.font },
  }
end

function M.update()
  fg.geo.x = x()
  fg.geo.y = y()
end

function M.osd()
  return tags.get(fg) .. text()
end

return M
