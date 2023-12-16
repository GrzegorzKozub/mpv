local M = {}

local subscriptions = {
  mouse_move = {},
  mbtn_left_down = {},
  mbtn_left_up = {},
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
  }, 'click', 'force')
end

init()

function M.events()
  return { 'mouse_move', 'mbtn_left_down', 'mbtn_left_up' }
end

function M.subscribe(event, action)
  table.insert(subscriptions[event], action)
end

function M.enable()
  mp.enable_key_bindings 'click'
end

function M.disable()
  mp.disable_key_bindings 'click'
end

return M
