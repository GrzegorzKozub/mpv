local M = {}

local hitbox = require 'hitbox'
local size = require 'size'
local spec = require 'spec'
local tags = require 'tags'
local window = require 'window'

local fg = {}

local function x()
  -- return window.width() / 2
      return size.margin * 1.5
end

local function y()
  return window.height() - size.margin - size.button
end

local function text()
  return mp.get_property_bool 'pause' and '󰐊' or '󰏤'
end

local function hover(arg)
  if hitbox.hit(fg.geo, arg) then
    spec.hover(fg)
  else
    M.reset()
  end
end

local function play_pause(arg)
  if hitbox.hit(fg.geo, arg) then
    mp.commandv('cycle', 'pause')
  end
end

function M.reset()
  fg = spec.default {
    geo = { height = size.button, width = size.button },
    font = { size = size.button },
  }
end

function M.update()
  fg.geo.x = x()
  fg.geo.y = y()
end

function M.osd()
  return tags.get(fg) .. text()
end

function M.handlers()
  return {
    mouse_move = hover,
    mbtn_left_up = play_pause,
  }
end

return M
