-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself
  use {
		'wbthomason/packer.nvim',
		commit = '851c62c5ecd3b5adc91665feda8f977e104162a5'
	}

	use {
		'rstacruz/vim-closer',
		commit = '26bba80f4d987f12141da522d69aa1fa4aff4436'
	}

  use {
    'junegunn/fzf.vim',
    commit = 'd6aa21476b2854694e6aa7b0941b8992a906c5ec'
  }

  use {
    'tanvirtin/monokai.nvim',
    commit = 'eee34ab38e62315c1609484672c60e8a7338d4d2'
  }

  use {
    "neovim/nvim-lspconfig",
    commit = '4b21740aae18ecec2d527b79d1072b3b01bb5a2a'
  }
end)

