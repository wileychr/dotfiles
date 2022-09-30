-- Have to enable autocomplete before bringing in the plugin
-- Note you must have already `sudo apt install python3-venv`
-- and if you want the Python LSP to work: `pip install "python-lsp-server[all]"`
vim.g.coq_settings = { auto_start = 'shut-up' }
require('plugins')

vim.g.mapleader=","

vim.cmd([[
" Pull in the fzf vim base plugin
" set runtimepath+=/usr/local/opt/fzf
nnoremap <Leader>t :Files<CR>
" Note the trailing space is helpful here
nnoremap <Leader>f :Rg 
]])

vim.cmd([[
syntax on
"  https://github.com/neovim/neovim/wiki/FAQ#how-can-i-use-true-color-in-the-terminal
" set termguicolors
" colorscheme monokai
]])

vim.cmd([[
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
autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=100 foldmethod=indent
autocmd FileType markdown setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=100
autocmd FileType javascript setlocal tabstop=4 softtabstop=4 shiftwidth=4
"autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2

" Don't even both showing the vertical split separator.
highlight VertSplit ctermfg=BLACK
highlight VertSplit ctermbg=BLACK
]])

vim.cmd([[

" Default tab settings
set tabstop=2
set softtabstop=2
set shiftwidth=2
set backspace=2
set expandtab

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
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>c', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<F6>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

  vim.opt.tagfunc = "v:lua.vim.lsp.tagfunc"
end

cwd = os.getenv("PWD") or io.popen("cd"):read()
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end
GOPACKAGESDRIVER_PATH = cwd .. "/tools/golang/go_packages_driver.bash"
if (file_exists(GOPACKAGESDRIVER_PATH))
then
require('lspconfig').gopls.setup({
  on_attach = on_attach,
  -- cmd = {GOPACKAGESDRIVER_PATH},
  flags = {
    -- This will be the default in neovim 0.7+
    debounce_text_changes = 150,
  },
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
        "-data",
      },
    },
  },
})
end


-- Note this requires you to have run `pip install 'python-lsp-server[all]'`
require('lspconfig').pylsp.setup({
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    settings = {
      pylsp = {
        plugins = {
          black = {
            enabled = true,
            line_length = 100
          },
          -- python3 -m pip install python-lsp-black
          pylint = { enabled = true, executable = "pylint" },
          pyflakes = { enabled = true },
          pycodestyle = { enabled = false },
          jedi_completion = { fuzzy = true },
          pyls_isort = { enabled = true },
          pylsp_mypy = { enabled = true },
        },
      },
    },
    -- capabilities = capabilities,
})
