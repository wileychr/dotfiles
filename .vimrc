set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
"Plugin 'user/L9', {'name': 'newL9'}

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
au BufRead,BufNewFile *.flex,*.jflex    set filetype=jflex
au BufRead,BufNewFile *.cc.fsm set filetype=cpp
au BufNewFile,BufRead *.cup set filetype=cup

" This is a great idea, but it takes a longass time
" kill any trailing whitespace on save
"autocmd FileType c,cabal,cpp,haskell,javascript,php,python,readme,text
"  \ autocmd BufWritePre <buffer>
"  \ :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))

" display
set nolist                    " show/hide tabs and EOL chars
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

" Tab somewhat intelligently
set softtabstop=2
set tabstop=2
set shiftwidth=2
set expandtab
filetype indent plugin on
set autoindent
set backspace=2
" but for python and c#, pick 4 spaces
au BufEnter,BufRead *.py,*.cs setlocal softtabstop=4 tabstop=4 shiftwidth=4
" and for makefiles, don't do it
autocmd FileType make setlocal noexpandtab

" Some search stuff
set ignorecase
set smartcase
set incsearch                 " incrimental search
set hlsearch                  " highlighting when searching

" Make tab completion of file paths more bashlike
set wildmode=longest,list
set wildmenu

" other
set noerrorbells              " no bells in terminal
set undolevels=1000           " number of undos stored
set whichwrap=<,>,h,l,[,]
set nofen

" omnocppcomplete stuff
set nocp

" anything over 80 cols gets highlited
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

" hitting s <character> will now insert that character
function! RepeatChar(char, count)
  return repeat(a:char, a:count)
endfunction
nnoremap s :<C-U>exec "normal i".RepeatChar(nr2char(getchar()), v:count1)<CR>
nnoremap S :<C-U>exec "normal a".RepeatChar(nr2char(getchar()), v:count1)<CR>
