local M = {}

local draw = require 'draw'
local hitbox = require 'hitbox'
local mouse = require 'mouse'
local osd = require 'osd'
local tags = require 'tags'
local window = require 'window'

local elements = {}

local function background()
  local data = function()
    return {
      geo = { x = 0, y = window.height(), width = window.width(), height = 1, align = 7 },
      color = { '000000', '000000', '000000', '000000' },
      alpha = { 0, 0, 0, 0 },
      border = 128,
      blur = 128,
      font = { name = '', size = 0 },
    }
  end
  return {
    data = data(),
    update = function(self)
      self.data = data()
    end,
    osd = function(self)
      return tags.get(self.data) .. draw.box(self.data.geo.width, self.data.geo.height)
    end,
    hitbox = function(self)
      return hitbox.get(self.data.geo)
    end,
    handlers = {},
  }
end

function M.init()
  elements = { background(), require('play-pause').create() }
  mp.observe_property('pause', 'bool', function()
    elements[2]:update()
    M.redraw()
  end)
  for _, event in ipairs { 'mbtn_left_up' } do
    for _, element in ipairs(elements) do
      if element.handlers[event] then
        mouse.subscribe(event, function(arg)
          element.handlers[event](element, arg)
        end)
      end
    end
  end
end

function M.refresh()
  for _, element in ipairs(elements) do
    if element.update then
      element:update()
    end
  end
end

function M.redraw()
  osd.update(elements[1]:osd() .. '\n' .. elements[2]:osd() .. '\n')
end

return M
