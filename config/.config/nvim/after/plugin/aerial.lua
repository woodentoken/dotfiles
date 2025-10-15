-- ~/.config/nvim/after/plugin/aerial.lua

-- Helper: get the foreground color of an existing Vim highlight group
local function get_fg(group)
  local ok, hl = pcall(vim.api.nvim_get_hl_by_name, group, true)
  if not ok then
    return nil
  end
  return hl.foreground and string.format("#%06x", hl.foreground) or nil
end

-- Apply colors to all Aerial highlight groups
local function sync_aerial_colors()
  local mappings = {
    AerialFunction = "Function",
    AerialMethod = "Function",
    AerialClass = "Type",
    AerialStruct = "Type",
    AerialInterface = "Type",
    AerialEnum = "Type",
    AerialVariable = "Identifier",
    AerialConstant = "Constant",
    AerialField = "Identifier",
    AerialProperty = "Identifier",
    AerialEvent = "Identifier",
    AerialTypeParameter = "Type",
  }

  for aerial_group, vim_group in pairs(mappings) do
    local fg = get_fg(vim_group)
    if fg then
      vim.api.nvim_set_hl(0, aerial_group, { fg = fg })
    end
  end
end

-- Run once at startup
sync_aerial_colors()

-- Update automatically whenever the colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = sync_aerial_colors,
})
