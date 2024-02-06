return {
  {
    -- The real fzf repository did something that caused their git history
    -- to change, and thus a fork was born.
    'wileychr/fzf',
    lazy = false,
    commit = '2707af403a106ddf864d9c2bae2c5e2f9b07b05f'
  },
  {
    -- The real fzf repository did something that caused their git history
    -- to change, and thus a fork was born.
    'wileychr/fzf.vim',
    lazy = false,
    commit = 'd5f1f8641b24c0fd5b10a299824362a2a1b20ae0'
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    -- v0.1.6 2023-02-05
    commit = '255e07ce2a05627d482d2de77308bba51b90470c'
  },
  {
    -- The completion engine itself is called nvim-cmp
    'hrsh7th/nvim-cmp',
    lazy = false,
    -- latest 2023-02-04
    commit = '04e0ca376d6abdbfc8b52180f8ea236cbfddf782'
  },
  {
    -- The cmp-nvim-lsp pulls in completions from nvim-lsp
    'hrsh7th/cmp-nvim-lsp',
    commit = '5af77f54de1b16c34b23cba810150689a3a90312'
  },
  {
    'hrsh7th/cmp-path',
    commit = '91ff86cd9c29299a64f968ebb45846c485725f23'
  },
  {
    'hrsh7th/cmp-nvim-lsp-signature-help',
    commit = '3d8912ebeb56e5ae08ef0906e3a54de1c66b92f1'
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = { }
  },
  {
    -- treesitter is a "parser generator tool" and parsing library:
    -- it is a C library that lets you "parse" the AST of many languages
    -- and interact with that parse tree.
    -- nvim-treesitter is the official integration of treesitter with nvim
    -- for intance to enable AST aware color schemes.
    'nvim-treesitter/nvim-treesitter',
    -- v0.9.0 2023-04
    -- commit = 'cc360a9beb1b30d172438f640e2c3450358c4086',
    -- v0.9.1 2023-12-01 latest tagged release
    -- commit = '63260da18bf273c76b8e2ea0db84eb901cab49ce',
    -- v0.9.2
    commit = 'f197a15b0d1e8d555263af20add51450e5aaa1f0',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
  },
  {
    -- This seems to provide the monokai theme.
    'ray-x/starry.nvim',
    commit = '9c4f8669acb302300e1495d4b1f1e618524a48f4'
  }
}
