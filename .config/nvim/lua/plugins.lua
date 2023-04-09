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
    'wileychr/fzf',
    commit = '2707af403a106ddf864d9c2bae2c5e2f9b07b05f'
  }
  use {
    'wileychr/fzf.vim',
    commit = 'd5f1f8641b24c0fd5b10a299824362a2a1b20ae0'
  }
  use {
    "neovim/nvim-lspconfig",
    -- Latest 2022-01-01
    commit = '4b21740aae18ecec2d527b79d1072b3b01bb5a2a'
  }
  use {
    'ray-x/starry.nvim',
    commit = '9c4f8669acb302300e1495d4b1f1e618524a48f4',
    setup = function()
vim.g.starry_bold = true  --set to false to disable bold globally
vim.g.starry_italic = true --set to false to disable italic globally
vim.g.starry_italic_comments = true
vim.g.starry_italic_string = false
vim.g.starry_italic_keywords = false
vim.g.starry_italic_functions = false
vim.g.starry_italic_variables = false
vim.g.starry_contrast = true
vim.g.starry_borders = false
vim.g.starry_disable_background = false  --set to true to disable background and allow transparent background
vim.g.starry_style_fix=true  --disable random loading
vim.g.starry_style=''
--moonlight' -- load moonlight everytime or
vim.g.starry_darker_contrast=true  --darker background
vim.g.starry_deep_black=false       --OLED deep black
vim.g.starry_italic_keywords=false
vim.g.starry_italic_functions=false
vim.g.starry_set_hl=false -- Note: enable for nvim 0.6+, it is faster (loading time down to 4~6s from 7~11s), but it does
-- not overwrite old values and may has some side effects
vim.g.starry_daylight_switch=false  --this allow using brighter color
-- other themes: dracula, oceanic, dracula_blood, 'deep ocean', darker, palenight, monokai, mariana, emerald, middlenight_blue

    end
  }
  use {
    'ms-jpq/coq_nvim',
    commit = 'f7f09cb'
  }
  use {
    'justinmk/vim-sneak',
    commit = '94c2de47ab301d476a2baec9ffda07367046bec9'
  }
  use {
    'jparise/vim-graphql',
    commit = '42818fb3db74fc843e3db3cdc72bf72198cd224c'
  }
  use {
    'ms-jpq/coq.thirdparty',
    commit = '6b52ae60235525d6a00fc091de4598ac88a63ecc'
  }
  use {
    'github/copilot.vim',
    -- latest commit as of 2023-03-27
    -- see pre-reqs on https://github.com/github/copilot.vim
    commit = '9e869d29e62e36b7eb6fb238a4ca6a6237e7d78b'
  }
  
end)

