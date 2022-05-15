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
    'junegunn/fzf',
    -- Latest 2022-01-01
    commit = 'ae7753878f8740fbdb2cef5617911ef83255349b'
  }
  use {
    'junegunn/fzf.vim',
    -- Latest 0.30.0 2020-04-04
    commit = '209366754892b04a01fd40de03cb9874a1e8fef7'
  }
  use {
    "neovim/nvim-lspconfig",
    -- Latest 2022-01-01
    commit = '4b21740aae18ecec2d527b79d1072b3b01bb5a2a'
  }

  -- Various color schemes
  use {
    'sickill/vim-monokai',
    -- Latest 2022-01-01
    commit = 'ae7753878f8740fbdb2cef5617911ef83255349b'
  }

  use {
    'ms-jpq/coq_nvim',
    commit = 'f7f09cb'
  }

  use {
    'dcampos/nvim-snippy',
    commit = 'a4512c9'
  }
end)

