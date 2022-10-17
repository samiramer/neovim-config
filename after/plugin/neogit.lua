local status_ok, g = pcall(require, "neogit")
if not status_ok then return end

enable_diffview = false

local status_dv, dv = pcall(require, "diffview")
if status_dv then enable_diffview = true end

g.setup{
  integrations = {
    diffview = enable_diffview
  }
}

