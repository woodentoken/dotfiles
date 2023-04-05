# woodentoken/dotfiles
These are dotfiles designed for Linux.

They are based around using zsh for the terminal and vim for the editor.

folders are used to delineate configuration options, and generally, the actual
"."files (.vimrc, .zshrc) are merely sourcing their constituent parts. I have
found this to be useful for tracking where changes are implemented, and I much
prefer it to using large, single, "."files.

---

## Installation

to install (*do not use sudo*):

```
git clone https://github.com/woodentoken/dotfiles/ ~/dotfiles
~/dotfiles/install.sh
```

the install script uses `stow` to automatically symlink each folder into the
home directory

---

## Features (AKA plugins)

not exhaustive and hopefully up to date

### terminal
- [sharkdp/fd](https://github.com/sharkdp/fd)
- [stow](https://www.gnu.org/software/stow/)
- [zsh-users/zsh](https://github.com/zsh-users/zsh) (see below)

I implemented a color based depth scheme, visible here:
![image](https://user-images.githubusercontent.com/43391485/230224167-7e7c1e2d-8a09-45d0-a1ee-fe0aee09f086.png)
certainly, it gets a little hard to parse at the mid depths, still, felt like a nice little thing to do.

I am working allowing directory depth jumping, like typing cd5 to go back 5 directories. That would be integrated with a labeling scheme in the current directory, WIP

### zsh

- [zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [marlonrichert/zsh-autocomplete](https://github.com/marlonrichert/zsh-autocomplete)
- [zdharma/fast-syntax-highlighting](https://github.com/zdharma/fast-syntax-highlighting)
- [ael-code/zsh-colored-man-pages](https://github.com/ael-code/zsh-colored-man-pages)
- [junegunn/fzf](https://github.com/junegunn/fzf) (set up for zsh)

### vim

these dotfiles use [vim-plug](https://github.com/junegunn/vim-plug) to manage plugins

#### git

- [airblade/gitgutter](https://github.com/airblade/vim-gitgutter)

#### appearance

- [vim-airline/vim-airline](https://github.com/vim-airline/vim-airline)
- [vim/airline/vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)
- [yggdroot/indentline](https://github.com/Yggdroot/indentLine)
- [morhetz/gruvbox](https://github.com/morhetz/gruvbox)
- [sainnhe/gruvbox-material](https://github.com/sainnhe/gruvbox-material) (default theme)
- [luochen1990/rainbow](https://github.com/luochen1990/rainbow)

#### functionality

- [tpope/vim/commentary](https://github.com/tpope/vim-commentary)
- [yegappan/mru](https://github.com/yegappan/mru)
- [junegunn/fzf.vim](https://github.com/junegunn/fzf.vim)
- [neoclide/coc](https://github.com/neoclide/coc.nvim)

#### linting

- [dense-analysis/ale](https://github.com/dense-analysis/ale)
- [pangloss/vim-javascript](https://github.com/pangloss/vim-javascript)

### tmux

- [tmux-plugins/tpm](https://github.com/tmux-plugins/tpm)
- [tmux-plugins/tmux-cpu](https://github.com/tmux-plugins/tmux-cpu)

---

## Miscellaneous

the font used for the ascii art is "Isometric3" from [this generator](https://patorjk.com/software/taag/#p=display&v=0&f=Isometric3&t=zshrc)
