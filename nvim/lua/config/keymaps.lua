-- Add any keymaps that aren't related to a plugin here

-- This is set in root init.lua since it needs to be set before lazy
-- vim.g.mapleader = " "
vim.keymap.set("n", "<leader>f", vim.cmd.Ex)


--Center after moving up or down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
