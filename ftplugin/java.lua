local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', '.project' }
-- local root_dir = require('jdtls.setup').find_root(root_markers)
-- calculate workspace dir
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath 'data' .. '/site/java/workspace-root/' .. project_name
print(workspace_dir)
os.execute('mkdir ' .. workspace_dir)

-- -- get the current O
-- local os
-- if vim.fn.has 'mac' == 1 then
--   os = 'mac'
-- elseif vim.fn.has 'unix' == 1 then
--   os = 'linux'
-- elseif vim.fn.has 'win32' == 1 then
--   os = 'win'
-- end
--
-- local runtimes = {}
-- if nil ~= JAVA_RUNTIMES then
--   runtimes = JAVA_RUNTIMES
-- end
--
-- local maven = {}
-- if nil ~= MAVEN_CONF then
--   maven = MAVEN_CONF
-- end
--
-- local config = {
--   cmd = {
--     'java',
--     '-Declipse.application=org.eclipse.jdt.ls.core.id1',
--     '-Dosgi.bundles.defaultStartLevel=4',
--     '-Declipse.product=org.eclipse.jdt.ls.core.product',
--     '-Dlog.protocol=true',
--     '-Dlog.level=ALL',
--     '-javaagent:' .. vim.fn.expand '$MASON/share/jdtls/lombok.jar',
--     '-Xms1g',
--     '--add-modules=ALL-SYSTEM',
--     '--add-opens',
--     'java.base/java.util=ALL-UNNAMED',
--     '--add-opens',
--     'java.base/java.lang=ALL-UNNAMED',
--     '-jar',
--     vim.fn.expand '$MASON/share/jdtls/plugins/org.eclipse.equinox.launcher.jar',
--     '-configuration',
--     vim.fn.expand '$MASON/share/jdtls/config',
--     '-data',
--     vim.fn.expand '~/AppData/Local/nvim-data/mason/bin/jdtls.cmd',
--     workspace_dir,
--   },
--   root_dir = root_dir,
--   settings = {
--     java = {
--       eclipse = {
--         downloadSources = true,
--       },
--       configuration = {
--         updateBuildConfiguration = 'interactive',
--         runtimes = {
--           {
--             name = 'JavaSE-11',
--             path = 'C:\\Users\\U482024\\.sdkman\\candidates\\java\\11.0.22-tem\\',
--           },
--           {
--             name = 'JavaSE-1.8',
--             path = 'C:\\Users\\U482024\\.sdkman\\candidates\\java\\8.0.402-tem\\',
--           },
--           {
--             name = 'JavaSE-17',
--             path = 'C:\\Users\\U482024\\.sdkman\\candidates\\java\\17.0.10-tem\\',
--           },
--           {
--             name = 'JavaSE-21',
--             path = 'C:\\Users\\U482024\\.sdkman\\candidates\\java\\21.0.2-tem\\',
--           },
--         },
--       },
--       maven = {
--         downloadSources = true,
--         userSettings = 'C:\\Users\\U482024\\.m2\\settings.xml',
--         globalSettings = 'C:\\Users\\U482024\\.m2\\settings.xml',
--       },
--       implementationsCodeLens = {
--         enabled = true,
--       },
--       referencesCodeLens = {
--         enabled = true,
--       },
--     },
--     signatureHelp = {
--       enabled = true,
--     },
--     completion = {
--       favoriteStaticMembers = {
--         'org.hamcrest.MatcherAssert.assertThat',
--         'org.hamcrest.Matchers.*',
--         'org.hamcrest.CoreMatchers.*',
--         'org.junit.jupiter.api.Assertions.*',
--         'java.util.Objects.requireNonNull',
--         'java.util.Objects.requireNonNullElse',
--         'org.mockito.Mockito.*',
--       },
--     },
--     sources = {
--       organizeImports = {
--         starThreshold = 9999,
--         staticStarThreshold = 9999,
--       },
--     },
--   },
--   init_options = {
--     bundles = {
--       vim.fn.expand '$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar',
--       -- unpack remaining bundles
--       (table.unpack or unpack)(vim.split(vim.fn.glob '$MASON/share/java-test/*.jar', '\n', {})),
--     },
--   },
--   handlers = {
--     ['$/progress'] = function()
--       -- disable progress updates.
--     end,
--   },
--   filetypes = { 'java' },
--   -- on_attach = function(client, bufrnr)
--   --   require('jdtls').setup_dap({ hotcodereplace = 'auto' })
--   -- end,
-- }

local config = {
  -- cmd = { vim.fn.expand '$MASON/bin/jdtls' },
  cmd = {
    '/Users/u482024/.sdkman/candidates/java/21.0.6-oracle/bin/java',
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
    vim.fn.expand '/Users/u482024/.local/share/nvim/mason/bin/jdtls.cmd',
    workspace_dir,
  },
  root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
        runtimes = {
          --     {
          --       name = 'JavaSE-11',
          --       path = 'C:\\Users\\U482024\\.sdkman\\candidates\\java\\11.0.22-tem\\',
          --     },
          {
            name = 'JavaSE-1.8',
            path = '/Users/u482024/.sdkman/candidates/java/8.0.442-amzn',
          },
          {
            name = 'JavaSE-17',
            path = '/Users/u482024/.sdkman/candidates/java/17.0.12-oracle',
          },
          --     {
          --       name = 'JavaSE-21',
          --       path = 'C:\\Users\\U482024\\.sdkman\\candidates\\java\\21.0.2-tem\\',
          --     },
        },
      },
      maven = {
        downloadSources = true,
        userSettings = '/Users/u482024/.m2',
        globalSettings = '/Users/u482024/.m2',
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
  -- handlers = {
  --   ['$/progress'] = function()
  --     -- disable progress updates.
  --   end,
  -- },
  filetypes = { 'java' },
  on_attach = function(client, bufrnr)
    require('jdtls').setup_dap { config_overrides = {}, hotcodereplace = 'auto' }
    require('jdtls.dap').setup_dap_main_class_configs()
  end,
}

require('jdtls').start_or_attach(config)
