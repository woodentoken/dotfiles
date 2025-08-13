return {}

-- lua/plugins/example.lua
-- return {
--   {
--     "author/repo", -- GitHub repo string or local path
--     name = "optional-name", -- Optional override name
--     enabled = true, -- or false to disable
--     lazy = true, -- lazy-load (default true for LazyVim)
--     event = "BufReadPost", -- or "VeryLazy", "InsertEnter", etc.
--     cmd = { "CmdName" }, -- load when a command is run
--     ft = { "lua", "python" }, -- load for specific filetypes
--     dependencies = { "dep/repo" }, -- other plugins to load first

--     -- Plugin options before `config` runs
--     opts = {
--       option1 = true,
--       option2 = "value",
--     },

--     -- Function to run after plugin loads
--     config = function(_, opts)
--       -- If you use `opts`, they are passed here automatically
--       require("pluginname").setup(opts)
--     end,

--     -- Optional key mappings
--     keys = {
--       { "<leader>x", "<cmd>SomeCommand<cr>", desc = "Description" },
--     },

--     -- Priority for load order
--     priority = 1000,
--   },

--   -- You can declare multiple plugins in the same file:
--   {
--     "another/repo",
--     event = "VeryLazy",
--     config = function()
--       -- Config for this plugin
--     end,
--   },
-- }
