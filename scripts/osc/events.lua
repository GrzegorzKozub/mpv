local M = {}

local delay = require 'delay'
local osd = require 'osd'
local mouse = require 'mouse'
local size = require 'size'
local timer = require 'timer'
local ui = require 'ui'
local window = require 'window'

local function property_change()
  mp.observe_property('osd-dimensions', 'native', function()
    window.update()
    osd.setup()
    ui.update()
  end)
  mp.observe_property('pause', 'native', ui.update)
  -- mp.observe_property('percent-pos', 'number', ui.update)
end

local function mouse_in_active_area(arg)
  return arg.x > 0 and arg.x < window.width() and arg.y > window.height() - size.ui.height and arg.y < window.height()
end

local function mouse_move()
  mouse.subscribe('mouse_move', function(arg)
    if mouse_in_active_area(arg) then
      ui.update()
      ui.show()
      mouse.enable()
      timer.start()
      delay.restart(function()
        ui.hide()
        mouse.disable()
        timer.stop()
      end)
    else
      mouse.disable()
    end
  end)
end

function M.init()
  property_change()
  mouse_move()
end

return M
