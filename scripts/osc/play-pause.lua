local M = {}

local hitbox = require 'hitbox'
local tags = require 'tags'
local window = require 'window'

local function x()
  return window.width() / 2
end

local function y()
  return window.height() - 64
end

local function text()
  return mp.get_property_bool 'pause' and '󰐊' or '󰏤'
end

local function data()
  return {
    geo = { x = x(), y = y(), width = 32, height = 32, align = 5 },
    color = { 'ffffff', '000000', '000000', '000000' },
    border = 0,
    font = { name = 'monospace', size = 64 },
    text = text(),
  }
end

function M.create()
  return {
    data = data(),
    update = function(self)
      self.data.geo.x = x()
      self.data.geo.y = y()
      self.data.text = text()
    end,
    osd = function(self)
      return tags.get(self.data) .. self.data.text
    end,
    handlers = {
      mbtn_left_up = function(self, arg)
        if hitbox.hit(self.data.geo, arg) then
          mp.commandv('cycle', 'pause')
        end
      end,
    },
  }
end

return M
