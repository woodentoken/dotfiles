local custom_config = {}

custom_config.diagnostics_visible = true
custom_config.virtual_text_visible = true

function custom_config.toggle_virtual_text()
  custom_config.virtual_text_visible = not custom_config.virtual_text_visible
  vim.diagnostic.config({ virtual_text = custom_config.virtual_text_visible })
end

function custom_config.toggle()
  if custom_config.diagnostics_visible then
    vim.diagnostic.enable(false)
    custom_config.diagnostics_visible = false
  else
    vim.diagnostic.enable(true)
    custom_config.diagnostics_visible = true
  end
end

return custom_config
