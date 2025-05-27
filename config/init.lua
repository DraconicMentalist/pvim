local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin', (os.getenv("PVIM") .. "config/plugged/"))
Plug('tpope/vim-sensible')
vim.call('plug#end')
print()
