local win = require('env').win()

return {
  monospace = win and 'CaskaydiaCove NF' or 'monospace',
  sans_serif = win and 'Segoe UI Variable Display' or 'sans-serif'
}
