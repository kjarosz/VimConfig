local opts = {buffer = bufnr, remap = false}

local function map(mode, keys, action, desc)
  opts["desc"] = desc
  vim.keymap.set(mode, keys, action, opts)
end

map("n", "gd", function() vim.lsp.buf.definition() end, "[G]o to [D]efinition")
map("n", "go", function() vim.lsp.buf.type_definition() end, "Show type definition")
map("n", "K", function() vim.lsp.buf.hover() end, "Open hover menu")
map("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, "[V]iew [W]orkspace [S]ymbol")
map("n", "<leader>vd", function() vim.diagnostic.open_float() end, "[V]iew [D]iagnostic")
map("n", "[d", function() vim.diagnostic.goto_next() end, "Next [d]iagnostic")
map("n", "]d", function() vim.diagnostic.goto_prev() end, "Previous [d]iagnostic")
map("n", "<leader>va", function() vim.lsp.buf.code_action() end, "[V]iew [C]ode [A]ctions")
map("n", "<leader>vrr", function() vim.lsp.buf.references() end, "[V]iew [R]efe[r]ences")
map("n", "<leader>rn", function() vim.lsp.buf.rename() end, "[R]e[n]ame")
map("i", "<C-h>", function() vim.lsp.buf.signature_help() end, "Signature [H]elp")
require('lspconfig').jdtls.setup(config)

require('java').setup()
require('nvim-lspconfig').jdtls.setup({})
