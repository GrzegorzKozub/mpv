local M = {}

local mouse = require 'mouse'
local osd = require 'osd'

local elements = {}
local shown = false

local function events()
  for _, event in ipairs(mouse.events()) do
    for _, element in ipairs(elements) do
      if element.handlers and element.handlers[event] then
        mouse.subscribe(event, function(arg)
          element.handlers[event](element, arg)
        end)
      end
    end
  end
end

local function init()
  elements = {
    require('background').create(),
    require('seek').create(),
    require('play-pause').create(),
  }
  events()
end

init()

function M.update()
  for _, element in ipairs(elements) do
    if element.update then
      element:update()
    end
  end
  if shown then
    M.show()
  end
end

function M.show()
  local data = ''
  for _, element in ipairs(elements) do
    if element.osd then
      data = data .. element:osd() .. '\n'
    end
  end
  osd.show(data)
  mouse.enable()
  shown = true
end

function M.hide()
  osd.hide()
  mouse.disable()
  shown = false
end

return M
