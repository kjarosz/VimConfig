local home = os.getenv("HOME")
local workspace_dir = home .. '/Workspace'

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local data_path = workspace_dir .. '/' .. project_name

local mason_home = home .. '/.local/share/nvim/mason'
local jdtls_home = mason_home .. '/packages/jdtls'
local config = {
    cmd = {
      'java', -- Java 11+
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.protocol=true',
      '-Dlog.level=ALL',
      '-javaagent:' .. jdtls_home .. '/lombok.jar',
      '-Xmx1g',
      '--add-modules=ALL-SYSTEM',
      '--add-opens', 'java.base/java.util=ALL-UNNAMED',
      '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
      '-jar', jdtls_home .. '/plugins/org.eclipse.equinox.launcher_1.6.800.v20240330-1250.jar',
      '-configuration', jdtls_home .. 'config_mac_arm',
      '-data', data_path
    },
    root_dir = function() vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]) end,
}

print("LSP Zero attached")
vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
vim.keymap.set("n", "go", function() vim.lsp.buf.type_definition() end, opts)
vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
require('lspconfig').jdtls.setup(config)
