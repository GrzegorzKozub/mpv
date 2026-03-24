local M = {}

local align = require 'align'
local font = require 'font'
local size = require 'size'
local spec = require 'spec'
local tags = require 'tags'
local window = require 'window'

local fg = {}

local function x()
  return window.width() - 2 * size.margin - size.button
end

local function y()
  return window.height() - size.margin - 0.5 * size.label.height
end

local function text()
  local codec = string.upper(mp.get_property 'audio-codec-name' or '')
  local samplerate = mp.get_property_number 'audio-params/samplerate'
  local format = string.match(mp.get_property 'audio-params/format' or '', '%d+')
  local bitrate = mp.get_property_number 'audio-bitrate'
  local info = { codec }
  if samplerate then
    table.insert(info, math.floor(samplerate / 1000) .. ' kHz')
  end
  if format then
    table.insert(info, format .. '-bit')
  end
  if bitrate then
    table.insert(info, math.floor(bitrate / 1000 + 0.5) .. ' kbps')
  end
  return table.concat(info, ' · ')
end

function M.reset()
  fg = spec.default {
    geo = { align = align.middle.right },
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
