return {
  {
    "folke/snacks.nvim",
    opts = {
      ---
      notifier = {
        style = "minimal",
        top_down = false,
      },
      ---
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
            { icon = " ", key = "ff", desc = "files", action = ":lua require('fff').find_in_git_root()" },
            { icon = " ", key = "g", desc = "text", action = ":Fzf live_grep" },
            { icon = " ", key = "r", desc = "recent", action = ":Fzf oldfiles" },
            { icon = " ", key = "s", desc = "session", section = "session" },
            { icon = " ", key = "c", desc = "config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "l", desc = "lazy", action = ":Lazy" },
            { icon = " ", key = "x", desc = "lazy extras", action = ":LazyExtras" },
          },
        },
      },
      ---
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
            git_untracked = true,
            git_status = true,
            auto_close = false,
            -- sources = { "buffers", "files" },
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
