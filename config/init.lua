Plug = vim.fn['plug#']

--- Removing any of this will break the config. So uh, don't.
Basedir = os.getenv("PVIM")
Instance = os.getenv("PVIM_INSTANCE")

for _, name in ipairs({ "config", "data", "state", "cache" }) do
    vim.env[("XDG_%s_HOME"):format(name:upper())] = Basedir .. "/clutter/" .. Instance .. "/" .. name
end
------------------------------------------------------------

--- add any new modules here.
Modules = require("modules")

local function plug_install()
vim.call('plug#begin', (Basedir .. "/" .. "/clutter/" .. Instance .. "/plugged")) -- initialize plugins, install to a directory in this config folder.

-------------------
------ libraries
-------------------
-- Plenary adds a lot of library functionality for TUI-heavy plugins. One of those big libraries everything seems to use.
Plug("nvim-lua/plenary.nvim") --
-- library for parsing text being entered in command mode.
Plug("winston0410/cmd-parser.nvim")
Plug("nvim-tree/nvim-web-devicons") ---
-------------------
------ LSP and syntax highlighting
-------------------
--- treesitter does syntax highlighting, lspconfig handles language servers, mason is a package manager FOR language servers.
Plug("nvim-treesitter/nvim-treesitter")
Plug("neovim/nvim-lspconfig")
Plug("mason-org/mason.nvim")
Plug("williamboman/mason-lspconfig.nvim")
-------------------
------ code completion
-------------------
--- nvim-cmp does code completion, the different plugins specify the sources it pulls from.
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/nvim-cmp')
-------------------
------ telescope
-------------------
--- one of the most popular plugins. provides TUI searches for a variety of things. There'll be a set of hotkeys for it further down.
Plug("nvim-telescope/telescope.nvim", {["tag"] = "0.1.8"}) -- D: plenary
Plug("nvim-telescope/telescope-file-browser.nvim") -- D: plenary, telescope
-------------------
------ other
-------------------
--- sane and sensible presets for neovim
Plug('tpope/vim-sensible')
-- nice little inline diagnostics plugin.
Plug("rachartier/tiny-inline-diagnostic.nvim")
-- adds a togglable file tree.
Plug("nvim-tree/nvim-tree.lua")
-- shows possible keycombos when you press a key that has modifiers.
Plug("folke/which-key.nvim") --
-- shows the range you're affecting when you run a command on a selection of text. Indespensable.
Plug("pipoprods/range-highlight.nvim") -- D: cmd-parser | Pulling from a fork until a specific bug is fixed
-- switcher for buffers, themes, tabpages, and marks
Plug("toppair/reach.nvim")
-- very important. sets the working directory to the root of whatever project you're working on, usually the root of the git repo.
Plug('ahmedkhalf/project.nvim')

for i in pairs(Modules) do
  Modules[i].plug_install()
end

vim.call('plug#end')
end


local function config_plugins()
--------------------------------------------------------
------------ settings
--------------------------------------------------------
--- basic tweaks
    vim.opt.termguicolors = true -- better colors, a whole 24 bits!
    vim.opt.signcolumn = "yes" -- enables the side gutter. Shows errors and git changes and shit.

    --- number settings
    vim.wo.number = true -- enable number column on left side
    vim.o.cursorline = true -- highlights the line the cursor is on.

    --- tabs
    vim.opt.tabstop = 2 -- Number of spaces a tab character represents
    vim.opt.shiftwidth = 2 -- Number of spaces for auto-indentation
    vim.opt.expandtab = true -- Use spaces instead of tabs
    vim.opt.softtabstop = 2 -- Spaces per tab key press

    --- line breaks
    vim.opt.conceallevel = 2 -- controls how concealed text is displayed.
    vim.opt.linebreak = true -- activates text wrap
    vim.opt.breakindent = true -- makes wrapped lines match indentation    
---------------------------
--- lsp config
---------------------------
 --- I'll be real, I have no idea what the next three lines do. But it seems important so I'm pasting it here and not touching it.
local lspconfig_defaults = require("lspconfig").util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend("force", lspconfig_defaults.capabilities,
require("cmp_nvim_lsp").default_capabilities())

vim.api.nvim_create_autocmd("LspAttach",
    {
        desc = "LSP actions",
        callback = function(event)
            local opts = { buffer = event.buf }
            vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts) -- rename variable or function or whatever
            vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts) -- runs a formatter over the buffer
            vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts) -- shows available code actions
        end
    }
)


---------------------------
--- mason setup
---------------------------
require("mason").setup()
require("mason-lspconfig").setup(
    {
        automatic_enable = true,
        handlers = {
            function(server_name)
                require("lspconfig")[server_name].setup({})
            end
        }
    }
)
---------------------------
--- treesitter settings
---------------------------
local parser_dir = Basedir .. "/clutter/treesitter/"

local TSconfig = require("nvim-treesitter.configs")
TSconfig.setup({
  ensure_installed = {"markdown", "markdown_inline", "yaml", 'gdscript'},
  highlight = {
      enable = true,
      additional_vim_regex_highlighting = false
  },
      indent = {enable = true}
})


---------------------------
--- completion setup
---------------------------
local cmp = require("cmp")
cmp.setup(
    {
        sources = {
            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "path" },
        }
    }
)

cmp.setup(
    {
        mapping = {
            -- Navigate between completion items
            ["<S-Tab>"] = cmp.mapping.select_next_item({ behavior = "select" }),
            ["<C-Tab>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
            ["<Tab>"] = cmp.mapping.confirm({ select = true }),
            -- Scroll up and down in the completion documentation
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-d>"] = cmp.mapping.scroll_docs(4)
        },
        snippet = {
            expand = function(args)
                vim.snippet.expand(args.body)
            end
        }
    }
)

------------------------
--- minimally configured
------------------------
require('reach').setup({
  notifications = true
})
require("tiny-inline-diagnostic").setup()
require("range-highlight").setup()
require("project_nvim").setup()
require("nvim-tree").setup({
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true
  },
})

if vim.g.neovide then
    local font_size = 9
    local function set_neovide_text_size(mod)
        font_size = font_size + mod
        vim.o.guifont = string.format("FiraCode Nerd Font:h%s", font_size)
    end
    vim.o.guifont = string.format("FiraCode Nerd Font:h%s", font_size)
    --- Copy and Paste
    vim.keymap.set("v", "<C-S-c>", '"+y') -- Copy
    vim.keymap.set("n", "<C-S-v>", 'a<space><ESC>"+P') -- Paste normal mode
    vim.keymap.set("v", "<C-S-v>", 'a<space><ESC>"+P') -- Paste visual mode
    vim.keymap.set("c", "<C-S-v>", "<C-R>+") -- Paste command mode
    vim.keymap.set("i", "<C-S-v>", '<ESC>l"+Pli') -- Paste insert mode
    vim.keymap.set(
        {"n", "i", "v"},
        "<C-+>",
        function()
            set_neovide_text_size(1)
        end,
        {desc = "increase text size"}
    )
    vim.keymap.set(
        {"n", "i", "v"},
        "<C-_>",
        function()
            set_neovide_text_size(-1)
        end,
        {desc = "decrease text size"}
    )
    --- Padding
    vim.g.neovide_padding_top = 20
    vim.g.neovide_padding_bottom = 0
    vim.g.neovide_padding_right = 10
    vim.g.neovide_padding_left = 10
    --- Transparency
    vim.g.neovide_opacity = 0.95
    vim.g.neovide_normal_opacity = 0.95
    --- Animation
    vim.g.neovide_position_animation_length = 0.10
    vim.g.neovide_scroll_animation_length = 0.10
    vim.g.neovide_cursor_animation_length = 0.025
end
end

local function config_modules()
  for i in pairs(Modules) do
    Modules[i].config()
  end
end

do --- initialization
  plug_install()
  config_plugins()
  config_modules()
end
