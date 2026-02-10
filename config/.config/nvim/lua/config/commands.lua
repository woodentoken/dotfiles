-- allow us to use :Format to format the current buffer using conform
vim.api.nvim_create_user_command("Format", function()
  require("conform").format({ bufnr = 0, lsp_fallback = true })
end, {})

vim.api.nvim_create_user_command("SortImports", function()
  require("conform").format({
    bufnr = 0,
    formatters = { "ruff_organize_imports" },
  })
end, { desc = "Sort imports" })

-- remap the capitals...
vim.api.nvim_create_user_command("W", "w", { nargs = 0 })
