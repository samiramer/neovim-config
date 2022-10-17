local status, t = pcall(require, "telescope")
if (not status) then return end

t.setup()
t.load_extension('fzf')

local helpers = require('samer.helpers')

-- helpers.nnoremap("<leader>ff", ":lua require('telescope.builtin').find_files()<CR>")
-- helpers.nnoremap("<leader>fg", ":lua require('telescope.builtin').live_grep()<CR>")
-- helpers.nnoremap("<leader>fb", ":lua require('telescope.builtin').buffers()<CR>")
