local M = {}

local mouse = require 'mouse'
local osd = require 'osd'
local timer = require 'timer'

local elements, shown = {}, false

local function events()
  for _, element in ipairs(elements) do
    if not element.handlers then
      goto continue
    end
    local handlers = element.handlers()
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
    require 'time',
    require 'audio',
    require 'subtitles',
    require 'full-screen',
  }
  for _, element in ipairs(elements) do
    if element.reset then
      element.reset()
    end
  end
  events()
  timer.subscribe(M.update)
end

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
  shown = true
end

function M.hide()
  osd.hide()
  shown = false
end

init()
M.update()

return M
