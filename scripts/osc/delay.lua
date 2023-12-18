local M = {}

local elapsed, callback, timer = 0, nil, nil

local function reset()
  if timer then
    timer:kill()
    timer = nil
    elapsed = 0
  end
end

local function tick()
  elapsed = elapsed + 1
  if elapsed >= 3 then
    if callback then
      callback()
    end
    reset()
  end
end

function M.restart(action)
  reset()
  callback = action
  timer = mp.add_periodic_timer(1, tick)
end

return M
