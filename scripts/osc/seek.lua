local M = {}

local draw = require 'draw'
local hitbox = require 'hitbox'
local size = require 'size'
local spec = require 'spec'
local tags = require 'tags'
local window = require 'window'

local zoomed, dragging = false, false
local fg, bg = {}, {}

local function height()
  return (zoomed or dragging) and 12 or 8
end

local function bg_width()
  return window.width() - 2 * size.margin
end

local function fg_width()
  return (mp.get_property_number 'percent-pos' or 0) * bg_width() / 100
end

local function y()
  return window.height() - 2 * size.margin - size.button - height() + ((zoomed or dragging) and 2 or 0)
end

local function percent(x)
  return math.min(math.max((x - size.margin) / bg_width() * 100, 0), 100)
end

local function hover(arg)
  if hitbox.hit(bg.geo, arg) then
    spec.hover(fg)
  else
    M.reset()
  end
end

local function zoom(arg)
  if hitbox.hit(bg.geo, arg) or dragging then
    if not zoomed then
      zoomed = true
      require('ui').update()
    end
  else
    if zoomed then
      zoomed = false
      require('ui').update()
    end
  end
end

local function seek(x)
  mp.commandv('seek', percent(x), 'absolute-percent')
  require('ui').update()
end

function M.reset()
  fg = spec.default {
    geo = { x = size.margin },
    border = { radius = 4 },
  }
  bg = spec.default {
    geo = { x = size.margin },
    alpha = { 196, 0, 0, 0 },
    border = { radius = 4 },
  }
end

function M.update()
  for _, data in ipairs { fg, bg } do
    data.geo.height = height()
    data.geo.y = y()
  end
  fg.geo.width = fg_width()
  bg.geo.width = bg_width()
end

function M.osd()
  return tags.get(bg) .. draw.box(bg) .. '\n' .. tags.get(fg) .. draw.box(fg)
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
      hover(arg)
      zoom(arg)
      if dragging then
        seek(arg.x)
      end
    end,
    mbtn_left_up = function()
      dragging = false
    end,
  }
end

return M
