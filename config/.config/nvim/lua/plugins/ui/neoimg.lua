local exts = {
  "png", "jpg", "jpeg", "tiff", "tif", "svg", "webp", "bmp", "gif",
  "docx", "xlsx", "pdf", "pptx", "odg", "odp", "ods", "odt",
}

return {
  "skardyy/neo-img",
  build = ":NeoImg Install",
  -- load only when an image/document is opened (its BufRead/BufEnter
  -- autocmds fire after BufReadPre) instead of on every startup
  event = vim.tbl_map(function(ext)
    return "BufReadPre *." .. ext
  end, exts),
  cmd = "NeoImg",
  config = function()
    require("neo-img").setup()
  end,
}
