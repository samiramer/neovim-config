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
    local mode = "%-5{%v:lua.string.upper(v:lua.vim.fn.mode())%}"
    local file_name = "%f"
    local buf_nr = "[%n]"
    local modified = " %-m"
    local right_align = "%="
    local gitsigns = "%{get(b:,'gitsigns_status','')} "
    local git = "%{get(b:, 'gitsigns_head', '')} "
    local file_type = "%y "
    local line_no = "%10([%l,%v/%L%)]"

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
