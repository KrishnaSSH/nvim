local opt = vim.opt
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.opt.termguicolors = true
vim.cmd.colorscheme("habamax")
vim.opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50"

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 10
opt.sidescrolloff = 10
opt.signcolumn = "yes"
opt.showmode = false
opt.laststatus = 2
opt.statusline = [[%f %h%m%r%=%l,%c %P]]

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.completeopt = "menuone,noinsert,noselect"
opt.pumheight = 10

opt.backup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.updatetime = 300
opt.timeoutlen = 500

opt.mouse = "a"
opt.clipboard:append("unnamedplus")
opt.splitbelow = true
opt.splitright = true
opt.hidden = true

opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99

vim.g.mapleader = " "

keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

keymap("n", "<leader>bd", ":bdelete<CR>", opts)
keymap("n", "<leader>bn", ":bnext<CR>", opts)
keymap("n", "<leader>bp", ":bprevious<CR>", opts)

keymap("n", "<leader>hs", ":nohlsearch<CR>", opts)

keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("n", "<A-j>", ":m .+1<CR>==", opts)
keymap("n", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
keymap("n", "<Space><Space>", function() require("telescope.builtin").find_files() end, opts)
keymap("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, opts)
keymap("n", "<leader>ft", function()
  local Terminal = require("toggleterm.terminal").Terminal
  local terminal = Terminal:new({ size = math.ceil(vim.o.lines * 0.4), direction = "horizontal" })
  terminal:toggle()
end, opts)

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("TrimWhitespace", { clear = true }),
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("AutoReload", { clear = true }),
  callback = function()
    vim.cmd("checktime")
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("RestoreCursor", { clear = true }),
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 1 and line <= vim.fn.line("$") then
      vim.cmd("normal! g'\"")
    end
  end,
})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})

local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
for type, icon in pairs(signs) do
  vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type })
end
