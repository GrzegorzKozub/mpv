local M = {}

local align = require 'align'
local font = require 'font'
local hitbox = require 'hitbox'
local size = require 'size'
local spec = require 'spec'
local tags = require 'tags'
local tracks = require 'tracks'
local window = require 'window'

local button_fg, label_fg = {}, {}

local function button_x()
  return window.width()
    - 4 * size.margin
    - 2.5 * size.button
    - 2 * size.label.width
    + size.label.closer_to_button
end

local function button_y()
  return window.height() - size.margin - 0.5 * size.button
end

local function label_x()
  return window.width() - 4 * size.margin - 2 * size.button - 2 * size.label.width
end

local function label_y()
  return window.height() - size.margin - 0.5 * size.label.height
end

local function label_text()
  return tracks.current 'audio'
end

local function hit(arg)
  return hitbox.hit(button_fg.geo, arg) or hitbox.hit(label_fg.geo, arg)
end

local function hover(arg)
  if hit(arg) then
    spec.hover(button_fg)
    spec.hover(label_fg)
  else
    M.reset()
  end
end

local function next(arg)
  if hit(arg) then
    tracks.next 'audio'
  end
end

local function previous(arg)
  if hit(arg) then
    tracks.prev 'audio'
  end
end

function M.reset()
  button_fg = spec.default {
    geo = { width = size.button, height = size.button, align = align.middle.center },
  }
  label_fg = spec.default {
    geo = { width = size.label.width, height = size.button, align = align.middle.left },
    font = { name = font.sans_serif, size = size.label.font },
  }
end

function M.update()
  button_fg.geo.x = button_x()
  button_fg.geo.y = button_y()
  label_fg.geo.x = label_x()
  label_fg.geo.y = label_y()
end

function M.osd()
  return tracks.any 'audio'
      and tags.get(button_fg) .. '󰓃' .. '\n' .. tags.get(label_fg) .. label_text()
    or ''
end

function M.handlers()
  return {
    mouse_move = hover,
    mbtn_left_up = next,
    mbtn_right_up = previous,
    wheel_down = next,
    wheel_up = previous,
  }
end

return M
