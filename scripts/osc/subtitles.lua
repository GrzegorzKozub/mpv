local M = {}

local hitbox = require 'hitbox'
local size = require 'size'
local spec = require 'spec'
local tags = require 'tags'
local window = require 'window'

local fg = {}

local function x()
  return window.width() - size.margin - size.button - 500
end

local function y()
  return window.height() - size.margin - size.button
end

local tracks_osc = {}
local tracks_mpv = {}
local d = 'x'

local function update_tracklist()
  local tracktable = mp.get_property_native('track-list', {})

  -- by osc_id
  tracks_osc.video, tracks_osc.audio, tracks_osc.sub = {}, {}, {}
  -- by mpv_id
  tracks_mpv.video, tracks_mpv.audio, tracks_mpv.sub = {}, {}, {}
  for n = 1, #tracktable do
    if tracktable[n].type ~= 'unknown' then
      local type = tracktable[n].type
      local mpv_id = tonumber(tracktable[n].id)

      -- by osc_id
      table.insert(tracks_osc[type], tracktable[n])

      -- by mpv_id
      tracks_mpv[type][mpv_id] = tracktable[n]
      tracks_mpv[type][mpv_id].osc_id = #tracks_osc[type]
      if type == 'audio' then d = 'd' end
    end
  end
end

update_tracklist()

local function text()
update_tracklist()
  local type = 'sub'


  -- handle no audio or sub
  local sb = '󰨗' .. tracks_osc[type][tonumber(mp.get_property(type))].lang

 sb = sb .. ' / 󰓃' .. tracks_osc['audio'][tonumber(mp.get_property('audio'))].lang
  return sb
end

local function hover(arg)
  if hitbox.hit(fg.geo, arg) then
    spec.hover(fg)
  else
    M.reset()
  end
end

local function play_pause(arg)
  if hitbox.hit(fg.geo, arg) then
    mp.commandv('cycle', 'fullscreen')
  end
end

function M.reset()
  fg = spec.default {
    geo = { height = size.button, width = size.button },
    font = { size = size.button },
  }
end

function M.update()
  fg.geo.x = x()
  fg.geo.y = y()
end

function M.osd()
  return tags.get(fg) .. text()
end

function M.handlers()
  return {
    mouse_move = hover,
    mbtn_left_up = play_pause,
  }
end

return M
