-- Use this file as a template for building new modules for your config.
Plug = vim.fn['plug#']

function setup()
  vim.call('plug#begin', (basedir .. "/config/plugged/"))
  vim.call('plug#end')
end

return {
  setup = setup
}
