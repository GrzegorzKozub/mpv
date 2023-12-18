local M = {}

local draw = require 'draw'
local hitbox = require 'hitbox'
local spec = require 'spec'
local tags = require 'tags'
local window = require 'window'

local margin, zoomed, dragging = 16, false, false

local function y()
  return window.height() - 96 - margin - ((zoomed or dragging) and 2 or 0)
end

local function bg_width()
  return window.width() - 2 * margin
end

local function fg_width()
  return (mp.get_property_number 'percent-pos' or 0) * bg_width() / 100
end

local function height()
  return (zoomed or dragging) and 12 or 8
end

local function percent(x)
  return math.min(math.max((x - margin) / bg_width() * 100, 0), 100)
end

local function zoom_in()
  if not zoomed then
    zoomed = true
    require('ui').update()
  end
end

local function zoom_out()
  if zoomed then
    zoomed = false
    require('ui').update()
  end
end

local function seek(x)
  mp.commandv('seek', percent(x), 'absolute-percent')
  require('ui').update()
end

local fg, bg = {}, {}

local function reset()
  fg = spec.default {
    geo = { x = margin },
    border = { radius = 4 },
  }
  bg = spec.default {
    geo = { x = margin },
    alpha = { 196, 0, 0, 0 },
    border = { radius = 4 },
  }
end

reset()

function M.update()
  for _, data in ipairs { bg, fg } do
    data.geo.y = y()
    data.geo.height = height()
  end
  bg.geo.width = bg_width()
  fg.geo.width = fg_width()
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
      if hitbox.hit(bg.geo, arg) then
        spec.hover(fg)
      else
        reset()
      end
      if hitbox.hit(bg.geo, arg) or dragging then
        zoom_in()
      else
        zoom_out()
      end
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
