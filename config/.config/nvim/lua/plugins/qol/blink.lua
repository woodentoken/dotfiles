return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.completion = opts.completion or {}
      opts.completion.list = opts.completion.list or {}
      opts.completion.list.selection = {
        preselect = false, -- don't auto-highlight the first item
        auto_insert = false, -- don't preview/insert until you move/confirm
      }
      opts.completion.accept = opts.completion.accept or {}
      opts.completion.accept.auto_brackets = { enabled = false } -- don't add () after functions
    end,
  },
}
