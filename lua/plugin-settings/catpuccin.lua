local status_ok, colorizer = pcall(require, "colorizer")
if not status_ok then
  return
end

vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha

require("catppuccin").setup()
