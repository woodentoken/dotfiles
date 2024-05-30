#!/bin/bash

# set -e

LOG=./log_install.log

# append to file
function run { eval "$@" >> $LOG; }

# print to STDOUT and append to file
function log { 
	echo "$@" | tee -a $LOG
	if [ "$@" == "...Done" ]; then
		echo
	fi
}

# move possibly conflicting dotfiles into a backup directory
pushd ~
mkdir dotfiles_old
mv .bash_logout dotfiles_old
mv .bashrc dotfiles_old
mv .gitconfig
mv .profile dotfiles_old
mv .vimrc dotfiles_old
mv .zlogout dotfiles_old
mv .zshrc dotfiles_old
popd

#################################################
### Basics
log "Installing dotfile packages..."
dotfile_packages="
  build-essential
  bspwm
  cmake
  curl
  fd-find
  flameshot
  git
  git-absorb
  libncurses5-dev
  libfontconfig1-dev
  libxt-dev
  neofetch
  net-tools
  nnn
  openssh-client
  openssh-server
  perl
  picom
  python3-dev
  python3-pip
  python3-setuptools
  r-base
  redshift
  rofi
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

for package in ${dotfile_packages}; do
	log ''
	sudo apt-get -y install $package
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
### install appimagelauncher
sudo add-apt-repository ppa:appimagelauncher-team/stable
sudo apt-get update
sudo apt-get install appimagelauncher
#################################################


#################################################
### {VIM} Install the lastest version of vim
log "Installing the latest version of vim and configuring python support etc"
git clone https://github.com/vim/vim.git ~/vim
pushd ~/vim/src
./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp=yes \
            --enable-python3interp=yes \
            --enable-pythoninterp=yes \
            --with-python3-config-dir=$(python3-config --configdir) \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
            --enable-gui=gtk2 \
            --enable-cscope \
            --prefix=/usr/local
make test
sudo make install
sudo apt install libxt-dev
popd
log "...Done"
#################################################


#################################################
### {Conda} Install Anaconda
log "Installing Anaconda..."
wget -c https://repo.anaconda.com/archive/Anaconda3-2023.09-0-Linux-x86_64.sh -P /tmp
pushd /tmp
zsh Anaconda3-2023.09-0-Linux-x86_64.sh
rm Anaconda3-2023.09-0-Linux-x86_64.sh
popd
conda init
log "...Done"
#################################################


#################################################
### {R} Install r packages
log "Installing R packages..."
sudo Rscript -e 'install.packages("languageserver", depeendencies=TRUE)'
log "...Done"
#################################################


#################################################
### {R} Install rstudio
log "Installing RStudio..."
wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1l-1ubuntu1.2_amd64.deb
sudo apt-get install ./libssl1.1_1.1.1l-1ubuntu1.2_amd64.deb
log "...Done"
#################################################


#################################################
### {Rust} Install Rust
log "Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
log "...Done"
#################################################


#################################################
### {Alacritty} Install Alacritty
log "Installing Alacritty"
cargo install alacritty
log "...Done"
#################################################


#################################################
### {ZSH} install fzf
log "Installing fzf..."
run git clone --depth 1 https://github.com/junegunn/fzf.git ./fzf/.fzf
# auto answer prompts with autocompletion y, key-bindings y, update-config n
echo 'y y n' | run ./fzf/.fzf/install --no-bash
log "...Done"
#################################################


#################################################
### {FD} link fd-find
log "Linking fd..."
ln -s $(which fdfind) ~/.local/bin/fd
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
### {NVM and NodeJS}
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install node
#################################################


#################################################
### {VIM} Install Plug
log "Installing Vim Plug plugin manager..."
curl -fLo ./vim/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim >> $LOG
log "...Done"
#################################################


#################################################
### {STOW}
echo "Stowing dotfile directories..."
for directory in */; do
	stow --adopt -R $directory
	echo "  ${directory} stowed in ${HOME}"
done
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
sudo chsh -s $(`which zsh`)
chsh -s $(`which zsh`) $USER
chsh -s $(which zsh)
log "...Done"
#################################################

# final cleanup
sudo apt-get autoremove
zsrc

log "All Done! Rebooting your computer is recommended!"
log "Exiting..."

log "you may want to open the .vimrc.plugins file and run :PlugInstall"

exit 0
