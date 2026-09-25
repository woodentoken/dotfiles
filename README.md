# woodentoken/dotfiles

These are dotfiles designed for Linux.

They are based around using zsh for the terminal and neovim for the editor.

folders are used to delineate configuration options, and generally, the actual
"."files (.vimrc, .zshrc) are merely sourcing their constituent parts. I have
found this to be useful for tracking where changes are implemented.

This README parses each subfolder one by one to describe their functionality and feature set.

---

## Installation

to install (_do not use sudo_):

```bash
git clone https://github.com/woodentoken/dotfiles/ ~/dotfiles
~/dotfiles/bootstrap.sh
```

the install script uses `stow` to automatically symlink each folder into the
home directory. It will back up any existing dotfiles to a folder
`~/dotfiles_backup/` before symlinking.

---

## Features


### config/

I use neovim as my main editor. 

These dotfiles configure neovim via the lazy vim distribution, with some added custom plugins and settings.
The (main) plugins that I am using are listed below (almost assuredly out of date).

- [LazyVim/LazyVim](https://www.lazyvim.org/)


### images/

This file holds Containerfiles for a Fedora Kinoite OS image, and a Containerfile for a development toolbox.

scripts use the Containerfiles to deploy images through podman.

It also includes a flatpaks.txt file to keep sandboxed GUI apps tracked and reproducible.

#### Kinoite integration

Every layer has a declarative source of truth. Together these files describe the whole machine:
image/Containerfile: the OS
`flatpaks.txt``: GUI apps
`distrobox.ini`: dev environments
Stow packages: configuration
Project lock files (uv.lock, renv.lock): project dependencies
`bootstrap.sh`: ties it together

So a new machine workflow is:
1. install Kinoite.
2. switch installation to os_image.
2a. (optional) restore data.
3. create dev-toolbox using the toolbox_image file and `build_toolbox.sh`
4. switch to dev-toolbox.
3. clone this dotfiles project.
4. run `bootstrap.sh` to install dotfiles etc.

### CLI tools

- [sharkdp/fd](https://github.com/sharkdp/fd)
- [sharkdp/bat](https://github.com/sharkdp/bat)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [junegunn/fzf](https://github.com/junegunn/fzf)
- [stow](https://www.gnu.org/software/stow/)
- [zsh-users/zsh](https://github.com/zsh-users/zsh) (see below)

Implemented a color based directory depth scheme, visible here:

![image](https://user-images.githubusercontent.com/43391485/230224167-7e7c1e2d-8a09-45d0-a1ee-fe0aee09f086.png)

working on allowing directory depth jumping, like typing cd5 to go back 5 directories.
That would be integrated with a labeling scheme in the current directory, WIP

### git/

general git configuration, including shortcuts and preferences that I keep standard between machines.

### profile/

general aliases and commonalities for the command line.


### vim/

legacy vim configuration - I've now switched fully to neovim (configured in config/.config/nvim/). Some settings
from these vim files make their way into the neovim configuration, and they are a nice reminder of vimming.

#### git

- [airblade/gitgutter](https://github.com/airblade/vim-gitgutter)
- [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)

#### appearance

- [luochen1990/rainbow](https://github.com/luochen1990/rainbow)
- [morhetz/gruvbox](https://github.com/morhetz/gruvbox)
- [sainnhe/gruvbox-material](https://github.com/sainnhe/gruvbox-material)
- [vim-airline/vim-airline](https://github.com/vim-airline/vim-airline)
- [vim/airline/vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)
- [yggdroot/indentline](https://github.com/Yggdroot/indentLine)

#### functionality

##### high level

- [junegunn/fzf.vim](https://github.com/junegunn/fzf.vim)
- [neoclide/coc](https://github.com/neoclide/coc.nvim)
- [scrooloose/nerdtree](https://github.com/preservim/nerdtree)
- [tpope/vim-eunuch](https://github.com/tpope/vim-eunuch)
- [yegappan/mru](https://github.com/yegappan/mru)

##### low level

- [SirVer/ultisnips](https://github.com/SirVer/ultisnips)
- [honza/vim-snippets](https://github.com/honza/vim-snippets)
- [justinmk/vim-sneak](https://github.com/justinmk/vim-sneak)
- [tpope/vim-surround](https://github.com/tpope/vim-surround)
- [tpope/vim-commentary](https://github.com/tpope/vim-commentary)
- [wellle/targets.vim](https://github.com/wellle/targets.vim)

#### language specific

- [lervag/vimtex](https://github.com/lervag/vimtex)
- [python-mode/python-mode](https://github.com/python-mode/python-mode)
- [vim-javascript](https://github.com/pangloss/vim-javascript)

#### linting and formmatting

- [ty](https://docs.astral.sh/ty/)
- [ruff](https://docs.astral.sh/ruff/)
- [tpope/vim-dispatch](https://github.com/tpope/vim-dispatch)

---

### tmux/

currently, I'm using zellij over tmux.

- [kolach/tmux-temp](https://github.com/kolach/tmux-temp)
- [tmux-plugins/tmux-copycat](https://github.com/tmux-plugins/tmux-copycat)
- [tmux-plugins/tmux-cpu](https://github.com/tmux-plugins/tmux-cpu)
- [tmux-plugins/tmux-open](https://github.com/tmux-plugins/tmux-open)
- [tmux-plugins/tmux-yank](https://github.com/tmux-plugins/tmux-yank)
- [tmux-plugins/tpm](https://github.com/tmux-plugins/tpm)

### zellij

- [zellij-org/zellij]()

---

### zsh/

running `resolve_zsh_plugins.sh` will update each of the plugins below.

- [KulkarniKaustubh/fzf-dir-navigator](https://github.com/KulkarniKaustubh/fzf-dir-navigator)
- [ael-code/zsh-colored-man-pages](https://github.com/ael-code/zsh-colored-man-pages)
- [junegunn/fzf](https://github.com/junegunn/fzf) (set up for zsh)
- [marlonrichert/zsh-autocomplete](https://github.com/marlonrichert/zsh-autocomplete)
- [zdharma/fast-syntax-highlighting](https://github.com/zdharma/fast-syntax-highlighting)
- [zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)

---

## Miscellaneous

the font used for the ascii art is "Isometric3" from [this generator](https://patorjk.com/software/taag/#p=display&v=0&f=Isometric3&t=zshrc)

