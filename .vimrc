set encoding=utf-8
set nocompatible
set number
set lazyredraw
set wildmenu
set ai
set splitbelow
set mouse-=a
set ttymouse-=a
set nowrap linebreak nolist
set cursorline
set showcmd
set ttyfast
set autochdir
set incsearch

"set clipboard=unnamedplus
set t_Co=256
set tabstop=4

set shiftwidth=4
set expandtab
set hlsearch
syntax enable
filetype plugin indent on

"set spell spelllang=ru_ru,en_us
set nospell

autocmd BufEnter *.dart :setlocal tabstop=2 shiftwidth=2 expandtab cc=80
autocmd BufEnter *.yaml :setlocal tabstop=2 shiftwidth=2 expandtab
autocmd BufEnter *.yml :setlocal tabstop=2 shiftwidth=2 expandtab

set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
map Ж :

let &scrolloff = &lines / 4
autocmd VimEnter,WinEnter * let &scrolloff = winheight(0) / 4

call plug#begin('~/.vim/plugged')
    Plug 'sheerun/vim-polyglot'
    Plug 'fopwoc/truedark256-vim'
call plug#end()

colorscheme truedark256
