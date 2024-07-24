local M = {}

local sections = { 'mouse buttons', 'mouse wheel' }
local subscriptions = {
  mouse_move = {},
  mbtn_left_down = {},
  mbtn_left_up = {},
  mbtn_right_down = {},
  mbtn_right_up = {},
  wheel_down = {},
  wheel_up = {},
}

local function on_leave()
  M.disable()
end

local function on(event)
  local x, y = mp.get_mouse_pos()
  if subscriptions[event] then
    for _, subscription in ipairs(subscriptions[event]) do
      subscription { x = x, y = y }
    end
  end
end

local function init()
  mp.set_key_bindings({
    { 'mouse_leave', on_leave },
    {
      'mouse_move',
      function()
        on 'mouse_move'
      end,
    },
  }, 'move', 'force')
  mp.enable_key_bindings('move', 'allow-vo-dragging+allow-hide-cursor')
  mp.set_key_bindings({
    {
      'mbtn_left',
      function()
        on 'mbtn_left_up'
      end,
      function()
        on 'mbtn_left_down'
      end,
    },
    {
      'mbtn_right',
      function()
        on 'mbtn_right_up'
      end,
      function()
        on 'mbtn_right_down'
      end,
    },
  }, 'mouse buttons', 'force')
  mp.set_key_bindings({
    {
      'wheel_down',
      function()
        on 'wheel_down'
      end,
    },
    {
      'wheel_up',
      function()
        on 'wheel_up'
      end,
    },
  }, 'mouse wheel', 'force')
end

init()

function M.events()
  return {
    'mouse_move',
    'mbtn_left_down',
    'mbtn_left_up',
    'mbtn_right_down',
    'mbtn_right_up',
    'wheel_down',
    'wheel_up',
  }
end

function M.subscribe(event, action)
  table.insert(subscriptions[event], action)
end

function M.enable()
  for _, section in ipairs(sections) do
    mp.enable_key_bindings(section)
  end
end

function M.disable()
  for _, section in ipairs(sections) do
    mp.disable_key_bindings(section)
  end
end

return M
