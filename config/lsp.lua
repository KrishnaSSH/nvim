if not pcall(require, "lspconfig") then
  return
end

local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>f", function()
    require("conform").format({ async = true, lsp_fallback = true })
  end, opts)

  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
end

local servers = {
  "pyright", "pylsp",
  "lua_ls",
  "ts_ls",
  "bashls",
  "jsonls",
  "yamlls",
  "html", "cssls",
  "gopls", "rust_analyzer", "clangd",
}

vim.diagnostic.config({
  virtual_text = false, -- removes inline messages
  signs = true,         -- removes the gutter signs (the H / E / W symbols)
  underline = true,     -- underline errors
  update_in_insert = true,
})

for _, server in ipairs(servers) do
  pcall(function()
    local config = { on_attach = on_attach }

    if server == "lua_ls" then
      config.settings = { Lua = { diagnostics = { globals = { "vim" } } } }
    end

    vim.lsp.config(server, config)
    vim.lsp.enable(server)
  end)
end
