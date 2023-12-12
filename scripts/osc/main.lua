-- https://github.com/mpv-player/mpv/blob/master/DOCS/man/lua.rst
-- https://aegisub.org/docs/latest/ass_tags/

-- bug: mouse cursor does not hide

mp.commandv('set', 'osc', 'no')

local mouse = require 'mouse'
local osd = require 'osd'
local ui = require 'ui'
local window = require 'window'

-- todo: move from here
mp.observe_property('osd-dimensions', 'native', function()
  window.update()
  osd.setup()
  ui.update()
end)
mouse.on_move(function()
  ui.show()
  require('timer').delay(3, function()
    ui.hide()
  end)
end)
