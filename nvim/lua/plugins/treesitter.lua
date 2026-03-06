local M = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = {"bash", "go", "css", "clojure", "tsx", "markdown", "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "rust" },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}


return { M }
