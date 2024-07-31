vim.api.nvim_exec([[
    hi Normal guibg=black
]], false)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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

vim.opt.encoding = "utf-8"


vim.g.mapleader = " "

require("lazy").setup({
  --"airblade/vim-gitgutter",
  "christoomey/vim-tmux-navigator",
  "luochen1990/rainbow",
  "johnsyweb/vim-makeshift",
  "jtratner/vim-flavored-markdown",
  "kopischke/vim-fetch",
  "easymotion/vim-easymotion",
  "lewis6991/gitsigns.nvim",
  "majutsushi/tagbar",
  "ntpeters/vim-better-whitespace",
  "rking/ag.vim",
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "nvim-treesitter/nvim-treesitter",
  "nvim-treesitter/nvim-treesitter-textobjects",
  {"j-hui/fidget.nvim", tag = "legacy"},
  "terryma/vim-expand-region",
  "tpope/vim-fugitive",
  "tpope/vim-repeat",
  "tpope/vim-sleuth",
  "tpope/vim-surround",
  "tpope/vim-unimpaired",
  "vim-airline/vim-airline",
  "vim-airline/vim-airline-themes",
 -- "github/copilot.vim",
  "szw/vim-maximizer",
  "jose-elias-alvarez/null-ls.nvim",
  "ethanholz/nvim-lastplace",
  "rhysd/vim-clang-format",
  "madox2/vim-ai",
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate" -- :MasonUpdate updates registry contents
},
  {
    "HampusHauffman/block.nvim",
    config = function()
        require("block").setup({})
    end
},
})

vim.g.vim_ai_chat = {
  options = {
    model = "gpt-4o",
    temperature = 0.2,
  }
}

vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.background = "dark"
vim.opt.backspace = "indent,eol,start"
vim.opt.diffopt:append("iwhite")
vim.opt.history  = 50
vim.opt.hlsearch =true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.laststatus = 2
vim.opt.number = true
vim.opt.scrolloff = 5
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.showfulltag = true
vim.opt.virtualedit = "all"
vim.opt.wildmenu = true

vim.opt.fillchars = {
  vert = "│",
  fold = "-",
  diff = "╱",
}

vim.o.completeopt = 'menuone,noselect'

vim.api.nvim_set_hl(0, "VertSplit", { cterm = none, ctermbg=none, ctermfg=247})

-- Undo
local undo_dir = vim.fn.expand("~/.vim/undo")

if not vim.fn.isdirectory(undo_dir) then
    vim.fn.system("mkdir -p " .. undo_dir)
end

vim.o.undofile = true
vim.o.undodir = undo_dir
vim.o.undolevels = 1000
vim.o.undoreload = 10000

require'nvim-lastplace'.setup {
    lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
    lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
    lastplace_open_folds = true
}

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- Clear highlights
vim.api.nvim_set_keymap('n', '<leader>/', ':nohlsearch<CR>', { silent = true })

-- Toggle wrapping
vim.api.nvim_set_keymap('n', '<leader>w', ':set wrap!<CR>', { silent = true })

-- Save with sudo if regular user
vim.cmd('cmap w!! w !sudo tee > /dev/null %')

-- Up/down by visual line, not actual line
vim.api.nvim_set_keymap('n', 'j', 'gj', { silent = true })
vim.api.nvim_set_keymap('n', 'k', 'gk', { silent = true })

-- Disable arrow keys
-- Hard mode some day
vim.api.nvim_set_keymap('n', '<Up>', '<Nop>', {})
vim.api.nvim_set_keymap('n', '<Down>', '<Nop>', {})
vim.api.nvim_set_keymap('n', '<Right>', '<Nop>', {})
vim.api.nvim_set_keymap('n', '<Left>', '<Nop>', {})

-- Center the screen on search results
vim.api.nvim_set_keymap('n', 'n', 'nzz', { silent = true })
vim.api.nvim_set_keymap('n', 'N', 'Nzz', { silent = true })
vim.api.nvim_set_keymap('n', '*', '*zz', { silent = true })
vim.api.nvim_set_keymap('n', '#', '#zz', { silent = true })
vim.api.nvim_set_keymap('n', 'g*', 'g*zz', { silent = true })
vim.api.nvim_set_keymap('n', 'g#', 'g#zz', { silent = true })

-- Automatically open, but do not go to (if there are errors) the quickfix /
-- location list window, or close it when it has become empty.
--
-- Note: Must allow nesting of autocmds to enable any customizations for quickfix
-- buffers.
-- Note: Normally, :cwindow jumps to the quickfix window if the command opens it
-- (but not if it's already open). However, as part of the autocmd, this doesn't
-- seem to happen.
vim.cmd([[
  autocmd QuickFixCmdPost [^l]* nested cwindow
  autocmd QuickFixCmdPost    l* nested lwindow
]])

-- Quickfix
vim.api.nvim_set_keymap('n', '<C-n>', ':cn<CR>', {})
vim.api.nvim_set_keymap('n', '<C-m>', ':cp<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>a', ':cclose<CR>', { silent = true })


-- Plugins

-- Airline
vim.g.airline_extensions_tabline_enabled = 0
vim.g.airline_powerline_fonts = 0
vim.g.airline_left_sep = ''
vim.g.airline_right_sep = ''
vim.g.airline_section_y = ''
vim.g.airline_theme = 'murmur'

-- Rainbow Parens
vim.g.rainbow_active = 1

-- Tagbar
vim.api.nvim_set_keymap('n', '<leader>t', ':TagbarToggle<CR>', { silent = true })

-- vim-better-whitespace
vim.g.better_whitespace_filetypes_blacklist = {'diff'}

-- vim-flavored-markdown
vim.cmd([[
  augroup markdown
    autocmd!
    autocmd BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
  augroup END
]])

-- vim-go
vim.g.go_fmt_command = "goimports"
---vim.opt.completeopt = { 'menu', 'menuone', 'longest' }

-- LSP setup
----for _, server in ipairs({
----        "clangd",
----        "cmake",
----        "pyright",
----        "rust_analyzer",
----    }) do
----        require'lspconfig'[server].setup()
----    end
---completion_callback = require'lsp_compl'.attach
---require'lspconfig'.clangd.setup{on_attach=completion_callback}
---require'lspconfig'.cmake.setup{on_attach=completion_callback}
---require'lspconfig'.pyright.setup{on_attach=completion_callback}
---require'lspconfig'.bashls.setup{on_attach=completion_callback}
---require'lspconfig'.dockerls.setup{on_attach=completion_callback}

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    if vim.lsp.buf.format then
      vim.lsp.buf.format()
    elseif vim.lsp.buf.formatting then
      vim.lsp.buf.formatting()
    end
  end, { desc = 'Format current buffer with LSP' })
end

vim.api.nvim_set_keymap('n', '<leader>cf', '<cmd>ClangFormat<CR>', { noremap = true, silent = true })

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Enable the following language servers
-- Feel free to add/remove any LSPs that you want here. They will automatically be installed
local servers = { 'clangd', 'pyright', 'cmake', 'dockerls', 'bashls', 'rust_analyzer' }

-- Ensure the servers above are installed
require('mason-lspconfig').setup {
  ensure_installed = servers,
}

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Turn on lsp status information
require('fidget').setup()
-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}





-- Treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "cpp", "cmake", "python", "java", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },
}

require('gitsigns').setup {
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },
}

require("null-ls").setup({
  on_init = function(new_client, _) 
    new_client.offset_encoding = 'utf-8'
  end,
})

