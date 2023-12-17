local M = {}

local function copy(source)
  local target
  if type(source) == 'table' then
    target = {}
    for key, val in next, source, nil do
      target[copy(key)] = copy(val)
    end
    setmetatable(target, copy(getmetatable(source)))
  else
    target = source
  end
  return target
end

local function merge(a, b)
  if type(a) == 'table' and type(b) == 'table' then
    for k, v in pairs(b) do
      if type(v) == 'table' and type(a[k] or false) == 'table' then
        merge(a[k], v)
      else
        a[k] = v
      end
    end
  end
  return a
end

local default = {
  geo = { x = 0, y = 0, width = 0, height = 0, align = 7 },
  color = { 'ffffff', '000000', 'ffffff', '000000' },
  alpha = { 64, 0, 64, 0 },
  border = { size = 0, radius = 0 },
  blur = 0,
  font = { name = (require('env').win() and 'CaskaydiaCove NF' or 'monospace'), size = 32 },
}

function M.get(x)
  return merge(copy(default), x)
end

return M
