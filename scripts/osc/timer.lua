local M = {}

local timer, subscriptions = nil, {}

local function on_tick()
  for _, subscription in ipairs(subscriptions) do
    subscription()
  end
end

function M.subscribe(action)
  table.insert(subscriptions, action)
end

function M.start()
  if not timer then
    timer = mp.add_periodic_timer(0.5, on_tick)
  end
end

function M.stop()
  if timer then
    timer:kill()
    timer = nil
  end
end

return M
