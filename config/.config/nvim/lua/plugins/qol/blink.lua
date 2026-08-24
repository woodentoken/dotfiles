-- return {
--   {
--     "saghen/blink.cmp",
--     opts = function(_, opts)
--       opts.completion = opts.completion or {}
--       opts.completion.list = opts.completion.list or {}
--       opts.completion.list.selection = {
--         preselect = false, -- don't auto-highlight the first item
--         auto_insert = false, -- don't preview/insert until you move/confirm
--       }
--     end,
--     keymap = {
--       preset = "super-tab", -- or "default", whatever you're using
--       ["<Tab>"] = { "select_next", "fallback" },
--       ["<S-Tab>"] = {
--         LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
--         "select_prev",
--         "fallback",
--       },
--     },
--   },
-- }

-- lua/plugins/blink.lua
return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.keymap = opts.keymap or {}
    opts.keymap.preset = "super-tab"

    opts.keymap["<S-Tab>"] = {
      function(cmp)
        local suggestion = require("supermaven-nvim.completion_preview")
        if suggestion.has_suggestion() then
          suggestion.on_accept_suggestion()
          return true
        end
        return false
      end,
      "snippet_backward",
      "select_prev",
      "fallback",
    }

    return opts
  end,
}
