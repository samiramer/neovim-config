local status_ok, t = pcall(require, "nvim-tree")
if not status_ok then return end

t.setup {
    disable_netrw = true,
    hijack_netrw = true,
    filters = {
        dotfiles = false,
    },
    view = {
        width = 60,
        float = {
            enable = true,
            open_win_config = {
                width = 80
            }
        }
    },
    renderer = {
        indent_markers = {
            enable = true
        }
    },
    update_focused_file = {
        enable = true
    }
}

local helpers = require('samer.helpers')

helpers.nnoremap("<leader>e", ":NvimTreeToggle<CR>")

-- this closes neovim if the nvim-tree buffer is the last one open
vim.api.nvim_exec(
    [[
    autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
  ]] ,
    false
)
