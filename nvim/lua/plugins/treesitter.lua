return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function ()
        require('nvim-treesitter.configs').setup({
            ensure_installed = {
                "bash", "go", "css", "clojure", "tsx", "markdown", "markdown_inline",
                "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "rust",
            },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
          })
    end,
}
