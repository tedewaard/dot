return {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local fzf = require('fzf-lua')
        fzf.setup({
            files = {
                -- include hidden files, but not the .git dir
                fd_opts = [[--color=never --type f --type l --hidden --follow --exclude .git]],
                rg_opts = [[--color=never --files --hidden --follow -g "!.git"]],
            },
            grep = {
                -- search inside hidden files too, excluding the .git dir
                rg_opts = [[--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden -g "!.git" -e]],
            },
        })
        vim.keymap.set('n', '<leader>sf', fzf.files, { desc = "Find Files" })
        vim.keymap.set('n', '<leader>gf', fzf.git_files, { desc = "Find git files" })
        vim.keymap.set('n', '<leader>lg', fzf.grep_project, { desc = "Fuzzy search project contents" })
        vim.keymap.set('n', '<leader>sk', fzf.keymaps, { desc = "Search keymaps" })
        vim.keymap.set('n', '<leader>sw', function()
            fzf.files({
                cwd = "~/wiki",
            })
            end, { desc = "Find files in wiki directory"})
    end,
}
