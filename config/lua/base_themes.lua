Plug = vim.fn['plug#']

function config()
    vim.cmd('colorscheme tokyonight')
end

function plug_install()
  print('running theme setup!')
  -- simple and uncontroversial
  Plug("folke/tokyonight.nvim")
end

return {
  config = config,
  plug_install = plug_install
}
