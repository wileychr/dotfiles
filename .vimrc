" gnome terminal apparently doesn't claim 256 color support in a way that vim
" will recognize on its own.
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

" Thanks http://www.vim.org/scripts/script.php?script_id=2777
colorscheme tir_black

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'qf' : 1,
      \ 'notes' : 1,
      \ 'markdown' : 1,
      \ 'unite' : 1,
      \ 'text' : 1,
      \ 'vimwiki' : 1,
      \ 'conf' : 1,
      \ 'vim' : 1,
      \}

" Stop vim syntax highliting from complaining about C++11 initializers.
let c_no_curly_error=1

" Tab somewhat intelligently
set softtabstop=2
set tabstop=2
set shiftwidth=2
set expandtab
set backspace=2


au BufRead,BufNewFile *.flex,*.jflex    set filetype=jflex
au BufRead,BufNewFile *.cc.fsm set filetype=cpp
au BufNewFile,BufRead *.cup set filetype=cup
au BufNewFile,BufRead *.py set filetype=python
au BufRead,BufNewFile *.eclass,*.ebuild set filetype=sh

autocmd BufRead,BufNewFile *.eclass setfiletype sh
autocmd FileType sh setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
autocmd FileType make setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
autocmd FileType python setlocal tabstop=2 softtabstop=2 shiftwidth=2

" This is a great idea, but it takes a longass time
" kill any trailing whitespace on save
"autocmd FileType c,cabal,cpp,haskell,javascript,php,python,readme,text
"  \ autocmd BufWritePre <buffer>
"  \ :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))

" display
"set nolist                    " show/hide tabs and EOL chars
set number                    " show/hide line numbers (nu/nonu)
set scrolloff=5               " scroll offsett, min lines above/below cursor
set scrolljump=5              " jump 5 lines when running out of the screen
set sidescroll=10             " minumum columns to scroll horizontally
set showcmd                   " show command status
set showmatch                 " flashes matching paren when one is typed
set showmode                  " show editing mode in status (-- INSERT --)
set ruler                     " show cursor position
syntax on
set foldmethod=syntax
set foldnestmax=3
set foldlevel=1
set nocompatible

" Some search stuff
set ignorecase
set smartcase
set incsearch                 " incremental search
set hlsearch                  " highlighting when searching

" Make tab completion of file paths more bashlike
set wildmode=longest,list
set wildmenu

" other
set noerrorbells              " no bells in terminal
set undolevels=1000           " number of undos stored
set whichwrap=<,>,h,l,[,]
set nofen

" anything over 80 cols gets highlited
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

" hitting s <character> will now insert that character
function! RepeatChar(char, count)
  return repeat(a:char, a:count)
endfunction
nnoremap s :<C-U>exec "normal i".RepeatChar(nr2char(getchar()), v:count1)<CR>
nnoremap S :<C-U>exec "normal a".RepeatChar(nr2char(getchar()), v:count1)<CR>

" Don't even both showing the vertical split separator.
highlight VertSplit ctermfg=BLACK
highlight VertSplit ctermbg=BLACK
