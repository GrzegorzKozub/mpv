local M = {}

local chapters = require 'chapters'
local mouse = require 'mouse'
local osd = require 'osd'
local timer = require 'timer'
local tracks = require 'tracks'
local util = require 'util'

local names, elements, shown = {}, {}, false

local function reg(name)
  local element = require(name)
  if util.contains(names, name) then
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
  table.insert(names, name)
  table.insert(elements, element)
end

local function init()
  local layers = {
    [1] = { 'background' },
    [2] = {
      'seek',
      'play',
      'time',
      'panscan',
      'fullscreen',
    },
  }
  for _, layer in ipairs(layers) do
    for _, name in ipairs(layer) do
      reg(name)
    end
  end
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

function M.chapters()
  if chapters.any() then
    reg 'chapter'
  end
end

function M.tracks()
  if tracks.any 'audio' then
    reg 'audio'
  end
  if tracks.any 'sub' then
    reg 'subtitles'
  end
end

init()
M.update()

return M
