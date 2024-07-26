local M = {}

local mouse = require 'mouse'
local osd = require 'osd'
local timer = require 'timer'
local tracks = require 'tracks'

local added, elements, shown = {}, {}, false

local function add(name, element)
  if require('util').contains(added, name) then
    return
  end
  if element.reset then
    element.reset()
  end
  if element.handlers then
    local handlers = element.handlers()
    for _, event in ipairs(mouse.events()) do
      if handlers[event] then
        mouse.subscribe(event, handlers[event])
      end
    end
  end
  table.insert(added, name)
  table.insert(elements, element)
end

local function init()
  add('background', require 'background') -- must be first
  add('seek', require 'seek')
  add('play', require 'play')
  add('chapter', require 'chapter')
  add('time', require 'time')
  add('panscan', require 'panscan')
  add('fullscreen', require 'fullscreen')
  timer.subscribe(M.update)
end

function M.update()
  for _, element in pairs(elements) do
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

function M.tracks()
  if tracks.any 'sub' then
    add('subtitles', require 'subtitles')
  end
  if tracks.any 'audio' then
    add('audio', require 'audio')
  end
end

init()
M.update()

return M
