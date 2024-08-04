-- Set our leader key first so that plugins will have a consistent view
vim.g.mapleader=","

-- Important paths for lazy.nvim:
--   ~/.local/share/nvim/lazy/lazy.nvim
--   ~/.local/state/nvim/lazy/lazy.nvim
--   ~/.config/nvim/lazy-lock.json
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Install our package manager, lazy.nvim, if it isn't already.
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins from ~/.config/nvim/lua/plugins.lua
local plugin_spec = require("plugins")
require("lazy").setup(plugin_spec)

vim.cmd([[
" set an alias for the Files command
nnoremap <Leader>t :Files<CR>
" Note that there is a trailing space on the next line intentionally.
nnoremap <Leader>f :Rg 
nnoremap <silent> <C-j> :RG <C-r><C-w><CR>

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  let spec = fzf#vim#with_preview(spec, 'right', 'ctrl-/')
  call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
]])

vim.cmd([[
" Default tab settings
set tabstop=2
set softtabstop=2
set shiftwidth=2
set backspace=2
set expandtab
set textwidth=100

" I read somewhere that recent versions of vim don't perform filetype
" detection automatically on startup.
filetype on
filetype plugin on
filetype indent on
syntax on
colorscheme monokai

au BufNewFile,BufRead Dockerfile.*      set filetype=dockerfile
au BufNewFile,BufRead Makefile.*        set filetype=make
au BufNewFile,BufRead *.flex,*.jflex    set filetype=jflex
au BufNewFile,BufRead *.cc.fsm          set filetype=cpp
au BufNewFile,BufRead *.cup             set filetype=cup
au BufNewFile,BufRead *.py              set filetype=python
au BufNewFile,BufRead *.aidl            set filetype=java
au BufNewFile,BufRead *.eclass,*.ebuild set filetype=sh

" Language specific overrides
autocmd FileType sh setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType make setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab textwidth=100 foldmethod=indent
autocmd FileType markdown setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=100
autocmd FileType javascript setlocal tabstop=4 softtabstop=4 shiftwidth=4
"autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2

autocmd BufNewFile,BufRead *.go setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab textwidth=100

" Don't bother showing the vertical split separator.
highlight VertSplit ctermfg=BLACK
highlight VertSplit ctermbg=BLACK
]])

vim.cmd([[

set number                    " show/hide line numbers (nu/nonu)
set scrolloff=5               " scroll offsett, min lines above/below cursor
set scrolljump=5              " jump 5 lines when running out of the screen
set sidescroll=10             " minumum columns to scroll horizontally
set showcmd                   " show command status
set showmatch                 " flashes matching paren when one is typed
set showmode                  " show editing mode in status (-- INSERT --)
set ruler                     " show cursor position

" Some search stuff
set ignorecase
set smartcase
set incsearch                 " incremental search
set hlsearch                  " highlighting when searching

" Make tab completion of file paths more bashlike
" Setting `wildmode=full` switches from bash style tab complete to a pop-up
"   menu.  However, it seems less functional.
"set wildmode=full
set wildmode=longest,list
set wildmenu
set pumblend=15

set noerrorbells              " no bells in terminal
set novisualbell
set undolevels=1000           " number of undos stored
set whichwrap=<,>,h,l,[,]
set nofen

]])

vim.g.markdown_enable_spell_checking = false

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true }

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>c', '<cmd>lua vim.lsp.buf.hover()<CR>', {
    desc = "display hover information",
    unpack(opts)
  })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.format({async=true})<CR>', {
    desc = "format buffer",
    unpack(opts)
  })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', {
    desc = "go to type definition",
    unpack(opts)
  })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<F6>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

  vim.opt.tagfunc = "v:lua.vim.lsp.tagfunc"
end

cwd = os.getenv("PWD") or io.popen("cd"):read()
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end
GOPACKAGESDRIVER_PATH = cwd .. "/dev/go_packages_driver.bash"
if (file_exists(GOPACKAGESDRIVER_PATH))
then
require('lspconfig').gopls.setup({
  on_attach = on_attach,
  -- cmd = {'gopls', '-rpc.trace', '--debug=localhost:6060'},
  settings = {
    gopls = {
      env = {
        GOPACKAGESDRIVER = GOPACKAGESDRIVER_PATH,
        -- Work around some bug with symlinks + bazel in 1.18
        --   https://github.com/bazelbuild/rules_go/issues/3110
        GOPACKAGESDRIVER_BAZEL_BUILD_FLAGS = '--strategy=GoStdlibList=local',
      },
      directoryFilters = {
        "-bazel-bin",
        "-bazel-out",
        "-bazel-testlogs",
        "-bazel-applied2",
        "-simian/client/frontend",
        "-data",
      },
    },
  },
})
else
require('lspconfig').gopls.setup({
  on_attach = on_attach,
})
end


-- We will run the python language server inside a virtual env.
-- To boostrap this environment on Ubuntu 24.04
--   sudo apt install python3.12-venv
--   ~/.wileyfiles/vim_py_env/bin/python3 -m pip install python-lsp-server[all] python-lsp-ruff pylsp-mypy
PYLSP_VENV = os.getenv("HOME") .. '/.wileyfiles/vim_py_env'

require('lspconfig').pylsp.setup({
    on_attach = on_attach,
    cmd = {PYLSP_VENV .. '/bin/python3', '-m', 'pylsp'},
    -- See https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
    settings = {
      pylsp = {
        plugins = {
          jedi_completion = { fuzzy = true },
          -- python3 -m pip install python-lsp-ruff
          -- python3 -m pip install pylsp-mypy
          pylsp_mypy = { enabled = true },

          -- pylsp will try and enable these by default
          pylint = { enabled = false },
          pyflakes = { enabled = false },
          pycodestyle = { enabled = false },

          ruff = { enabled = true },
          pyls_isort = { enabled = true },
          -- We want to use ruff for formatting. Unfortunately, pylsp requires us to disable all other alternatives.
          autopep8 = { enabled = false },
          yapf = { enabled = false },
          black = { enabled = false },
        },
      },
    },
    -- capabilities = capabilities,
})


require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "go", "cpp", "python" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  -- This seems to fix the issue where automatic indentation puts extra whitespace for me.
  indent = {
    enable = true,
  },

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

local cmp = require("cmp")
cmp.setup({
  mapping = {
    ["<tab>"] = cmp.mapping(function(fallback)
      if not cmp.visible() then
        return fallback()
      end

      local entry = cmp.get_selected_entry()
      if not entry then
        return fallback()
      end
      cmp.confirm()
    end, {"i","s"}),
    -- Use the arrow keys to move up and down between autocomplete options.
    -- This is a little janky unless you have up/down bound to the home row somewhere.
    ["<down>"] = cmp.mapping(function(fallback)
      if not cmp.visible() then
        return fallback()
      end
      cmp.select_next_item()
    end, {"i","s"}),
    ["<up>"] = cmp.mapping(function(fallback)
      if not cmp.visible() then
        return fallback()
      end
      cmp.select_prev_item()
    end, {"i","s"}),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' }
  }
})
