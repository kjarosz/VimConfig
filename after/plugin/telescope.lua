local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set('n', '<leader>sg', builtin.git_files, { desc = "[S]earch [G]it files" })
vim.keymap.set('n', '<leader>sw', function() builtin.grep_string({ search = vim.fn.input(" Grep > ") }) end, { desc = "[S]earch [W]ord (Grep)" })

-- Slightly advanced example of overriding default behavior and theme
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })
