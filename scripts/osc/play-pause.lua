local M = {}

local hitbox = require 'hitbox'
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

local data = {
  geo = { width = 32, height = 32, align = 5 },
  alpha = { 64, 0, 64, 0 },
  font = { size = 64 },
}

function M.update()
  data.geo.x = x()
  data.geo.y = y()
end

function M.osd()
  return tags.get(data) .. text()
end

function M.handlers()
  return {
    mouse_move = function(arg)
      if hitbox.hit(data.geo, arg) then
        data.alpha[1] = 0
        data.border = { size = 2 }
        data.blur = 10
      else
        data.alpha[1] = 64
        data.border = nil
        data.blur = 0
      end
    end,
    mbtn_left_up = function(arg)
      if hitbox.hit(data.geo, arg) then
        mp.commandv('cycle', 'pause')
      end
    end,
  }
end

return M
