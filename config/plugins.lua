vim.pack.add({
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/akinsho/toggleterm.nvim",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/saghen/blink.cmp",
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/stevearc/conform.nvim",
})

local function packadd(name)
  pcall(function() vim.cmd("packadd " .. name) end)
end

packadd("lualine.nvim")
packadd("nvim-tree.lua")
packadd("plenary.nvim")
packadd("telescope.nvim")
packadd("toggleterm.nvim")
packadd("nvim-treesitter")
packadd("nvim-lspconfig")
packadd("mason.nvim")
packadd("blink.cmp")
packadd("LuaSnip")
packadd("conform.nvim")

if pcall(require, "lualine") then
  require("lualine").setup({
    options = {
      icons_enabled = false,
      theme = "auto",
      component_separators = { left = "|", right = "|" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = { "filename" },
      lualine_x = { "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  })
end
if pcall(require, "nvim-tree") then
  require("nvim-tree").setup({ view = { width = 25 } })
end

if pcall(require, "telescope") then
  require("telescope").setup({
    defaults = {
      layout_strategy = "horizontal",
      layout_config = { horizontal = { preview_width = 0.5 } },
    },
  })
end

if pcall(require, "toggleterm") then
  require("toggleterm").setup({
    size = function() return math.ceil(vim.o.lines * 0.4) end,
    direction = "horizontal",
    start_in_insert = true,
  })
end

if pcall(require, "nvim-treesitter.configs") then
  require("nvim-treesitter.configs").setup({
    ensure_installed = { "lua", "python", "javascript", "typescript", "bash", "json", "html", "css", "yaml" },
    highlight = { enable = true },
    indent = { enable = true },
  })
end

if pcall(require, "mason") then
  require("mason").setup()
end

if pcall(require, "conform") then
  require("conform").setup({
    formatters_by_ft = {
      python = { "black", "autopep8", "yapf" },
      lua = { "stylua" },
      javascript = { "prettier", "eslint_d" },
      typescript = { "prettier", "eslint_d" },
      json = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      yaml = { "prettier" },
      bash = { "shfmt" },
      go = { "gofmt" },
      rust = { "rustfmt" },
      c = { "clang-format" },
      cpp = { "clang-format" },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  })
end

if pcall(require, "blink.cmp") then
  require("blink.cmp").setup({
    keymap = { preset = "default" },
    appearance = { use_nvim_cmp_as_default = true },
    signature = { enabled = true },
  })
end
