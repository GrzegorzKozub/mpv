local M = {}

local align = require 'align'
local font = require 'font'
local size = require 'size'
local spec = require 'spec'
local tags = require 'tags'
local window = require 'window'

local fg = {}

local function x()
  return window.width() / 2
end

local function y()
  return window.height() - 2 * size.margin - size.button - 32
end

local function text()
  local title = mp.get_property 'media-title' or ''
  local artist = mp.get_property 'metadata/by-key/Artist' or ''
  return artist ~= '' and title .. ' - ' .. artist or title
end

function M.reset()
  fg = spec.default {
    geo = { align = align.bottom.center },
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
