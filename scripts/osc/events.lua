local M = {}

local osd = require 'osd'
local mouse = require 'mouse'
local ui = require 'ui'
local window = require 'window'

local function property_changes()
  mp.observe_property('osd-dimensions', 'native', function()
    window.update()
    osd.setup()
    ui.update()
  end)
  mp.observe_property('pause', 'bool', ui.update)
end

local function mouse_in_active_area(arg)
  return arg.x > 0 and arg.x < window.width() and arg.y > window.height() - 128 and arg.y < window.height()
end

local function mouse_move()
  mouse.subscribe('mouse_move', function(arg)
    if mouse_in_active_area(arg) then
      ui.show()
      require('timer').delay(3, ui.hide)
    else
      mouse.disable()
    end
  end)
end

function M.init()
  property_changes()
  mouse_move()
end

return M
