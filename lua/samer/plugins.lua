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
    -- core stuff
    use { "wbthomason/packer.nvim" }
    use { "nvim-tree/nvim-tree.lua" }
    use { "nvim-tree/nvim-web-devicons" }
    use { "tpope/vim-surround" }
    use { "tpope/vim-repeat" }
    use { "tpope/vim-fugitive" }
    use { "tpope/vim-unimpaired" }
    use { "ojroques/vim-oscyank" }
    use { "catppuccin/nvim", as = "catppuccin" }
    use { "christoomey/vim-tmux-navigator" }
    use { "folke/which-key.nvim" }
    use { "numToStr/Comment.nvim" }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    -- vimwiki
    use {
        "vimwiki/vimwiki",
        config = function()
            vim.cmd [[
                let g:vimwiki_list = [{'path': '~/Notes/', 'syntax': 'markdown', 'ext': '.md'}]
                let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
                let g:vimwiki_markdown_link_ext = 1
            ]]
        end
    }

    -- syntax stuff
    use {
        "nvim-treesitter/nvim-treesitter",
        run = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
    }
    use {
        "JoosepAlviste/nvim-ts-context-commentstring",
        requires = "nvim-treesitter/nvim-treesitter"
    }

    -- telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use {
        'nvim-telescope/telescope-fzf-native.nvim',
        requires = { { 'nvim-telescope/telescope.nvim' } },
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

    -- lsp stuff
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
    use {
        "glepnir/lspsaga.nvim",
        branch = "main",
        requires = "neovim/nvim-lspconfig"
    }
    use { "hrsh7th/nvim-cmp" }
    use {
        "hrsh7th/cmp-nvim-lsp",
        requires = {
            "hrsh7th/nvim-cmp",
            "neovim/nvim-lspconfig"
        }
    }
    use { "hrsh7th/cmp-buffer", requires = "hrsh7th/nvim-cmp" }
    use { "hrsh7th/cmp-path", requires = "hrsh7th/nvim-cmp" }
    use { "hrsh7th/cmp-cmdline", requires = "hrsh7th/nvim-cmp" }
    use { "saadparwaiz1/cmp_luasnip", requires = "L3MON4D3/LuaSnip" }

end)
