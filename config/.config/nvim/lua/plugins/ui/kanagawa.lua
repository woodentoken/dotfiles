return {
  {
    "rebelot/kanagawa.nvim",
    opts = {
      overrides = function(colors)
        local theme = colors.theme
        return {
          -- Darker Neo-tree sidebar
          NeoTreeNormal = { bg = theme.ui.bg_m3 },
          NeoTreeNormalNC = { bg = theme.ui.bg_m3 },
          NeoTreeEndOfBuffer = { bg = theme.ui.bg_m3 },
          -- AerialLine = { bg = colors.palette.sumiInk4 },
          ["@comment"] = { fg = "#dddddd", italic = true, bold = true },
          ["@string.documentation"] = { fg = "#dddddd", italic = true },
        }
      end,
    },
  },
}
