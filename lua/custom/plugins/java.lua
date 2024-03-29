local jdtls_bin = vim.fn.stdpath 'data' .. '/mason/bin/jdtls'
local lsp_attach = function(client, bufnr)
  -- mappings here
end

local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', '.project' }
local root_dir = require('jdtls.setup').find_root(root_markers)
-- calculate workspace dir
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath 'data' .. '/site/java/workspace-root/' .. project_name
os.execute('mkdir ' .. workspace_dir)

-- get the current OS
local os
if vim.fn.has 'mac' == 1 then
  os = 'mac'
elseif vim.fn.has 'unix' == 1 then
  os = 'linux'
elseif vim.fn.has 'win32' == 1 then
  os = 'win'
end

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-javaagent:' .. vim.fn.expand '$MASON/share/jdtls/lombok.jar',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    vim.fn.expand '$MASON/share/jdtls/plugins/org.eclipse.equinox.launcher.jar',
    '-configuration',
    vim.fn.expand '$MASON/share/jdtls/config',
    '-data',
    workspace_dir,
  },
  root_dir = root_dir,
  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
        runtimes = {
          {
            name = 'JavaSE-11',
            path = 'C:\\Users\\U482024\\.sdkman\\candidates\\java\\11.0.22-tem\\',
          },
        },
      },
      maven = {
        downloadSources = true,
        userSettings = 'C:\\Users\\U482024\\.m2\\settings.xml',
        globalSettings = 'C:\\Users\\U482024\\.m2\\settings.xml',
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
    },
    signatureHelp = {
      enabled = true,
    },
    completion = {
      favoriteStaticMembers = {
        'org.hamcrest.MatcherAssert.assertThat',
        'org.hamcrest.Matchers.*',
        'org.hamcrest.CoreMatchers.*',
        'org.junit.jupiter.api.Assertions.*',
        'java.util.Objects.requireNonNull',
        'java.util.Objects.requireNonNullElse',
        'org.mockito.Mockito.*',
      },
    },
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
  },
  init_options = {
    bundles = {
      vim.fn.expand '$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar',
      -- unpack remaining bundles
      (table.unpack or unpack)(vim.split(vim.fn.glob '$MASON/share/java-test/*.jar', '\n', {})),
    },
  },
  handlers = {
    ['$/progress'] = function()
      -- disable progress updates.
    end,
  },
  filetypes = { 'java' },
  -- on_attach = function(client, bufrnr)
  --   require('jdtls').setup_dap({ hotcodereplace = 'auto' })
  -- end,
}

vim.api.nvim_create_autocmd('Filetype', {
  pattern = 'java', -- autocmd to start jdtls
  callback = function()
    require('jdtls').start_or_attach(config)
    require('jdtls.dap').setup_dap_main_class_configs()
  end,
})
