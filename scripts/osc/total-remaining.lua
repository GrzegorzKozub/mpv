local M = {}

local font = require 'font'
local hitbox = require 'hitbox'
local size = require 'size'
local spec = require 'spec'
local tags = require 'tags'
local window = require 'window'

local property = 'duration'
local fg = {}

local function y()
  return window.height() - size.margin - size.button / 2
end

local function text()
  return mp.format_time(mp.get_property_number(property) or 0)
end

local function hover(arg)
  if hitbox.hit(fg.geo, arg) then
    spec.hover(fg)
  else
    M.reset()
  end
end

local function total_remaining(arg)
  if hitbox.hit(fg.geo, arg) then
    property = property == 'duration' and 'time-remaining' or 'duration'
  end
end

function M.reset()
  fg = spec.default {
    geo = { x = size.margin * 1.5 + size.time.width, width = size.time.width, height = size.time.height, align = 4 },
    font = { name = font.sans_serif, size = 40 },
  }
end

function M.update()
  fg.geo.y = y()
end

function M.osd()
  return tags.get(fg) .. text()
end

function M.handlers()
  return {
    mouse_move = hover,
    mbtn_left_up = total_remaining,
  }
end

return M
