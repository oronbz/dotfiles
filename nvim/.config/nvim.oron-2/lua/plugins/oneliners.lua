return {
    -- one liner plugins
    {
	-- ssh yanking
	'ojroques/vim-oscyank',
    },
    {
	-- Git plugin
	'tpope/vim-fugitive',
    },
    {
	-- Show CSS Colors
	'brenoprata10/nvim-highlight-colors',
	config = function()
	    require('nvim-highlight-colors').setup({})
	end
    }
}
