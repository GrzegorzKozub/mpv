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

local function data()
  return {
    bg = {
      geo = { x = margin, y = y(), width = bg_width(), height = 8, align = 7 },
      alpha = { 196, 0, 0, 0 },
    },
    fg = {
      geo = { x = margin, y = y(), width = fg_width(), height = 8, align = 7 },
      alpha = { 64, 0, 0, 0 },
    },
  }
end

function M.create()
  return {
    data = data(),
    update = function(self)
      self.data.bg.geo.y = y()
      self.data.bg.geo.width = bg_width()
      self.data.fg.geo.y = y()
      self.data.fg.geo.width = fg_width()
    end,
    osd = function(self)
      return tags.get(self.data.bg)
        .. draw.box(self.data.bg.geo.width, self.data.bg.geo.height)
        .. '\n'
        .. tags.get(self.data.fg)
        .. draw.box(self.data.fg.geo.width, self.data.fg.geo.height)
    end,
    handlers = {
      mbtn_left_down = function(self, arg)
        if hitbox.hit(self.data.bg.geo, arg) then
          seek(arg.x)
          dragging = true
        end
      end,
      mouse_move = function(self, arg)
        if dragging then
          seek(arg.x)
        end
      end,
      mbtn_left_up = function(self, arg)
        dragging = false
      end,
    },
  }
end

return M
