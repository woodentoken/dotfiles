return {
  'dstein64/nvim-scrollview',
  opts = {
    excluded_filetypes = { 'nerdtree' },
    current_only = false,
    base = 'right',
    column = 1,
    signs_on_startup = { 'search', 'marks' },
    diagnostics_severities = { vim.diagnostic.severity.ERROR }
  }
}
