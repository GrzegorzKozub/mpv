local M = {}

local win = jit.os == 'Windows'

function M.win()
  return win
end

return M
