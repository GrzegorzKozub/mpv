local M = {}

local mouse = require 'mouse'
local osd = require 'osd'

local elements = {}
local shown = false

local function init()
  elements = {
    require('background').create(),
    require('play-pause').create(),
  }

  -- todo: move from here
  mp.observe_property('pause', 'bool', function()
    elements[2]:update()
    if shown then
      M.show()
    end
  end)
  for _, event in ipairs { 'mbtn_left_up' } do
    for _, element in ipairs(elements) do
      if element.handlers and element.handlers[event] then
        mouse.subscribe(event, function(arg)
          element.handlers[event](element, arg)
        end)
      end
    end
  end
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
  shown = true
end

function M.hide()
  osd.hide()
  shown = false
end

return M
