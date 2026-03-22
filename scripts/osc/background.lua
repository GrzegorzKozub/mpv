local M = {}

local draw = require 'draw'
local size = require 'size'
local spec = require 'spec'
local tags = require 'tags'
local tracks = require 'tracks'
local window = require 'window'

local fg = {}

local function width()
  return window.width()
end

local function y()
  return window.height()
end

local function height()
  return tracks.any 'video' and size.ui.height or size.ui.height * 2
end

function M.reset()
  fg = spec.default {
    color = { '000000', '000000', '000000', '000000' },
  }
end

function M.update()
  local h = height()
  fg.geo.width = width()
  fg.geo.y = y()
  fg.geo.height = h
  fg.border.size = h
  fg.blur = h
end

function M.osd()
  return tags.get(fg) .. draw.box(fg)
end

return M
