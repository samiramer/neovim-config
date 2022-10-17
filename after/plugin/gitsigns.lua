local status_ok, g = pcall(require, "gitsigns")
if not status_ok then return end

g.setup()
