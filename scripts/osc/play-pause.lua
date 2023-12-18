local M = {}

local hitbox = require 'hitbox'
local spec = require 'spec'
local tags = require 'tags'
local window = require 'window'

local function x()
  return window.width() / 2
end

local function y()
  return window.height() - 48
end

local function text()
  return mp.get_property_bool 'pause' and '󰐊' or '󰏤'
end

local fg = {}

local function reset()
  fg = spec.default {
    geo = { height = 32, width = 32, align = 5 },
    font = { size = 64 },
  }
end

reset()

function M.update()
  fg.geo.x = x()
  fg.geo.y = y()
end

function M.osd()
  return tags.get(fg) .. text()
end

function M.handlers()
  return {
    mouse_move = function(arg)
      if hitbox.hit(fg.geo, arg) then
        spec.hover(fg)
      else
        reset()
      end
    end,
    mbtn_left_up = function(arg)
      if hitbox.hit(fg.geo, arg) then
        mp.commandv('cycle', 'pause')
      end
    end,
  }
end

return M
