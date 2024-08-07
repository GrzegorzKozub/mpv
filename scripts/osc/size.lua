local win = require('env').win()
local button_label_align = 4

return {
  ui = { height = 128 },
  margin = 16,
  button = 64,
  label = {
    width = 32,
    height = 64 - button_label_align,
    font = win and 32 or 48,
    closer_to_button = 8,
  },
}
