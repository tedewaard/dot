
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>f", vim.cmd.Ex)


--Center after moving up or down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
