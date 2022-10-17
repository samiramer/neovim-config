local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer, close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

return packer.startup(function(use)
  use { "wbthomason/packer.nvim" }

  use { "nvim-tree/nvim-tree.lua" }
  use { "nvim-tree/nvim-web-devicons" }
  use { "tpope/vim-surround" }
  use { "tpope/vim-repeat" }
  use { "tpope/vim-fugitive" }
  use { "tpope/vim-unimpaired" }
  use { "catppuccin/nvim", as = "catppuccin" }
  use { "christoomey/vim-tmux-navigator" }
  use { "folke/which-key.nvim" }
  use { "numToStr/Comment.nvim" }

  use {
    "nvim-treesitter/nvim-treesitter",
    run = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
  }

  use {
    "JoosepAlviste/nvim-ts-context-commentstring",
    requires = "nvim-treesitter/nvim-treesitter"
  }

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
    'nvim-telescope/telescope-fzf-native.nvim', 
    requires = { {'nvim-telescope/telescope.nvim'} },
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  }


  -- some git plugins
  use {
    'lewis6991/gitsigns.nvim',
    tag = 'release'
  }

  use {
    "TimUntersberger/neogit",
    requires = "nvim-lua/plenary.nvim"
  }

  use {
    "sindrets/diffview.nvim",
    requires = "nvim-lua/plenary.nvim"
  }

  use {
    "williamboman/mason-lspconfig.nvim",
    requires = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig"
    }
  }

  use {
    "samiramer/mason-null-ls.nvim",
    requires = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim"
    }
  }

end)
