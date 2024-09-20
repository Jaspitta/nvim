vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.relativenumber = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.clipboard = 'unnamedplus'
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'numToStr/Comment.nvim',
    opts = {},
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      {
        'mfussenegger/nvim-jdtls',
        ft = { 'java' },
        dependencies = {
          'williamboman/mason-lspconfig.nvim',
          'mfussenegger/nvim-dap',
        },
      },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      local configs = require 'nvim-treesitter.configs'
      configs.setup {
        ensure_installed = {
          'c',
          'lua',
          'vim',
          'vimdoc',
          'query',
          'elixir',
          'heex',
          'javascript',
          'html',
          'java',
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
  },
}

-- telescope
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- lualine
require('lualine').setup()

-- harpoon
local harpoon = require 'harpoon'
harpoon:setup {}

vim.keymap.set('n', '<leader>a', function()
  harpoon:list():append()
end)
vim.keymap.set('n', '<C-e>', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set('n', '<C-h>', function()
  harpoon:list():select(1)
end)
vim.keymap.set('n', '<C-t>', function()
  harpoon:list():select(2)
end)
vim.keymap.set('n', '<C-n>', function()
  harpoon:list():select(3)
end)
vim.keymap.set('n', '<C-s>', function()
  harpoon:list():select(4)
end)

-- lsp
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
require('mason').setup()
require('mason-lspconfig').setup {
  otps = {
    ensure_installed = {
      'jdtls',
      'lemminx',
    },
  },
}

-- -- jdtls

local status, jdtls = pcall(require, 'jdtls')
if not status then
  return
end

local home = os.getenv 'HOME'
local workspace_path = home .. '/.local/share/lunarvim/jdtls-workspace/'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = workspace_path .. project_name

local os_config = 'linux'
if vim.fn.has 'mac' == 1 then
  os_config = 'mac'
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local bundles = {}
local mason_path = vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/')
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. 'packages/java-test/extension/server/*.jar'), '\n'))
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. 'packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar'), '\n'))
local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-javaagent:' .. home .. '/.local/share/nvim/mason/packages/jdtls/lombok.jar',
    '-jar',
    vim.fn.glob(home .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration',
    home .. '/.local/share/nvim/mason/packages/jdtls/config_' .. os_config,
    '-data',
    workspace_dir,
  },
  root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },

  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
        -- runtimes = {
        --   {
        --     name = "JavaSE-11",
        --     path = "~/.sdkman/candidates/java/11.0.17-tem",
        --   },
        --   {
        --     name = "JavaSE-18",
        --     path = "~/.sdkman/candidates/java/18.0.2-sem",
        --   },
        -- },
      },
      maven = {
        downloadSources = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = 'all', -- literals, all, none
        },
      },
      format = {
        enabled = false,
      },
    },
    signatureHelp = { enabled = true },
    extendedClientCapabilities = extendedClientCapabilities,
  },
  init_options = {
    bundles = bundles,
  },
}

config['on_attach'] = function(client, bufnr)
  local _, _ = pcall(vim.lsp.codelens.refresh)
  require('jdtls').setup_dap { hotcodereplace = 'auto' }
  require('vim.lsp').on_attach(client, bufnr)
  -- local status_ok, jdtls_dap = pcall(require, "jdtls.dap")
  if status_ok then
    -- jdtls_dap.setup_dap_main_class_configs()
  end
end

vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  pattern = { '*.java' },
  callback = function()
    local _, _ = pcall(vim.lsp.codelens.refresh)
  end,
})

require('jdtls').start_or_attach(config)
