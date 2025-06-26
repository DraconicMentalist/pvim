Plug = vim.fn['plug#']

function setup()
  vim.call('plug#begin', (basedir .. "/config/plugged/"))
  vim.call('plug#end')
end

return {
  setup = setup
}
