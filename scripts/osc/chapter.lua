local M = {}

-- https://github.com/mpv-player/mpv/blob/master/player/lua/osc.lua#L564

local align = require 'align'
local font = require 'font'
local size = require 'size'
local spec = require 'spec'
local tags = require 'tags'
local window = require 'window'

local fg = {}

local function y()
  return window.height() - size.margin - 0.5 * size.label.height
end

local function text()
  local proplist = mp.get_property_native('chapter-list', {})
  if #proplist == 0 then
    return ''
  end
  local c = mp.get_property_number('chapter', 0) + 1
  return proplist[c].title or c
end

function M.reset()
  fg = spec.default {
    geo = {
      x = size.margin + size.button + size.margin + 500,
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
