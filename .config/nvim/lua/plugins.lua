-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself
  use {
    'wbthomason/packer.nvim',
    -- Latest 2022-01-01
    commit = '851c62c5ecd3b5adc91665feda8f977e104162a5'
  }
  use {
    -- The real fzf repository did something that caused their git history
    -- to change, and thus a fork was born.
    'wileychr/fzf',
    commit = '2707af403a106ddf864d9c2bae2c5e2f9b07b05f'
  }
  use {
    -- The real fzf repository did something that caused their git history
    -- to change, and thus a fork was born.
    'wileychr/fzf.vim',
    commit = 'd5f1f8641b24c0fd5b10a299824362a2a1b20ae0'
  }
  use {
    "neovim/nvim-lspconfig",
    -- v0.1.6 2023-02-05
    commit = '255e07ce2a05627d482d2de77308bba51b90470c'
  }

  use {
    -- coq is an extremely fast auto-complete implementation for nvim
    'ms-jpq/coq_nvim',
    branch = 'coq',
    event = 'InsertEnter',
    opt = true,
    run = ':COQdeps',
    config = function()
      -- forgot to check this in
--      require('config.coq').setup()
    end,
    requires = {
      { 'ms-jpq/coq.artifacts', branch = 'artifacts' },
      { 'ms-jpq/coq.thirdparty', branch = '3p', module = 'coq_3p' },
    },
    disable = false,
  }
  use {
    -- treesitter is a "parser generator tool" and parsing library:
    -- it is a C library that lets you "parse" the AST of many languages
    -- and interact with that parse tree.
    -- nvim-treesitter is the official integration of treesitter with nvim
    -- for intance to enable AST aware color schemes.
    'nvim-treesitter/nvim-treesitter',
    -- v0.9.0 2023-04
    commit = 'cc360a9beb1b30d172438f640e2c3450358c4086',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
  }

  --
  -- Various repositories exporting color schemes.  Not load bearing.
  --
  use {
    'ray-x/starry.nvim',
    commit = '9c4f8669acb302300e1495d4b1f1e618524a48f4'
  }
  --[[
  use 'ray-x/aurora'
  use 'marko-cerovac/material.nvim'
  use 'folke/tokyonight.nvim'
  use({ 'monsonjeremy/onedark.nvim', branch = 'treesitter' })

  use {
    'jparise/vim-graphql',
    commit = '42818fb3db74fc843e3db3cdc72bf72198cd224c'
  }
  --]]

  --[[
  I didn't actually find Copilot that useful.
  use {
    -- Somehow I needed this extension for copilot to work
    'ms-jpq/coq.thirdparty',
    commit = '6b52ae60235525d6a00fc091de4598ac88a63ecc'
  }
  use {
    'github/copilot.vim',
    -- latest commit as of 2023-03-27
    -- see pre-reqs on https://github.com/github/copilot.vim
    commit = '9e869d29e62e36b7eb6fb238a4ca6a6237e7d78b'
  }
  --]]

end)

