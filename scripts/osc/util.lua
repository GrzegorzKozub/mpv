local M = {}

function M.copy(source)
  local target
  if type(source) == 'table' then
    target = {}
    for key, val in next, source, nil do
      target[M.copy(key)] = M.copy(val)
    end
    setmetatable(target, M.copy(getmetatable(source)))
  else
    target = source
  end
  return target
end

function M.merge(a, b)
  if type(a) == 'table' and type(b) == 'table' then
    for key, val in pairs(b) do
      if type(val) == 'table' and type(a[key] or false) == 'table' then
        M.merge(a[key], val)
      else
        a[key] = val
      end
    end
  end
  return a
end

return M
