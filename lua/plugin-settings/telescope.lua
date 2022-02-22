local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local t = require'telescope'

t.setup()
t.load_extension('fzf')
