# woodentoken/dotfiles

These are dotfiles designed for Linux.

They are based around using zsh for the terminal and vim for the editor.

folders are used to delineate configuration options, and generally, the actual
"."files (.vimrc, .zshrc) are merely sourcing their constituent parts. I have
found this to be useful for tracking where changes are implemented, and I much
prefer it to using large, single, "."files.

I am version controlling my WSL settings as well (settings.json).
Manually copy and paste them into the WSL settings.json file to update.

---

## Installation

to install (*do not use sudo*):

```bash
git clone https://github.com/woodentoken/dotfiles/ ~/dotfiles
~/dotfiles/install.sh
```

the install script uses `stow` to automatically symlink each folder into the
home directory

---

## Features (AKA plugins)

### linux

- [sharkdp/fd](https://github.com/sharkdp/fd)
- [stow](https://www.gnu.org/software/stow/)
- [zsh-users/zsh](https://github.com/zsh-users/zsh) (see below)

Implemented a color based directory depth scheme, visible here:

![image](https://user-images.githubusercontent.com/43391485/230224167-7e7c1e2d-8a09-45d0-a1ee-fe0aee09f086.png)

certainly, it gets a little hard to parse at the mid depths

working allowing directory depth jumping, like typing cd5 to go back 5 directories.
That would be integrated with a labeling scheme in the current directory, WIP

### zsh

running `resolve_zsh_plugins.sh` will update each of the plugins below.

- [KulkarniKaustubh/fzf-dir-navigator](https://github.com/KulkarniKaustubh/fzf-dir-navigator)
- [Tarrasch/zsh-bd](https://github.com/Tarrasch/zsh-bd)
- [ael-code/zsh-colored-man-pages](https://github.com/ael-code/zsh-colored-man-pages)
- [junegunn/fzf](https://github.com/junegunn/fzf) (set up for zsh)
- [marlonrichert/zsh-autocomplete](https://github.com/marlonrichert/zsh-autocomplete)
- [zdharma/fast-syntax-highlighting](https://github.com/zdharma/fast-syntax-highlighting)
- [zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)

---

### vim

these dotfiles use [vim-plug](https://github.com/junegunn/vim-plug) to manage plugins.
use `:PlugUpdate` to update them.

#### git

- [airblade/gitgutter](https://github.com/airblade/vim-gitgutter)
- [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)

#### appearance

- [luochen1990/rainbow](https://github.com/luochen1990/rainbow)
- [morhetz/gruvbox](https://github.com/morhetz/gruvbox)
- [sainnhe/gruvbox-material](https://github.com/sainnhe/gruvbox-material)
- [yggdroot/indentline](https://github.com/Yggdroot/indentLine)

#### functionality

##### high level

- [junegunn/fzf.vim](https://github.com/junegunn/fzf.vim)
- [mbbill/undotree](https://github.com/mbbill/undotree)
- [neoclide/coc](https://github.com/neoclide/coc.nvim)
- [neoclide/coc](https://github.com/neoclide/coc.nvim)
- [scrooloose/nerdtree](https://github.com/preservim/nerdtree)
- [tpope/vim-eunuch](https://github.com/tpope/vim-eunuch)
- [yegappan/mru](https://github.com/yegappan/mru)

##### low level

- [Konfekt/FastFold]()
- [SirVer/ultisnips](https://github.com/SirVer/ultisnips)
- [github/copilot.vim]()
- [honza/vim-snippets](https://github.com/honza/vim-snippets)
- [justinmk/vim-sneak](https://github.com/justinmk/vim-sneak)
- [tmhedberg/SimplyFold]()
- [tpope/vim-commentary](https://github.com/tpope/vim-commentary)
- [tpope/vim-surround](https://github.com/tpope/vim-surround)
- [wellle/targets.vim](https://github.com/wellle/targets.vim)

#### language specific

<!-- - [lervag/vimtex](https://github.com/lervag/vimtex) -->
<!-- - [python-mode/python-mode](https://github.com/python-mode/python-mode) -->
- [pangloss/vim-javascript](https://github.com/pangloss/vim-javascript)
- [rust-lang/rust.vim]()

#### linting

- [dense-analysis/ale](https://github.com/dense-analysis/ale)
- [tpope/vim-dispatch](https://github.com/tpope/vim-dispatch)

---

### tmux

- [kolach/tmux-temp](https://github.com/kolach/tmux-temp)
- [tmux-plugins/tmux-copycat](https://github.com/tmux-plugins/tmux-copycat)
- [tmux-plugins/tmux-cpu](https://github.com/tmux-plugins/tmux-cpu)
- [tmux-plugins/tmux-open](https://github.com/tmux-plugins/tmux-open)
- [tmux-plugins/tmux-yank](https://github.com/tmux-plugins/tmux-yank)
- [tmux-plugins/tpm](https://github.com/tmux-plugins/tpm)

---

## Miscellaneous

the font used for the ascii art is "Isometric3" from [this generator](https://patorjk.com/software/taag/#p=display&v=0&f=Isometric3&t=zshrc)
