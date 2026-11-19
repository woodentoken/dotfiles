-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("User", {
  pattern = "AlphaReady",
  callback = function()
    -- Close the dashboard
    vim.cmd("AlphaRedraw") -- Just in case
    vim.schedule(function()
      require("alpha").close()
      require("telescope.builtin").find_files()
    end)
  end,
})

-- Proportional split resizing on terminal resize (e.g. zellij pane resize).
-- LazyVim's default `lazyvim_resize_splits` just runs `wincmd =`, which skips
-- fixed-size sidebars (neo-tree, aerial, etc. set winfixwidth), so they never
-- grow/shrink. Here we scale those sidebars by the same ratio as the terminal,
-- then equalize the remaining editor splits around them.
pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_resize_splits")
do
  local prev = { cols = vim.o.columns, lines = vim.o.lines }
  local state = {} -- [winid .. dim] = { ratio = float, last = int }

  -- Scale one dimension of a fixed window, caching the exact float ratio on the
  -- window so repeated resizes don't accumulate rounding drift. If the user
  -- manually resized the window since our last set, re-derive the ratio.
  local function scale(win, dim, old_total, new_total)
    local get = dim == "width" and vim.api.nvim_win_get_width or vim.api.nvim_win_get_height
    local set = dim == "width" and vim.api.nvim_win_set_width or vim.api.nvim_win_set_height
    local key = win .. dim
    local cur = get(win)
    local s = state[key]
    local ratio = (s and s.last == cur) and s.ratio or cur / old_total
    set(win, math.max(1, math.floor(ratio * new_total + 0.5)))
    state[key] = { ratio = ratio, last = get(win) }
  end

  -- Only the current tab is resized right away. Other tabs are caught up when
  -- you enter them; `tabdo` would flash through every tab on each resize step.
  -- `prev` holds the screen size each tab was last laid out for.
  local function relayout()
    local tab = vim.api.nvim_get_current_tabpage()
    local cols, lines = vim.o.columns, vim.o.lines
    local p = prev[tab] or { cols = prev.cols, lines = prev.lines }
    if p.cols == cols and p.lines == lines then
      return
    end
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      if vim.api.nvim_win_get_config(win).relative == "" then
        if vim.wo[win].winfixwidth and cols ~= p.cols then
          scale(win, "width", p.cols, cols)
        end
        if vim.wo[win].winfixheight and lines ~= p.lines then
          scale(win, "height", p.lines, lines)
        end
      end
    end
    prev[tab] = { cols = cols, lines = lines }
    vim.cmd("wincmd =") -- equalize the non-fixed splits around the sidebars
  end

  local group = vim.api.nvim_create_augroup("proportional_resize", { clear = true })
  vim.api.nvim_create_autocmd({ "VimResized", "TabEnter" }, { group = group, callback = relayout })
  vim.api.nvim_create_autocmd("TabNew", {
    group = group,
    callback = function()
      prev[vim.api.nvim_get_current_tabpage()] = { cols = vim.o.columns, lines = vim.o.lines }
    end,
  })
end
