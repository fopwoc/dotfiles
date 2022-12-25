set encoding=utf-8
set nocompatible
set number
set lazyredraw
set wildmenu
set ai
set splitbelow
set mouse=a
set nowrap linebreak nolist
set cursorline
set showcmd
set ttyfast
set autochdir

"set clipboard=unnamedplus
"set t_Co=256
set tabstop=4

set shiftwidth=4
set expandtab
syntax enable
filetype plugin indent on

set spell spelllang=ru_ru,en_us
set nospell

"КОСТЫЛИ ЖУТКИЕ, как сядешь за мак настрой просто переключение языка в iterm
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
map Ж :

let &scrolloff = &lines / 4
autocmd VimEnter,WinEnter * let &scrolloff = winheight(0) / 4

if &term =~ '256color'
    set t_ut=
endif

"nnoremap <Up> gk
"nnoremap <Down> gj

if !has ('nvim')
    call plug#begin('~/.vim/plugged')
        "Plug 'tpope/vim-sensible'
        Plug 'sheerun/vim-polyglot'
        Plug 'bratpeki/truedark-vim'
        Plug 'mhinz/vim-signify'
        Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
    call plug#end()
 
    let g:plug_window = "new"
    
    let g:fzf_preview_window = 'right:75%'
    let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6  }  }
    
    set updatetime=100
    
    colorscheme truedark
    
    let g:vim_markdown_strikethrough = 1
endif

if has('nvim')
lua <<EOF
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "--single-branch",
            "https://github.com/folke/lazy.nvim.git",
            lazypath,
        })
    end
    
    vim.opt.runtimepath:prepend(lazypath)
    
    vim.g.mapleader = " "

    require("lazy").setup({
        { 
            "bratpeki/truedark-vim",
            config = function()
                vim.cmd("colorscheme truedark")
            end,
        },
        { 
            "ms-jpq/chadtree",
            branch = "chad",
            build = function()
                vim.cmd("CHADdeps")
            end,
        },
        {
            "ms-jpq/coq_nvim",
            branch = "coq",
            build = function()
                vim.cmd("COQdeps")
            end,
        },
        {
            "ms-jpq/coq.artifacts",
            branch = "artifacts",
        },
        {
            "neovim/nvim-lspconfig",
            config = function()
                require("lspconfig")["tsserver"].setup{
                    on_attach = on_attach,
                    flags = lsp_flags,
                }
                require("lspconfig")["kotlin_language_server"].setup{
                }
                require("lspconfig")["dartls"].setup{
                }
            end,
        },
        {
            "nvim-treesitter/nvim-treesitter",
            build = function()
                vim.cmd("TSUpdate")
            end,
            config = function()
                require("nvim-treesitter.configs").setup {
                    highlight = {
                        enable = true,
                        additional_vim_regex_highlighting = false,
                    },
                    rainbow = {
                        enable = true,
                        extended_mode = true,
                        max_file_lines = nil,
                    },
                }
            end,
        },
        {
            "iamcco/markdown-preview.nvim",
            build = function()
                vim.cmd("call mkdp#util#install()")
            end,
        },
        {
            "nvim-tree/nvim-web-devicons",
        },
        {
            "akinsho/bufferline.nvim",
            tag = "v3.0.0",
            dependencies = {
                "nvim-tree/nvim-web-devicons",
            },
            config = function()
                require("bufferline").setup{
                    options = {
                        diagnostics = "nvim_lsp"
                    }
                }
            end,
        },
        {
            "feline-nvim/feline.nvim",
            config = function()
                require("feline").setup{
                }
            end,
        },
        {
            "j-hui/fidget.nvim",
            config = function()
                require("fidget").setup{}
            end,
        },
        {
            "lewis6991/gitsigns.nvim",
            config = function()
               require("gitsigns").setup() 
            end,
        },
        {
            "lukas-reineke/indent-blankline.nvim",
            config = function()
                require("indent_blankline").setup {
                    show_current_context = true,
                    show_current_context_start = true,
                    space_char_blankline = " ",
                }
            end,
        },
        {
            "folke/trouble.nvim",
            dependencies = {                           
                "nvim-tree/nvim-web-devicons",
            },
            config = function()
                require("trouble").setup {}
            end,
        },
        {
            "folke/which-key.nvim",
            config = function()
                require("which-key").setup {}
            end,
        },
        {
            "nvim-lua/plenary.nvim",
        },
        {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.0",
            dependencies = {
                "nvim-lua/plenary.nvim",
            },
            config = function()
                require('telescope').setup{}
                vim.api.nvim_set_keymap("n", "<Leader>ff", [[<cmd>lua require('telescope.builtin').find_files()<cr>]], { noremap = true})
                vim.api.nvim_set_keymap("n", "<Leader>fg", [[<cmd>lua require('telescope.builtin').live_grep()<cr>]], { noremap = true})
            end,
        },
    })
EOF
endif

if exists("g:neovide")
    set guifont=JetBrainsMono\ Nerd\ Font:h13

    let g:neovide_hide_mouse_when_typing = v:false

    let g:neovide_refresh_rate = 60
    let g:neovide_refresh_rate_idle = 5

    let g:neovide_cursor_trail_size = 0.3

    let g:neovide_cursor_antialiasing = v:false
endif
