local M = {}

local align = require 'align'
local font = require 'font'
local hitbox = require 'hitbox'
local size = require 'size'
local spec = require 'spec'
local tags = require 'tags'
local tracks = require 'tracks'
local window = require 'window'

local label_width = 48
local icon, label = {}, {}

local function icon_x()
  return window.width()
    - size.margin
    - size.spacing
    - 1.5 * size.button
    - label_width
    + size.fix.icon_label
end

local function label_x()
  return window.width() - size.margin - size.spacing - size.button - label_width
end

local function icon_y()
  return window.height() - size.margin - 0.5 * size.button
end

local function label_y()
  return window.height() - size.margin - 0.5 * 48 - 4
end

local function text()
  local curr = tracks.current 'sub'
  return curr and curr or ''
end

local function hit(arg)
  return hitbox.hit(icon.geo, arg) or hitbox.hit(label.geo, arg)
end

local function hover(arg)
  if hit(arg) then
    spec.hover(icon)
    spec.hover(label)
  else
    M.reset()
  end
end

local function next(arg)
  if hit(arg) then
    tracks.next 'sub'
  end
end

local function previous(arg)
  if hit(arg) then
    tracks.prev 'sub'
  end
end

function M.reset()
  icon = spec.default {
    geo = { width = size.button, height = size.button, align = align.middle.center },
  }
  label = spec.default {
    geo = { width = label_width, height = size.button, align = align.middle.left },
    font = { name = font.sans_serif, size = size.label.height },
  }
end

function M.update()
  icon.geo.x = icon_x()
  icon.geo.y = icon_y()
  label.geo.x = label_x()
  label.geo.y = label_y()
end

function M.osd()
  return tags.get(icon) .. '󰨗' .. '\n' .. tags.get(label) .. text()
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
