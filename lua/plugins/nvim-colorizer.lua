return {
	{
		"NvChad/nvim-colorizer.lua",
		event = { "BufReadPost", "BufNewFile" },
    config = function (_, opts)
      require('colorizer').setup(opts)
    end
	},
}
