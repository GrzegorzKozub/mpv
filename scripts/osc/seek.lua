local M = {}

local draw = require 'draw'
local tags = require 'tags'
local window = require 'window'

local function y()
  return window.height() - 96 - 8
end

local function width()
  return window.width() - 32
end

local function data()
  return {
    geo = { x = 16, y = y(), width = width(), height = 8, align = 7 },
    alpha = { 196, 0, 0, 0 },
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
