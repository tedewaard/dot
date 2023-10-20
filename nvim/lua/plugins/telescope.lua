return {
    'nvim-telescope/telescope.nvim', tag = '0.1.4',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
        { "<leader>sf", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "Find ltin.find_filesFiles"},
        { "<leader>gf", "<cmd>lua require('telescope.builtin').git_files()<cr>", desc = "Find git files"},
        { "<leader>lg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", desc = "Live grep for string"},
    }
}

-- To improve sorting performance I can install telescope-fzf-native.nvim
-- Live grep requires that ripgrep is installed
