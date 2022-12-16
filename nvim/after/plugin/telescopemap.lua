local builtin = require('telescope.builtin')
--ctrl+s will allow me to do a fuzzy search across the current file
--vim.keymap.set('n', '<C-s>', builtin.current_buffer_fuzzy_find, {})
vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<C-s>', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });

end)
