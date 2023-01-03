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

autocmd BufEnter *.dart :setlocal tabstop=2 shiftwidth=2 expandtab cc=80
autocmd BufEnter *.yaml :setlocal tabstop=2 shiftwidth=2 expandtab
autocmd BufEnter *.yml :setlocal tabstop=2 shiftwidth=2 expandtab

hi ColorColumn ctermbg=235 guibg=#303030

"КОСТЫЛИ ЖУТКИЕ, как сядешь за мак настрой просто переключение языка в iterm
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
map Ж :

let &scrolloff = &lines / 4
autocmd VimEnter,WinEnter * let &scrolloff = winheight(0) / 4

if &term =~ '256color'
    set t_ut=
endif

if (has("termguicolors"))
    set termguicolors
endif

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
        --LSP and autocomplete
        {
            "neovim/nvim-lspconfig",
            dependencies = {
                "lukas-reineke/lsp-format.nvim",
            },
            config = function()
                local on_attach = function(client)
                    require("lsp-format").on_attach(client)
                end

                require("lsp-format").setup {}

                require("lspconfig")["tsserver"].setup{
                    on_attach = on_attach,
                    flags = lsp_flags,
                }
                require("lspconfig")["kotlin_language_server"].setup{
                    on_attach = on_attach
                }
                require("lspconfig")["dartls"].setup{
                    on_attach = on_attach
                }

                require'lspconfig'.csharp_ls.setup{
                    on_attach = on_attach
                }
            end,
        },
        {
            "ms-jpq/coq_nvim",
            branch = "coq",
            build = function()
                vim.cmd("COQdeps")
            end,
            config = function()
                vim.cmd("COQnow --shut-up")
            end,
        },
        {
            "ms-jpq/coq.artifacts",
            branch = "artifacts",
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
            "folke/trouble.nvim",
            dependencies = {
                "nvim-tree/nvim-web-devicons",
            },
            config = function()
                require("trouble").setup {}
                vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",{silent = true, noremap = true})
            end,
        },
        {
            "lukas-reineke/lsp-format.nvim",
            config = function()
                require("lsp-format").setup {
                    dart = {
                        sync = true,
                    }
                }
            end,
        },

        --git
        {
            "lewis6991/gitsigns.nvim",
            config = function()
                require("gitsigns").setup{
                    current_line_blame = true,
                    current_line_blame_opts = {
                        virt_text = true,
                        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                        delay = 1000,
                        ignore_whitespace = false,
                    },
                    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
                    on_attach = function(bufnr)
				    local function map(mode, lhs, rhs, opts)
				        opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
				        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
				    end
				
				    -- Navigation
				    map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
				    map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})
				
				    -- Actions
				    map('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
				    map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
				    map('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
				    map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
				    map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
				    map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
				    map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
				    map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
				    map('n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
				    map('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
				    map('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>')
				    map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
				    map('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>')
				
				    -- Text object
				    map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
				    map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
				  end
                }
            end,
        },

        --search
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

        --theme and visuals
        { 
            "bratpeki/truedark-vim",
            config = function()
                vim.cmd("colorscheme truedark")
            end,
        },
        {
            "tjdevries/express_line.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
            },
            config = function()
                require("el").setup()
            end,
        },
        

        --quality of life
        {
            "iamcco/markdown-preview.nvim",
            build = function()
                vim.cmd("call mkdp#util#install()")
            end,
        },
        {
            "j-hui/fidget.nvim",
            config = function()
                require("fidget").setup{}
            end,
        },
        {
            "lukas-reineke/indent-blankline.nvim",
            config = function()
                vim.opt.list = true
                vim.opt.listchars = { tab = '>~' }
                require("indent_blankline").setup {
                    space_char_blankline = " ",
                    show_current_context = true,
                    show_current_context_start = true,
                }
            end,
        },
        {
            "gelguy/wilder.nvim",
            enabled = true,
            config = function()
                local wilder = require('wilder')
                wilder.setup({modes = {':'}})
                wilder.set_option('renderer', wilder.popupmenu_renderer({
                    pumblend = 0,
                }))
                wilder.set_option('renderer', wilder.popupmenu_renderer({
                    highlighter = wilder.basic_highlighter(),
                    left = {' ', wilder.popupmenu_devicons()},
                    right = {' ', wilder.popupmenu_scrollbar()},
                }))
            end,
        },
        {
            "windwp/nvim-autopairs",
            enabled = true,
            config = function()
                local remap = vim.api.nvim_set_keymap
                local npairs = require('nvim-autopairs')
                
                npairs.setup({ map_bs = false, map_cr = false })
                
                vim.g.coq_settings = { keymap = { recommended = false } }
                
                -- these mappings are coq recommended mappings unrelated to nvim-autopairs
                remap('i', '<esc>', [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
                remap('i', '<c-c>', [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], { expr = true, noremap = true })
                remap('i', '<tab>', [[pumvisible() ? "<c-n>" : "<tab>"]], { expr = true, noremap = true })
                remap('i', '<s-tab>', [[pumvisible() ? "<c-p>" : "<bs>"]], { expr = true, noremap = true })
                
                -- skip it, if you use another global object
                _G.MUtils= {}
                
                MUtils.CR = function()
                  if vim.fn.pumvisible() ~= 0 then
                    if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
                      return npairs.esc('<c-y>')
                    else
                      return npairs.esc('<c-e>') .. npairs.autopairs_cr()
                    end
                  else
                    return npairs.autopairs_cr()
                  end
                end
                remap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })
                
                MUtils.BS = function()
                  if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
                    return npairs.esc('<c-e>') .. npairs.autopairs_bs()
                  else
                    return npairs.autopairs_bs()
                  end
                end
                remap('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true, noremap = true })
            end,
        },

        --utility
        {
            "nvim-tree/nvim-web-devicons",
        },
        {
            "nvim-lua/plenary.nvim",
        },
        
        --game
        {
            "ThePrimeagen/vim-be-good",
        },
    })
EOF
endif

