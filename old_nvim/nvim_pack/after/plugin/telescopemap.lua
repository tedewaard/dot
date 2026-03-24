local builtin = require('telescope.builtin')
--ctrl+s will allow me to do a fuzzy search across the current file
--vim.keymap.set('n', '<C-s>', builtin.current_buffer_fuzzy_find, {}) --Not Working
--Find files in current working directory
vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
--Find files in current git directory
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})

