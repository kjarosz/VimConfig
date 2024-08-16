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
