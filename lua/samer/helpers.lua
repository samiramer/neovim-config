local M = {}

local function bind(op, outer_opts)
    outer_opts = outer_opts or { noremap = true }
    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force",
            outer_opts,
            opts or {}
        )
        vim.keymap.set(op, lhs, rhs, opts)
    end
end

M.nmap = bind("n", { noremap = false })
M.nnoremap = bind("n")
M.vnoremap = bind("v")
M.xnoremap = bind("x")
M.inoremap = bind("i")

M.status_line = function()
    -- use catppuccin colors if possible
    local catppuccin_ok, _ = pcall(require, 'catppuccin')
    if (catppuccin_ok) then
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = function()
                local colors = require 'catppuccin.palettes'.get_palette()
                -- do something with colors
                vim.api.nvim_set_hl(0, 'StatusLine', { fg = colors.text, bg = colors.base })
                vim.api.nvim_set_hl(0, 'StatusLineNC', { fg = colors.text, bold = true })
            end
        })
    end

    local mode = "[%.2{%v:lua.string.upper(v:lua.vim.fn.mode())%}]"
    local file_name = "%1*[%f]"
    local buf_nr = "[%n]"
    local modified = " %-m"
    local right_align = "%="
    local file_type = "%y "
    local line_no = "%10([%l:%v-%L%)]"

    local gitsigns = "%{get(b:,'gitsigns_status','')}"
    gitsigns = "[" .. gitsigns .. "]"

    local git = "%{get(b:, 'gitsigns_head', '')}"
    git = "[" .. git .. "]"

    return string.format(
        "%s%s%s%s%s%s%s%s%s",
        mode,
        file_name,
        buf_nr,
        modified,
        right_align,
        gitsigns,
        git,
        file_type,
        line_no
    )
end

return M
