set encoding=utf-8
set nocompatible
set number
set lazyredraw
set wildmenu
set ai
set splitbelow
"set mouse=a
set nowrap linebreak nolist
set cursorline
set showcmd
set ttyfast
set autochdir

set clipboard=unnamedplus
set t_Co=256
set tabstop=4

set shiftwidth=4
set expandtab
syntax enable
filetype plugin indent on

"КОСТЫЛИ ЖУТКИЕ, как сядешь за мак настрой просто переключение языка в iterm
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
map Ж :

set rtp+=/usr/local/opt/fzf

if (has("termguicolors"))
    set termguicolors
endif

let &scrolloff = &lines / 4
autocmd VimEnter,WinEnter * let &scrolloff = winheight(0) / 4

if &term =~ '256color'
    set t_ut=
endif

nnoremap <Up> gk
nnoremap <Down> gj

nmap <F12> :so $MYVIMRC<CR>
nmap <F5> :redraw!<CR>

call plug#begin('~/.vim/plugged')
    Plug 'tpope/vim-sensible'
    Plug 'sheerun/vim-polyglot'
    Plug 'bratpeki/truedark-vim'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'mhinz/vim-signify'
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
    Plug 'pearofducks/ansible-vim', { 'do': './UltiSnips/generate.sh' }
call plug#end()

let g:plug_window = "new"

let g:fzf_preview_window = 'right:75%'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6  }  }

set updatetime=100

colorscheme truedark

let g:vim_markdown_strikethrough = 1
hi Normal guibg=NONE ctermbg=NONE

if has('nvim')
lua <<EOF
EOF
endif
