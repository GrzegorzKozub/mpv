local M = {}

local audio, sub = {}, {}

function M.update()
  audio, sub = {}, {}
  local tracks = mp.get_property_native('track-list', {})
  for i = 1, #tracks do
    local type = tracks[i].type
    if type == 'unknown' or type == 'video' then
      goto continue
    end
    if type == 'audio' then
      table.insert(audio, tracks[i])
    end
    if type == 'sub' then
      table.insert(sub, tracks[i])
    end
    ::continue::
  end
end

function M.sub()
  return sub
end

function M.sub_current()
  if #sub == 0 then
    return nil
  end
  local curr = mp.get_property 'sub'
  return curr == 'no' and 'off' or sub[tonumber(curr)].lang
end

function M.sub_next()
  if #sub == 0 then
    return
  end
  local curr = mp.get_property 'sub'
  local new = curr == 'no' and 1 or tonumber(curr) == #sub and 'no' or tonumber(curr) + 1
  mp.commandv('set', 'sub', new)
end

function M.sub_prev()
  if #sub == 0 then
    return
  end
  local curr = mp.get_property 'sub'
  local new = curr == 'no' and #sub or tonumber(curr) == 1 and 'no' or tonumber(curr) - 1
  mp.commandv('set', 'sub', new)
end

return M
