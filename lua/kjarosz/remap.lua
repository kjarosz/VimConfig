vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", ":NERDTree<CR>", { desc = "[P]roject tree [V]iew" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move select text down" })
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv", { desc = "Move select text up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "[J]oin with next line" })

vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "[P]aste over" })

vim.keymap.set("n", "<leader>y", "\"+y", { desc = "[Y]ank to system clipboard" })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "[Y]ank to system clipboard" })
vim.keymap.set("n", "<leader>Y", "\"+y", { desc = "[Y]ank to system clipboard" })

vim.keymap.set("n", "<leader>d", "\"_d", { desc = "[D]elete without replacing buffer" })
vim.keymap.set("v", "<leader>d", "\"_d", { desc = "[D]elete without replacing buffer" })

vim.keymap.set("n", "<leader>t", ":!printTodos<CR>", { desc = "Scan files for and print [T]odos" })

--vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
