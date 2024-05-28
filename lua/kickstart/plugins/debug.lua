-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        'delve',
        'java-debug-adapter',
        'java-test',
        'javadbg',
        'javatest',
        'vscode-java-test',
      },
    }

    require('nvim-dap-virtual-text').setup {}

    vim.keymap.set('n', '<leader>tm', function()
      require('jdtls').test_nearest_method()
    end, { desc = '[C]ode [T]est [M]ethod' })

    vim.keymap.set('n', '<leader>tc', function()
      require('jdtls').test_class()
    end, { desc = '[C]ode [T]est [C]lass' })

    vim.keymap.set('n', '<leader>drc', dap.run_to_cursor, { desc = 'Debug: [R]un to [C]ursor' })
    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F1>', dap.step_over, { desc = 'Debug: step over' })
    vim.keymap.set('n', '<F2>', dap.step_into, { desc = 'Debug: step into' })
    vim.keymap.set('n', '<F3>', dap.continue, { desc = 'Debug: continue' })
    vim.keymap.set('n', '<F4>', dap.step_out, { desc = 'Debug: step out' })
    vim.keymap.set('n', '<F5>', dap.step_back, { desc = 'Debug: step back' })
    vim.keymap.set('n', '<F12>', dap.restart, { desc = 'Debug: step restart' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    -- automatic opening and closing debug ui
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapdapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapdapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapdapui_config = function()
      dapui.close()
    end

    -- Install golang specific config
    require('dap-go').setup()
  end,
}
