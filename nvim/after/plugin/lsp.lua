local Remap = require("tedewaard.keymap")
local nnoremap = Remap.nnoremap



local capabilities = require('cmp_nvim_lsp').default_capabilities()
require'lspconfig'.gopls.setup{
    capabilities = capabilities,
    on_attach = function()
    nnoremap("K", vim.lsp.buf.hover, {buffer=0})
    nnoremap("gd", vim.lsp.buf.definition, {buffer=0})
    nnoremap(" ge", vim.diagnostic.goto_next, {buffer=0})
    nnoremap("<leader>r", vim.lsp.buf.rename, {buffer=0})
        
    end,
}

-- LSP Autocomplete stuff below:

vim.opt.completeopt={"menu", "menuone", "noselect"}

  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })



