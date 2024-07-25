local M = {}

local tracks = { audio = {}, sub = {} }

function M.update()
  tracks.audio, tracks.sub = {}, {}
  local track_list = mp.get_property_native('track-list', {})
  for i = 1, #track_list do
    local type = track_list[i].type
    if type == 'unknown' or type == 'video' then
      goto continue
    end
    table.insert(tracks[type], track_list[i])
    ::continue::
  end
end

function M.any(type)
  return #tracks[type] ~= 0
end

function M.current(type)
  if #tracks[type] == 0 then
    return ''
  end
  local curr = mp.get_property(type)
  return curr == 'no' and 'off' or tracks[type][tonumber(curr)].lang
end

function M.next(type)
  if #tracks[type] == 0 then
    return
  end
  local curr = mp.get_property(type)
  local new = curr == 'no' and 1
    or tonumber(curr) == #tracks[type] and 'no'
    or tonumber(curr) + 1
  mp.commandv('set', type, new)
end

function M.prev(type)
  if #tracks[type] == 0 then
    return
  end
  local curr = mp.get_property(type)
  local new = curr == 'no' and #tracks[type]
    or tonumber(curr) == 1 and 'no'
    or tonumber(curr) - 1
  mp.commandv('set', type, new)
end

return M
