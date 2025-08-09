return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          pick = function(cmd, opts)
            return LazyVim.pick(cmd, opts)()
          end,
          header = [[

          ]],
          -- stylua: ignore
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "p", desc = "Find File", action = ":Telescope git_files" },
            { icon = " ", key = "g", desc = "Find Text", action = ":Telescope live_grep" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          },
        },
      },
      picker = {
        ui_select = true,
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["<c-cr>"] = { "close", mode = { "n", "i" } },
              ["<c-j>"] = { "history_back", mode = { "n", "i" } },
              ["<c-k>"] = { "history_forward", mode = { "n", "i" } },
              ["<c-/>"] = { "toggle_focus", mode = { "n", "i" } },
              ["<c-i>"] = { "toggle_focus", mode = { "n", "i" } },
              -- stylua: ignore start
              ["<c-u>"] = { function() vim.cmd("normal! dd") end, mode = { "n", "i" }, },
              ["<c-a>"] = { function() vim.cmd([[normal! ^i]]) end, mode = { "n", "i" }, },
              ["<c-e>"] = { function() vim.cmd([[normal! A]]) vim.api.nvim_input("<right>") end, mode = { "n", "i" }, },
              -- stylua: ignore end
              ["<c-s-a>"] = "select_all",
              ["<c-s-u>"] = { "list_scroll_up", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["o"] = "confirm",
              ["v"] = "edit_vsplit",
              ["s"] = "edit_split",
              ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["<c-cr>"] = { "close", mode = { "n", "i" } },
              ["<c-o>"] = { "confirm", mode = { "n", "i" } },
              ["<c-^>"] = { "confirm", mode = { "n", "i" } },
              ["<c-i>"] = { "toggle_focus", mode = { "n", "i" } },
              ["<c-/>"] = { "toggle_focus", mode = { "n", "i" } },
              ["<leader><leader>"] = "close",
            },
          },
        },
        sources = {
          explorer = {
            auto_close = true,
            win = {
              list = {
                keys = {
                  ["o"] = "confirm",
                  ["v"] = "edit_vsplit",
                  ["<leader>v"] = "edit_vsplit",
                  ["s"] = "edit_split",
                  ["<leader>s"] = "edit_split",
                  ["<Esc>"] = { "close", mode = { "n", "i" } },
                  ["<c-cr>"] = { "close", mode = { "n", "i" } },
                  ["<c-o>"] = { "confirm", mode = { "n", "i" } },
                  ["<c-^>"] = { "confirm", mode = { "n", "i" } },
                  ["<c-i>"] = { "toggle_focus", mode = { "n", "i" } },
                  ["<c-/>"] = { "toggle_focus", mode = { "n", "i" } },
                  ["<leader><leader>"] = "close",
                },
              },
            },
          },
        },
      },
    },
  },
}
