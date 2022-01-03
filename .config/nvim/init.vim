set nocompatible

lua require('plugins')


" Pull in the fzf vim base plugin
set runtimepath+=/usr/local/opt/fzf

syntax on

"  https://github.com/neovim/neovim/wiki/FAQ#how-can-i-use-true-color-in-the-terminal
set termguicolors
" https://github.com/sickill/vim-monokai
colorscheme monokai_soda


au BufNewFile,BufRead Dockerfile.*      set filetype=dockerfile
au BufNewFile,BufRead Makefile.*        set filetype=make
au BufNewFile,BufRead *.flex,*.jflex    set filetype=jflex
au BufNewFile,BufRead *.cc.fsm          set filetype=cpp
au BufNewFile,BufRead *.cup             set filetype=cup
au BufNewFile,BufRead *.py              set filetype=python
au BufNewFile,BufRead *.aidl            set filetype=java
au BufNewFile,BufRead *.eclass,*.ebuild set filetype=sh

" Default tab settings
set tabstop=2
set softtabstop=2
set shiftwidth=2
set backspace=2
set expandtab

" Language specific overrides
autocmd FileType sh setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType make setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=100
autocmd FileType javascript setlocal tabstop=4 softtabstop=4 shiftwidth=4
"autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2


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
set wildmode=longest,list
set wildmenu

set noerrorbells              " no bells in terminal
set novisualbell
set undolevels=1000           " number of undos stored
set whichwrap=<,>,h,l,[,]
set nofen

" Don't even both showing the vertical split separator.
highlight VertSplit ctermfg=BLACK
highlight VertSplit ctermbg=BLACK

let mapleader=","

nnoremap <Leader>t :Files<CR>
nnoremap <Leader>f :Rg<CR>

" Turn off markdown syntax highliting for spelling errors
let g:markdown_enable_spell_checking = 0

lua require('lspconfig')

autocmd BufWritePre *.go lua vim.lsp.buf.formatting()
autocmd BufWritePre *.go lua goimports(1000)
