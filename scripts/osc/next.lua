local M = {}

local align = require 'align'
local hitbox = require 'hitbox'
local playlist = require 'playlist'
local size = require 'size'
local spec = require 'spec'
local tags = require 'tags'
local window = require 'window'

local fg = {}

local function y()
  return window.height() - size.margin - 0.5 * size.button
end

local function hover(arg)
  if hitbox.hit(fg.geo, arg) then
    spec.hover(fg)
  else
    M.reset()
  end
end

local function next(arg)
  if hitbox.hit(fg.geo, arg) then
    playlist.next()
  end
end

function M.reset()
  fg = spec.default {
    geo = {
      x = size.margin + 1.5 * size.button,
      width = size.button,
      height = size.button,
      align = align.middle.center,
    },
  }
end

function M.update()
  fg.geo.y = y()
end

function M.osd()
  return playlist.has_next() and tags.get(fg) .. '󰒭' or ''
end

function M.handlers()
  return { mouse_move = hover, mbtn_left_up = next }
end

return M
