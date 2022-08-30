local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local fg = '#C9CCCD'
local bg = '#082F3B'

local colors = {
  color0 = '#D0D6B5',
  color1 = '#172030',
  color2 = '#FFAE8F',
  color3 = '#B87EA2',
  color4 = '#1E2A3E',
  color5 = '#4B2234',
  color6 = '#73A7A7',
}

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = " ", warn = " " },
  colored = false,
  update_in_insert = false,
  always_visible = true,
}

local diff = {
  "diff",
  colored = false,
  symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width
}

local filetype = {
  "filetype",
  icons_enabled = false,
  icon = nil,
}

local filename = {
  "filename",
  path = 1
}

lualine.setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    -- theme = {
    --   normal = {
    --     a = { fg = colors.color1, bg = colors.color6, gui = 'bold', separator = colors.color0 },
    --     b = { fg = fg, bg = colors.color4 },
    --     c = { fg = fg, bg = colors.color4 },
    --     x = { fg = fg, bg = colors.color4 },
    --     y = { fg = fg, bg = colors.color4 },
    --     z = { fg = fg, bg = colors.color4 },
    --   },
    --   insert = {
    --     a = { fg = colors.color1, bg = colors.color0, gui = 'bold', separator = colors.color0 },
    --   },
    --   visual = {
    --     a = { fg = colors.color1, bg = colors.color2, gui = 'bold', separator = colors.color0 },
    --   },
    --   command = {
    --     a = { fg = colors.color1, bg = colors.color3, gui = 'bold', separator = colors.color0 },
    --   },
    --   replace = {
    --     a = { fg = colors.color2, bg = colors.color5, gui = 'bold', separator = colors.color0 },
    --   },
    --   inactive = {
    --     c = { fg = fg, bg = colors.color4 },
    --   }
    -- },
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { filename },
    lualine_c = {},
    -- lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_x = { 'location', 'progress', "encoding", filetype },
    lualine_y = { diff, diagnostics },
    lualine_z = { 'branch' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
})
