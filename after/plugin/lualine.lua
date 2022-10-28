local status_ok, l = pcall(require, 'lualine')
if (not status_ok) then return end

l.setup {
    options = {
        component_separators = '',
        section_separators = '',
        theme = "catppuccin"
    },
    sections = {
        lualine_b = { { 'FugitiveHead' }, 'diff', 'diagnostics' },
        lualine_c = { { 'filename', file_status = true, path = 1 } },
    }
}
