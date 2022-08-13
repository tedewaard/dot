local Remap = require("tedewaard.keymap")
local nnoremap = Remap.nnoremap

--ctrl+s will allow my to do a fuzzy search across the current file
nnoremap("<C-s>", function()
    require('telescope.builtin').current_buffer_fuzzy_find({sorting_strategy='ascending', prompt_position='top'})
end)
