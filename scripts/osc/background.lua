local M = {}

local draw = require 'draw'
local tags = require 'tags'
local window = require 'window'

local function y()
  return window.height()
end

local function width()
  return window.width()
end

local function data()
  return {
    geo = { x = 0, y = y(), width = width(), height = 1, align = 7 },
    border = 128,
    blur = 128,
  }
end

function M.create()
  return {
    data = data(),
    update = function(self)
      self.data.geo.y = y()
      self.data.geo.width = width()
    end,
    osd = function(self)
      return tags.get(self.data) .. draw.box(self.data.geo.width, self.data.geo.height)
    end,
  }
end

return M
