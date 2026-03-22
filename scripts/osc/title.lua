local M = {}

local align = require 'align'
local font = require 'font'
local size = require 'size'
local spec = require 'spec'
local tags = require 'tags'
local tracks = require 'tracks'
local window = require 'window'

local fg = {}

local seek_height = 8

local function x()
  return size.margin
end

local function y()
  return window.height() - 2 * size.margin - size.button - seek_height - size.margin
end

function M.reset()
  fg = spec.default {
    geo = { align = align.bottom.left },
    font = { name = font.sans_serif, size = size.label.font },
  }
end

function M.update()
  fg.geo.x = x()
  fg.geo.y = y()
end

function M.osd()
  if tracks.any 'video' then
    return ''
  end
  local title = mp.get_property 'media-title' or ''
  local artist = mp.get_property 'metadata/by-key/Artist' or ''
  local text = artist ~= '' and title .. ' - ' .. artist or title
  return tags.get(fg) .. text
end

return M
