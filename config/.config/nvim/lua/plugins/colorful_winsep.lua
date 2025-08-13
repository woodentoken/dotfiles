return {
  "nvim-zh/colorful-winsep.nvim",
  config = function()
    require("colorful-winsep").setup({
      -- choose between "signle", "rounded", "bold" and "double".
      -- Or pass a tbale like this: { "─", "│", "┌", "┐", "└", "┘" },
      border = "bold",
      excluded_ft = { "packer", "TelescopePrompt", "mason" },
      highlight = { fg = "#957CC6", bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg },
      animate = {
        enabled = false, -- false to disable, or choose a option below (e.g. "shift") and set option for it if needed
      },
      indicator_for_2wins = {
        -- only work when the total of windows is two
        position = "center", -- false to disable or choose between "center", "start", "end" and "both"
        symbols = {
          -- the meaning of left, down ,up, right is the position of separator
          start_left = "󱞬",
          end_left = "󱞪",
          start_down = "󱞾",
          end_down = "󱟀",
          start_up = "󱞢",
          end_up = "󱞤",
          start_right = "󱞨",
          end_right = "󱞦",
        },
      },
    })
  end,
  event = { "WinEnter", "WinLeave" },
}
