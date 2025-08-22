return {
  "nvim-zh/colorful-winsep.nvim",
  config = function()
    require("colorful-winsep").setup({
      border = "bold",
      excluded_ft = { "packer", "TelescopePrompt", "mason" },
      -- highlight = "#C0442B",
      animate = {
        enabled = false, -- false to disable, or choose a option below (e.g. "shift") and set option for it if needed
      },
      indicator_for_2wins = {
        -- only work when the total of windows is two
        position = "center", -- false to disable or choose between "center", "start", "end" and "both"
        symbols = {
          -- the meaning of left, down ,up, right is the position of separator
          start_left = ">",
          end_left = ">",
          start_down = "",
          end_down = "",
          start_up = "",
          end_up = "",
          start_right = "<",
          end_right = "<",
        },
      },
    })
  end,
  event = { "WinEnter", "WinLeave" },
}
