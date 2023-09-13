return {
  -- Load telescope
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-live-grep-args.nvim'
    },
    keys = {
      { '<leader>ff', function() require('telescope.builtin').find_files() end,  desc = 'Find files' },
      { '<leader>fb', function() require('telescope.builtin').buffers() end,     desc = 'Find Buffers' },
      { '<leader>fg', function() require('telescope.builtin').git_status() end,  desc = 'Find Opened Git Files' },
      { '<leader>fh', function() require('telescope.builtin').help_tags() end,   desc = 'Find Help' },
      { '<leader>fc', function() require('telescope.builtin').grep_string() end, desc = 'Find Word In Files' },
      { '<leader>fd', function() require('telescope.builtin').diagnostics() end, desc = 'Find Diagnostics' },
      { '<leader>fk', function() require('telescope.builtin').keymaps() end,     desc = 'Find Keymaps' },
      { '<leader>ft', function() require('telescope.builtin').colorscheme({enable_preview=true}) end,     desc = 'Switch colorscheme' },
      {
        '<leader>fw',
        function() require('telescope').extensions.live_grep_args.live_grep_args() end,
        desc = 'Find by Grep'
      },
      {
        '<leader>f/',
        function()
          require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end,
        desc = 'Fuzzy find in current buffer'
      },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup{
        path_display = { "truncate " },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          }
        },
        defaults = {
          layout_config = {
            horizontal = {
              height = 0.95,
              preview_cutoff = 60,
              width = 0.95
            },
          }
        }
      }

      telescope.load_extension('fzf')
      telescope.load_extension('live_grep_args')
    end,
  },
}
