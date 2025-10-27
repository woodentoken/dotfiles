-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.g.snacks_animate = false

vim.cmd("source ~/.vimrc.base")

vim.g.copilot_no_tab_map = true
vim.keymap.set("i", "<S-Tab>", 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })
-- You probably also want to set a keymap to toggle aerial
-- vim.cmd("hi AerialClass guifg=orange")
-- vim.cmd("hi AerialFunction guifg=rust")
