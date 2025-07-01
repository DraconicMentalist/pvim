-- Use this file as a template for building new modules for your config.
Plug = vim.fn['plug#']

function config()
  require('orgmode').setup({
  org_agenda_files = '~/.local/orgfiles/**/*',
  org_default_notes_file = '~/.local/orgfiles/refile.org',
 })
end

function plug_install()
  Plug('nvim-orgmode/orgmode')
end

return {
  config = config,
  plug_install = plug_install
}
