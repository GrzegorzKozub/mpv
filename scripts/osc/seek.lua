local M = {}

local draw = require 'draw'
local hitbox = require 'hitbox'
local tags = require 'tags'
local window = require 'window'

local dragging = false
local margin = 16

local function y()
  return window.height() - 96 - margin
end

local function bg_width()
  return window.width() - 2 * margin
end

local function fg_width()
  return (mp.get_property_number 'percent-pos' or 0) * bg_width() / 100
end

local function bg_percent(x)
  return math.min(math.max((x - margin) / bg_width() * 100, 0), 100)
end

local function seek(x)
  mp.commandv('seek', bg_percent(x), 'absolute-percent')
  require('ui').update()
end

local bg = {
  geo = { x = margin, y = y(), width = bg_width(), height = 8, align = 7 },
  alpha = { 196, 0, 0, 0 },
}

local fg = {
  geo = { x = margin, y = y(), width = fg_width(), height = 8, align = 7 },
  alpha = { 64, 0, 0, 0 },
}

function M.update()
  bg.geo.y = y()
  bg.geo.width = bg_width()
  fg.geo.y = y()
  fg.geo.width = fg_width()
end

function M.osd()
  return tags.get(bg)
      .. draw.box(bg.geo.width, bg.geo.height)
      .. '\n'
      .. tags.get(fg)
      .. draw.box(fg.geo.width, fg.geo.height)
end

function M.handlers()
  return {
    mbtn_left_down = function(arg)
      if hitbox.hit(bg.geo, arg) then
        seek(arg.x)
        dragging = true
      end
    end,
    mouse_move = function(arg)
      if dragging then
        seek(arg.x)
      end
    end,
    mbtn_left_up = function(arg)
      dragging = false
    end,
  }
end

return M
