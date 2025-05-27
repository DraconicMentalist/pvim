local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin', (os.getenv("PVIM") .. "config/plugged/"))
Plug('tpope/vim-sensible')
Plug("nvim-treesitter/nvim-treesitter", {["do"] = ":TSUpdate"})
Plug("mason-org/mason.nvim")
vim.call('plug#end')

require'nvim-treesitter.configs'.setup{highlight={enable=true}}
require("mason").setup()
