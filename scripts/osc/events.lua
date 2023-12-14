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

local function mouse_input()
  mouse.on_move(function()
    local x, y = mp.get_mouse_pos()
    if x > 0 and x < window.width() and y > window.height() - 128 and y < window.height() then
      ui.show()
      require('timer').delay(3, ui.hide)
    else
      mouse.disable()
    end

  end)
end

function M.init()
  property_changes()
  mouse_input()
end

return M
