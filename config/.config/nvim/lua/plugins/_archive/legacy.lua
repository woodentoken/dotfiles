return {
  -- {{ Git }}
  {
    "airblade/vim-gitgutter",
    event = { "BufReadPre", "BufNewFile" },
    init = function()
      vim.g.gitgutter_async = 0
      vim.g.gitgutter_realtime = 1
      vim.g.gitgutter_eager = 1
      vim.g.gitgutter_max_signs = 500
      vim.g.gitgutter_map_keys = 0
      vim.g.gitgutter_override_sign_column_highlight = 0
    end,
  },
  { "tpope/vim-fugitive" },

  -- {{ APPEARANCE }}
  {
    "luochen1990/rainbow",
    init = function()
      vim.g.rainbow_active = 1
      vim.g.rainbow_conf = {
        guifgs = { "aquamarine1", "steelblue1", "slateblue1", "purple", "deeppink3", "deeppink2" },
        ctermfgs = { 40, 75, 99, 129, 162, 197 },
      }
    end,
  },
  { "morhetz/gruvbox" },
  { "sainnhe/gruvbox-material" },

  -- {{ FUNCTIONALITY }}
  { "junegunn/fzf", build = ":call fzf#install()" },
  { "junegunn/fzf.vim" },
  { "mbbill/undotree" },
  { "scrooloose/nerdtree" },
  { "tpope/vim-eunuch" },
  { "yegappan/mru" },

  -- {{ LOW LEVEL }}
  { "Konfekt/FastFold" },
  { "tmhedberg/SimpylFold" },
  { "github/copilot.vim" },
  { "justinmk/vim-sneak" },
  { "terryma/vim-expand-region" },
  { "tpope/vim-commentary" },
  { "tpope/vim-surround" },
  { "wellle/targets.vim" },

  -- {{ LANGUAGE SPECIFIC }}
  { "pangloss/vim-javascript" },
  { "rust-lang/rust.vim" },

  -- {{ LINT / QUALITY }}
  { "dense-analysis/ale" },
  { "tpope/vim-dispatch" },
}
