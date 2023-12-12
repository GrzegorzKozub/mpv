local M = {}

local subscriptions = {}

local function on_move()
  if subscriptions['mouse_move'] then
    subscriptions['mouse_move']()
  end
end

local function on_click(event)
  local x, y = mp.get_mouse_pos()
  if subscriptions[event] then
    subscriptions[event] { x = x, y = y }
  end
end

local function init()
  mp.set_key_bindings({ { 'mouse_move', on_move } }, '_move_', 'force')
  mp.enable_key_bindings('_move_', 'allow-vo-dragging+allow-hide-cursor')
  mp.set_key_bindings({
    {
      'mbtn_left',
      function()
        on_click 'mbtn_left_up'
      end,
      function()
        on_click 'mbtn_left_down'
      end,
    },
    {
      'mbtn_right',
      function()
        on_click 'mbtn_right_up'
      end,
      function()
        on_click 'mbtn_right_down'
      end,
    },
  }, '_button_', 'force')
  mp.enable_key_bindings '_button_'
end

init()

function M.on_move(action)
  M.subscribe('mouse_move', action)
end

function M.subscribe(event, action)
  subscriptions[event] = action
end

return M
