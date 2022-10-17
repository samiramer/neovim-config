local status, t = pcall(require, "telescope")
if (not status) then return end

t.setup()
t.load_extension('fzf')
