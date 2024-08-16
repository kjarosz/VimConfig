vim.lsp.set_log_level("debug")

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  local function map(mode, keys, action, desc)
    opts["desc"] = desc
    vim.keymap.set(mode, keys, action, opts)
  end

  map("n", "gd", function() vim.lsp.buf.definition() end, "[G]o to [D]efinition")
  map("n", "K", function() vim.lsp.buf.hover() end, "Open hover menu")
  map("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, "[V]iew [W]orkspace [S]ymbol")
  map("n", "<leader>vd", function() vim.diagnostic.open_float() end, "[V]iew [D]iagnostic")
  map("n", "[d", function() vim.diagnostic.goto_next() end, "Next [d]iagnostic")
  map("n", "]d", function() vim.diagnostic.goto_prev() end, "Previous [d]iagnostic")
  map("n", "<leader>va", function() vim.lsp.buf.code_action() end, "[V]iew [C]ode [A]ctions")
  map("n", "<leader>vrr", function() vim.lsp.buf.references() end, "[V]iew [R]efe[r]ences")
  map("n", "<leader>rn", function() vim.lsp.buf.rename() end, "[R]e[n]ame")
  map("i", "<C-h>", function() vim.lsp.buf.signature_help() end, "Signature [H]elp")
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {'tsserver', 'rust_analyzer'},
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
  }
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp'},
    {name = 'nvim_lua'},
  },
  formatting = lsp_zero.cmp_format(),
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
})
