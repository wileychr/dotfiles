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
    -- coq is an extremely fast auto-complete implementation for nvim
    'ms-jpq/coq_nvim',
    lazy = false,
    -- merged 2023-02-10
    commit = '0e5f8ce68a5a6f8b2452f6fa35ce870e3bf9e7c8',
    -- branch = 'coq',
    event = 'InsertEnter',
    opt = true,
    run = ':COQdeps',
    config = function()
      require('coq_config').setup()
    end,
    disable = false,
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
    commit = '63260da18bf273c76b8e2ea0db84eb901cab49ce',
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
