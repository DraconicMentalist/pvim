local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin', (os.getenv("PVIM") .. "/config/plugged/")) -- initialize plugins, install to a directory in this config folder.
-------------------
------ libraries
-------------------
-- Plenary adds a lot of library functionality for TUI-heavy plugins. One of those big libraries everything seems to use.
Plug("nvim-lua/plenary.nvim") --
-- library for parsing text being entered in command mode.
Plug("winston0410/cmd-parser.nvim")
-------------------
------ LSP and syntax highlighting
-------------------
--- treesitter does syntax highlighting, lspconfig handles language servers, mason is a package manager FOR language servers.
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })
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
-------------------
------ aesthetics
-------------------
----- themes
-- theme selection plugin.
Plug("zaldih/themery.nvim")
-- simple and uncontroversial
Plug("folke/tokyonight.nvim")


vim.call('plug#end')

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
--- treesitter settings
---------------------------
require 'nvim-treesitter.configs'.setup { highlight = { enable = true } }
---------------------------
--- mason setup
---------------------------
require("mason").setup()
require("mason-lspconfig").setup(
    {
        handlers = {
            function(server_name)
                require("lspconfig")[server_name].setup({})
            end
        }
    }
)

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
--
-- Themery Config
    require("themery").setup(
        {
            themes = {
                "tokyonight",
                "tokyonight-night",
                "tokyonight-storm",
                "tokyonight-moon",
            }, -- Your list of installed colorschemes.
            livePreview = true -- Apply theme while picking. Default to true.
        }
    )

