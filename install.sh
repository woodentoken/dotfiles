#!/bin/bash

# set -e

LOG=./log_install.log

# append to file
function run { eval "$@" >>$LOG; }

# print to STDOUT and append to file
function log {
  echo "$@" | tee -a $LOG
  if [ "$@" == "...Done" ]; then
    echo
  fi
}

# move possibly conflicting dotfiles into a backup directory
pushd ~
mkdir -p dotfiles_old
mv .bash_logout dotfiles_old
mv .bashrc dotfiles_old
mv .gitconfig dotfiles_old
mv .profile dotfiles_old
mv .vimrc dotfiles_old
mv .zlogout dotfiles_old
mv .zshrc dotfiles_old
popd

#################################################
### Basics
log "Installing dotfile packages..."

dotfile_packages="
bat
build-essential
cmake
curl
feh
gcc
git
git-absorb
imagemagick
imagemagickwand-dev
lib-gtk2.0-dev
libatk1.0-dev
libcairo2-dev
libfontconfig1-dev
libncurses5-dev
libx11-dev
libxpm-dev
libxt-dev
libxt-dev
make
meld
nala
ncurses-dev
neofetch
net-tools
nnn
openssh-client
openssh-server
pipx
perl
python3-pip
python3-setuptools
python3.12
python3.12-dev
r-base
r-base-dev
stow
sxhkd
tldr
tmux
tree
wslu
xclip
xdg-utils
yodl
zsh
"

# prompt user whether to use desktop_package
desktop_packages="
bspwm
flameshot
gnome-disk-utility
picom
redshift
rofi
wezterm
appimagelauncher
"

for package in ${dotfile_packages}; do
  log "${package}"
  sudo apt-get -y install $package
done

while true; do
  read -p "Do you wish to install the desktop specific packages (this is most useful for GUI installations)? [yn]  " yn
  case $yn in
  [yY])
    # add wezterm repository
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
    echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list

    # add appimagelauncher
    sudo add-apt-repository ppa:appimagelauncher-team/stable

    for desktop_package in ${desktop_packages}; do
      log "${desktop_package}"
      sudo apt-get -y install $desktop_package
    done
    break
    ;;
  [nN])
    echo "Skipping desktop packages..."
    break
    ;;
  *)
    echo "Please answer yes or no."
    ;;
  esac
done

# get everything up to date after installing packages
# probably redundant, but just in case
sudo apt-get update
sudo apt-get -y upgrade

# populate tldr database
tldr -u

log "...Done"
#################################################

#################################################
### Clone Dotfiles from Git (you probably already did this...)
dotfiles=https://github.com/kraleb/dotfiles
log "Cloning Dotfiles from ${dotfiles}..."
dotfile_path="${HOME}/dotfiles"
run git clone $dotfiles "${dotfile_path}"
log "...Done"
#################################################

#################################################
### {STOW}
echo "Stowing dotfile directories..."
for directory in ~/dotfiles/*; do
  stow --adopt -R $directory
  echo "  ${directory} stowed in ${HOME}"
done
#################################################

#################################################
### {R}
log "Installing R packages..."
R_packages="
httpgd
"
for package in ${R_packages}; do
  log "${package}"
  Rscript -e "install.packages('${package}', repos='http://cran.rstudio.com/')"
done
pipx install radian
#################################################

###################################################################################################
# INDIVIDUAL INSTALLS
###################################################################################################

#################################################
### {VIM} Install the lastest version of vim
# remove old vim just in case
sudo apt remove vim vim-runtime gvim
log "Installing the latest version of vim and configuring python3.12 support etc"
git clone https://github.com/vim/vim.git ~/vim
pushd ~/vim/src
./configure --with-features=huge \
  --enable-multibyte \
  --enable-rubyinterp=yes \
  --enable-python3interp=yes \
  --with-python3-command=python3.12 \
  --enable-pythoninterp=yes \
  --with-python3-config-dir=$(python3-config --configdir) \
  --enable-perlinterp=yes \
  --enable-luainterp=yes \
  --enable-gui=gtk2 \
  --enable-cscope \
  --prefix=/usr/local
make test
sudo make install
popd
log "...Done"
#################################################

#################################################
### {neovim} Install the latest version of neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
#################################################

#################################################
### {Rust} Install Rust
log "Installing rust(up)..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
log "...Done"
#################################################

#################################################
### {uv} Install uv for python management
log "Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh
uv self update
echo 'eval "$(uv generate-shell-completion zsh)"' >>~/.zshrc
log "...Done"
#################################################

#################################################
### {ZSH} install fzf

# ensure fzf is not installed via apt (would be outdated anyway)
log "Removing apt fzf if it is installed..."
sudo apt remove fzf

log "Installing fzf..."
run git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
# auto answer prompts with autocompletion y, key-bindings y, update-config n
echo 'y y n' | run ~/.fzf/install --no-bash
log "...Done"
#################################################

#################################################
git clone https://github.com/stefanhaustein/TerminalImageViewer.git
cd TerminalImageViewer/src
make

# To move the tiv binary into your PATH (hopefully), also do
sudo make install
#################################################

#################################################
### {FD} link fd-find
log "Linking fd..."
git clone https://github.com/sharkdp/fd ~/fd

# Build
pushd ~/fd

cargo build

# Run unit tests and integration tests
cargo test

# Install
cargo install --path .
ln -s $(which fdfind) ~/.local/bin/fd
log "...Done"
popd
#################################################

#################################################
### {NVM and NodeJS}
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

nvm install node
#################################################

#################################################
### {VIM} Install Plug
log "Installing Vim Plug plugin manager..."
curl -fLo ./vim/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim >>$LOG
log "...Done"
#################################################

#################################################
### {TMUX} install tpm
log "Installing tmux plugin manager..."
run git clone --depth 1 https://github.com/tmux-plugins/tpm ./tmux/.tmux/plugins/tpm
log "...Done"

log "Installing tmux plugins..."
run ./tmux/.tmux/plugins/tpm/bin/install_plugins
log "...Done"
#################################################

#################################################
### {ZSH} install zsh plugins
log "Installing zsh plugins..."
cd ~
run ./resolve_zsh_plugins.sh
log "...Done"
#################################################

#################################################
### {ZSH} make zsh default shell
log "Making zsh default shell for ROOT and current USER..."
sudo chsh -s $($(which zsh))
chsh -s $($(which zsh)) $USER
chsh -s $(which zsh)
log "...Done"
#################################################

### final cleanup
sudo apt-get autoremove
sudo apt-get autoclean
source ~/.zshrc

log "All Done! Rebooting your computer is recommended!"
log "Exiting..."

log "you may want to open the .vimrc.plugins file and run :PlugInstall"

exit 0
