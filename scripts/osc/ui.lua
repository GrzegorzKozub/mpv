local M = {}

local mouse = require 'mouse'
local osd = require 'osd'
local time = require 'time'

local elements = {}
local shown = false

local function events()
  for _, element in ipairs(elements) do
    if not element.handlers then
      goto continue
    end
    local handlers = element.handlers()
    if handlers['time'] then
      time.subscribe(handlers['time'])
    end
    for _, event in ipairs(mouse.events()) do
      if handlers[event] then
        mouse.subscribe(event, handlers[event])
      end
    end
    ::continue::
  end
end

local function init()
  elements = {
    require 'background',
    require 'seek',
    require 'play-pause',
  }
  events()
end

init()

function M.update()
  for _, element in ipairs(elements) do
    if element.update then
      element.update()
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
      data = data .. element.osd() .. '\n'
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
