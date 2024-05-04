local win = require('env').win()

return {
  monospace = win and 'Cascadia Code NF' or 'monospace',
  sans_serif = win and 'Segoe UI Variable Display' or 'sans-serif'
}
