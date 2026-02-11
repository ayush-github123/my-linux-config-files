-- ========================
-- BASIC SETTINGS
-- ========================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.g.mapleader = " "

-- ========================
-- LOAD lazy.nvim
-- ========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- ========================
-- PLUGINS
-- ========================
require("lazy").setup({
  "nvim-lua/plenary.nvim",

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
--   {
--   "rest-nvim/rest.nvim",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--   },
-- },
 {
  "j-hui/fidget.nvim",
  opts = {},
},
 
  {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- file icons
  },
},

  -- v{
  --   "nvim-treesitter/nvim-treesitter",
  --   build = ":TSUpdate"
  -- },

  "windwp/nvim-autopairs",
  "numToStr/Comment.nvim",
  -- LSP installer
  "williamboman/mason.nvim",

  -- LSP config
  "neovim/nvim-lspconfig",

  -- Autocomplete
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",

  -- Snippets
  "L3MON4D3/LuaSnip",

  -- Theme
  "catppuccin/nvim",

})

-- ========================
-- THEME (Catppuccin)
-- ========================

require("catppuccin").setup({
    flavour = "macchiato", -- latte, frappe, macchiato, mocha
    integrations = {
        telescope = true,
        treesitter = true,
        cmp = true,
        gitsigns = true,
        lsp_trouble = true,
        native_lsp = {
            enabled = true,
        },
    },
})

vim.cmd("colorscheme catppuccin")
vim.cmd([[highlight Normal guibg=NONE]])
vim.cmd([[highlight NormalFloat guibg=NONE]])



-- ========================
-- PLUGIN SETUP
-- ========================
require("nvim-autopairs").setup()
require("Comment").setup()

-- ========================
-- LSP SETUP
-- ========================

-- Mason (LSP installer)
require("mason").setup()

-- LSP config
--local lspconfig = require("lspconfig")

-- Enable LSP servers (we'll install them via Mason)
--lspconfig.clangd.setup({})
--lspconfig.gopls.setup({})

-- ========================
-- LSP SETUP (nvim 0.11+)
-- ========================

require("mason").setup()

vim.lsp.enable("clangd")
vim.lsp.enable("pyright")
vim.lsp.enable("gopls")


-- Register LSP servers using Neovim core API
vim.lsp.config("clangd", {
  cmd = { "clangd" },
})

vim.lsp.config("gopls", {
  cmd = { "gopls" },
})

-- ========================
-- FILE EXPLORER (nvim-tree)
-- ========================

require("nvim-tree").setup({
  view = {
    width = 30,
    side = "left",
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})

-- ========================
-- API TESTING (rest.nvim)
-- ========================
--
-- require("rest-nvim").setup({
--   result_split_horizontal = false,
--   result_split_in_place = false,
--   skip_ssl_verification = false,
--   encode_url = true,
-- })


-- ========================
-- LSP KEYBINDINGS
-- ========================

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = { buffer = event.buf, noremap = true, silent = true }

    -- Navigation
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

    -- Refactoring
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

    -- Diagnostics
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
    -- Toggle file tree (VS Code style)
    vim.keymap.set("n", "<C-e>", ":NvimTreeToggle<CR>", { silent = true })
  
end,
})



-- ========================
-- AUTOCOMPLETE (nvim-cmp)
-- ========================

local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),

  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
})

