-- vim.lsp.set_log_level("debug")

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  local function map(mode, key, action, desc)
    local opts = {buffer = bufnr, remap = false, desc = desc}
    vim.keymap.set(mode, key, action, opts)
  end

  map("n", "gd", function() vim.lsp.buf.definition() end, "Go to definition")
  map("n", "K", function() vim.lsp.buf.hover() end, "Show hover text")
  map("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, "View Workspace Symbol")
  map("n", "<leader>vd", function() vim.diagnostic.open_float() end, "View diagnostics")
  map("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  map("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  map("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  map("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  map("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  map("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
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

-- Fix for invalid mod_cache in gopls. see: https://github.com/neovim/nvim-lspconfig/issues/2733
local util = require'lspconfig.util'
require'lspconfig'.gopls.setup {
   root_dir = function(fname)
      -- see: https://github.com/neovim/nvim-lspconfig/issues/804
      local mod_cache = vim.trim(vim.fn.system 'go env GOMODCACHE')
      if fname:sub(1, #mod_cache) == mod_cache then
         local clients = vim.lsp.get_active_clients { name = 'gopls' }
         if #clients > 0 then
            return clients[#clients].config.root_dir
         end
      end
      return util.root_pattern 'go.work'(fname) or util.root_pattern('go.mod', '.git')(fname)
   end,
}
