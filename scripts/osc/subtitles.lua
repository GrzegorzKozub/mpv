local M = {}

local hitbox = require 'hitbox'
local size = require 'size'
local spec = require 'spec'
local tags = require 'tags'
local tracks = require 'tracks'
local window = require 'window'

local fg = {}

local function x()
  return window.width() - size.margin - size.button - 500
end

local function y()
  return window.height() - size.margin - size.button
end

local function text()
  local sb = tracks.sub_current()
  return sb and '󰨗' .. sb or ''
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
    tracks.sub_next()
  end
end
local function play_pause2(arg)
  if hitbox.hit(fg.geo, arg) then
    tracks.sub_prev()
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
    mbtn_right_up = play_pause2,
    wheel_up = play_pause,
    wheel_down = play_pause2,
  }
end

return M
