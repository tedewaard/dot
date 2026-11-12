return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main branch does not support lazy-loading
    build = ":TSUpdate",
    config = function ()
        local ts = require('nvim-treesitter')
        ts.setup()
        ts.install({
            "bash", "go", "css", "clojure", "tsx", "markdown", "markdown_inline",
            "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "rust",
        })

        -- main no longer enables highlight/indent itself; start it per buffer
        -- for any filetype that has a parser installed.
        vim.api.nvim_create_autocmd('FileType', {
            group = vim.api.nvim_create_augroup('tedewaard_treesitter', { clear = true }),
            callback = function (args)
                if pcall(vim.treesitter.start, args.buf) then
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}
