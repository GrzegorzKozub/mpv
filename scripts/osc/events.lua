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
    ui.show()
    require('timer').delay(3, ui.hide)
  end)
end

function M.init()
  property_changes()
  mouse_input()
end

return M
