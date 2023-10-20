vim.g.mapleader = " " -- Make sure to set 'mapleader' before lazy so your mappings are correct
require("config.options")
require("config.lazy")

-- Not fully confident in how this autocmd gets triggered
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        require("config.autocmds")
        require("config.keymaps")
    end,
})
