local M = {}

local subscriptions = {}

function on_tick()
  for _, subscription in ipairs(subscriptions) do
    subscription()
  end
end

local function init()
  timer = mp.add_periodic_timer(0.5, on_tick)
end

init()

function M.subscribe(action)
  table.insert(subscriptions, action)
end

return M
