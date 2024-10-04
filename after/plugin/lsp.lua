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


local local_cap = vim.lsp.protocol.make_client_capabilities()
local util = require 'lspconfig.util'
local_cap.offsetEncoding = { "utf-16" }

local root_files = {
	'.clangd',
	'.clang-tidy',
	'.clang-format',
	'compile_commands.json',
	'compile_flags.txt',
	'build.sh', -- buildProject
	'configure.ac', -- AutoTools
	'run',
	'compile',
}

local function get_clangd_path()
	local current_dir = vim.fn.getcwd()
	if current_dir:find("/esp") then
		return vim.fn.getenv("HOME") .. "/Documents/STU/LS/TP/esp-clang/bin/clangd"
	else
		return "clangd"
	end
end

-- TODO: add clang-tidy to on_atach with clangd
local clangd_opts = {
	cmd = { get_clangd_path(),
		"--all-scopes-completion",
		"--background-index",
		"--clang-tidy",
		"--compile_args_from=filesystem", -- lsp-> does not come from compie_commands.json
		"--completion-parse=always",
		"--completion-style=bundled",
		"--cross-file-rename",
		"--debug-origin",
		"--enable-config", -- clangd 11+ supports reading from .clangd configuration file
		"--fallback-style=Qt",
		"--folding-ranges",
		"--function-arg-placeholders",
		"--header-insertion=iwyu",
		"--pch-storage=memory", -- could also be disk
		"--suggest-missing-includes",
		"-j=4",		-- number of workers
		-- "--resource-dir="
		"--log=error",
		--[[ "--query-driver=/usr/bin/g++", ]]
	},
	filetypes = { "c", "cpp", "objc", "objcpp" },
	root_dir = function(fname)
			return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
		end,
	single_file_support = true,
	init_options = {
		compilationDatabasePath = vim.fn.getcwd() .. "/build",
	},
	capabilities = local_cap,
	commands = {

	},
}



require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {},
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      lspConfig = require('lspconfig')
      lspConfig.lua_ls.setup(lua_opts)
      lspConfig.clangd.setup(clangd_opts)
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
