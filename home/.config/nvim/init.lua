vim.api.nvim_exec([[
    hi Normal guibg=black
]], false)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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
  -- Utilities & Core
  "tpope/vim-repeat",
  "tpope/vim-sleuth",
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  },
  "tpope/vim-unimpaired",
  "ethanholz/nvim-lastplace",
  "szw/vim-maximizer",
  "johnsyweb/vim-makeshift",
  "kopischke/vim-fetch",
  {
    "echasnovski/mini.trailspace",
    version = "*",
    config = function()
      require("mini.trailspace").setup({})
    end
  },
  {
    "HampusHauffman/block.nvim",
    config = function()
        require("block").setup({})
    end
  },

  -- UI & Appearance
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Define a completely custom, pure high-contrast theme (Black, White, and vibrant hints)
      local colors = {
        bg       = '#000000', -- Pure black
        fg       = '#ffffff', -- Pure white
        gray     = '#3a3a3a', -- Dark gray for inactive tabs
        lightgray= '#a0a0a0', -- Light gray for inactive text
        blue     = '#51afef',
        green    = '#98be65',
        orange   = '#ff9800',
        red      = '#ec5f67',
        magenta  = '#c678dd',
      }

      local high_contrast_theme = {
        normal = {
          a = { bg = colors.blue, fg = colors.bg, gui = 'bold' },
          b = { bg = colors.gray, fg = colors.fg },
          c = { bg = colors.bg, fg = colors.fg },
        },
        insert = {
          a = { bg = colors.green, fg = colors.bg, gui = 'bold' },
          b = { bg = colors.gray, fg = colors.fg },
          c = { bg = colors.bg, fg = colors.fg },
        },
        visual = {
          a = { bg = colors.magenta, fg = colors.bg, gui = 'bold' },
          b = { bg = colors.gray, fg = colors.fg },
          c = { bg = colors.bg, fg = colors.fg },
        },
        replace = {
          a = { bg = colors.red, fg = colors.bg, gui = 'bold' },
          b = { bg = colors.gray, fg = colors.fg },
          c = { bg = colors.bg, fg = colors.fg },
        },
        command = {
          a = { bg = colors.orange, fg = colors.bg, gui = 'bold' },
          b = { bg = colors.gray, fg = colors.fg },
          c = { bg = colors.bg, fg = colors.fg },
        },
        inactive = {
          a = { bg = colors.bg, fg = colors.lightgray, gui = 'bold' },
          b = { bg = colors.bg, fg = colors.lightgray },
          c = { bg = colors.bg, fg = colors.lightgray },
        },
      }

      require("lualine").setup({
        options = {
          theme = high_contrast_theme,
          component_separators = { left = '│', right = '│'},
          section_separators = { left = '', right = ''},
        }
      })
    end
  },
  "HiPhish/rainbow-delimiters.nvim",
  {"j-hui/fidget.nvim", tag = "legacy"},

  -- Git
  "tpope/vim-fugitive",
  "lewis6991/gitsigns.nvim",
  --"airblade/vim-gitgutter", -- Disabled (superseded by gitsigns)

  -- Search, Navigation & UI Overrides
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  "nvim-telescope/telescope.nvim",
  "nvim-lua/plenary.nvim",
  {
    "stevearc/aerial.nvim",
    opts = {},
    dependencies = {
       "nvim-treesitter/nvim-treesitter",
       "nvim-tree/nvim-web-devicons"
    }
  },
  "christoomey/vim-tmux-navigator",

  -- LSP, Mason & Formatting
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate" -- :MasonUpdate updates registry contents
  },
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  "nvimtools/none-ls.nvim",
  "rhysd/vim-clang-format",

  -- Autocompletion & Snippets
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",

  -- Treesitter & Syntax
  "nvim-treesitter/nvim-treesitter",
  "nvim-treesitter/nvim-treesitter-textobjects",
  "terryma/vim-expand-region",

  -- Language Specific
  "fatih/vim-go",
  "jtratner/vim-flavored-markdown",

  -- AI & Agentic Coding
  "madox2/vim-ai",
 -- "github/copilot.vim",
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
      "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
      "stevearc/dressing.nvim" -- Optional: Improves the default Neovim UI
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "anthropic",
          },
          inline = {
            adapter = "anthropic",
          },
          agent = {
            adapter = "anthropic",
          },
        },
      })
    end,
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

-- Aerial (Replacement for Tagbar)
vim.api.nvim_set_keymap('n', '<leader>t', ':AerialToggle<CR>', { silent = true })

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
}

require("null-ls").setup({
  on_init = function(new_client, _) 
    new_client.offset_encoding = 'utf-8'
  end,
})

