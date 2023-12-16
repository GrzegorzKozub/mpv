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
  geo = { x = x(), y = y(), width = 32, height = 32, align = 5 },
  color = { 'ffffff', '000000', '000000', '000000' },
  font = { name = require('env').win() and 'CaskaydiaCove NF' or 'monospace', size = 64 },
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
    mbtn_left_up = function(arg)
      if hitbox.hit(data.geo, arg) then
        mp.commandv('cycle', 'pause')
      end
    end,
  }
end

return M
