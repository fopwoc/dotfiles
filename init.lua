-- Leader keys must be set before plugins are loaded.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Translate Russian keyboard layout keys back to Vim's default motions.
local function escape_langmap(value)
  return vim.fn.escape(value, [[;,."|\]])
end

-- Core editor behavior: minimal, readable, and close to default Vim.
local options = {
  number = true,
  mouse = '',
  wildmenu = true,
  autoindent = true,
  breakindent = true,
  undofile = true,
  ignorecase = true,
  smartcase = true,
  hlsearch = true,
  incsearch = true,
  signcolumn = 'yes',
  updatetime = 250,
  timeoutlen = 400,
  splitbelow = true,
  wrap = false,
  cursorline = true,
  scrolloff = 4,
  confirm = true,
  termguicolors = true,
  tabstop = 4,
  softtabstop = 4,
  shiftwidth = 4,
  expandtab = true,
}

for name, value in pairs(options) do
  vim.opt[name] = value
end

local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm,./]]
local ru = [[ёйцукенгшщзхъфывапролджэячсмитьбю.]]
local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>?]]
local ru_shift = [[ЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ,]]

vim.opt.langmap = vim.fn.join({
  escape_langmap(ru_shift) .. ';' .. escape_langmap(en_shift),
  escape_langmap(ru) .. ';' .. escape_langmap(en),
}, ',')

-- Keymaps: keep default Vim habits, only add small discoverable helpers.
local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
map('n', '<leader>bb', '<cmd>buffer #<CR>', { desc = 'Switch to alternate [B]uffer' })
map('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = '[D]elete buffer' })
map('n', '<leader>bl', '<cmd>buffers<CR>', { desc = '[L]ist buffers' })
map('n', '<leader>bn', '<cmd>bnext<CR>', { desc = '[N]ext buffer' })
map('n', '<leader>bp', '<cmd>bprevious<CR>', { desc = '[P]revious buffer' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Autocommands.
local user_group = vim.api.nvim_create_augroup('user-config', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Add discoverable netrw help mapping',
  group = user_group,
  pattern = 'netrw',
  callback = function(event)
    map('n', '<leader>nh', '<cmd>help netrw-quickmap<CR>', {
      buffer = event.buf,
      desc = 'Open [N]etrw quick help',
    })
  end,
})

-- Bootstrap lazy.nvim.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Plugins.
require('lazy').setup({
  {
    'fopwoc/truedark256-vim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('truedark256')
    end,
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function(_, opts)
      local ok, marks = pcall(require, 'which-key.plugins.marks')
      if ok then
        marks.mappings.icon = { icon = '′ ', color = 'orange' }
      end

      require('which-key').setup(opts)
    end,
    opts = {
      delay = 0,
      layout = {
        width = { min = 20, max = 38 },
        spacing = 2,
      },
      icons = {
        breadcrumb = '›',
        separator = '→',
        group = '+',
        ellipsis = '…',
        mappings = true,
        keys = {
          Up = '↑ ',
          Down = '↓ ',
          Left = '← ',
          Right = '→ ',
          C = '⌃ ',
          M = '⌥ ',
          D = '⌘ ',
          S = '⇧ ',
          CR = '↩ ',
          Esc = '⎋ ',
          ScrollWheelDown = '⇣ ',
          ScrollWheelUp = '⇡ ',
          NL = '↩ ',
          BS = '⌫ ',
          Space = '␠ ',
          Tab = '⇥ ',
          F1 = 'F1 ',
          F2 = 'F2 ',
          F3 = 'F3 ',
          F4 = 'F4 ',
          F5 = 'F5 ',
          F6 = 'F6 ',
          F7 = 'F7 ',
          F8 = 'F8 ',
          F9 = 'F9 ',
          F10 = 'F10 ',
          F11 = 'F11 ',
          F12 = 'F12 ',
        },
        rules = {
          { pattern = '%f[%a]git', icon = '◆', color = 'orange' },
          { pattern = 'buffer', icon = '≣', color = 'cyan' },
          { pattern = 'file', icon = '↗', color = 'cyan' },
          { pattern = 'window', icon = '□', color = 'blue' },
          { pattern = 'diagnostic', icon = '⚠', color = 'yellow' },
          { pattern = 'format', icon = '✎', color = 'cyan' },
          { pattern = 'search', icon = '⌕', color = 'green' },
          { pattern = 'find', icon = '⌕', color = 'green' },
          { pattern = 'toggle', icon = '◐', color = 'yellow' },
          { pattern = 'tab', icon = '⇥', color = 'purple' },
          { pattern = 'code', icon = '{}', color = 'orange' },
          { pattern = 'terminal', icon = '⌘', color = 'red' },
          { pattern = 'quit', icon = '⏻', color = 'red' },
          { pattern = 'exit', icon = '⏻', color = 'red' },
        },
      },
      spec = {
        { '<leader>b', group = '[B]uffer' },
        { '<leader>g', group = '[G]it' },
        { '<leader>n', group = '[N]etrw' },
        { '<leader>t', group = '[T]oggle' },
      },
      win = {
        border = 'single',
      },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 500,
      },
      on_attach = function(bufnr)
        local gitsigns = package.loaded.gitsigns
        local function buffer_map(lhs, rhs, desc)
          map('n', lhs, rhs, { buffer = bufnr, desc = desc })
        end

        buffer_map('<leader>gb', gitsigns.blame_line, '[G]it [B]lame line')
        buffer_map('<leader>gd', gitsigns.diffthis, '[G]it [D]iff this buffer')
        buffer_map('<leader>gp', gitsigns.preview_hunk_inline, '[G]it [P]review hunk')
        buffer_map('<leader>gr', gitsigns.reset_hunk, '[G]it [R]eset hunk')
        buffer_map('<leader>tb', gitsigns.toggle_current_line_blame, '[T]oggle git [B]lame')
      end,
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate'
  },
}, {
  ui = {
    icons = {
      cmd = '⌘',
      config = '⚙',
      event = '⚡',
      ft = 'ƒ',
      init = '○',
      keys = '⌨',
      plugin = '◆',
      runtime = '⟳',
      require = '→',
      source = '↗',
      start = '▶',
      task = '✓',
      lazy = '…',
    },
  },
})


-- vim: ts=2 sts=2 sw=2 et
