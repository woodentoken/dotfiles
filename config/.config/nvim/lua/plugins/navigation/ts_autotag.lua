return {
  "windwp/nvim-ts-autotag",
  -- LazyVim loads it on LazyFile (every file, ~5ms); it only acts on markup and
  -- JSX/TSX, so load it for those filetypes instead. A function replaces the
  -- inherited event list rather than extending it.
  event = function()
    return {}
  end,
  ft = {
    "html", "xml", "markdown", "php", "vue", "svelte", "astro", "templ",
    "htmldjango", "htmlangular", "eruby", "twig", "blade", "liquid",
    "javascript", "javascriptreact", "typescript", "typescriptreact",
    "glimmer", "handlebars", "heex", "elixir", "rescript",
  },
}
