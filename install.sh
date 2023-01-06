#!/usr/bin/bash

# set -e

rm ./install.log
LOG=./install.log

# append to file
function run { eval "$@" >> $LOG; }

# print to STDOUT and append to file
function log { 
  echo "$@" | tee -a $LOG
  if [ "$@" == "...Done" ]; then
    echo
  fi
}

#################################################
### Housekeeping
log "Installing dotfile packages..."
dotfile_packages="curl stow git tmux vim zsh python"
function dotfile_package_install { sudo apt-get update && sudo apt-get install -y ${dotfile_packages}; }
run dotfile_package_install
log "...Done"
#################################################


#################################################
### Clone Dotfiles from Git
dotfiles=https://github.com/kraleb/dotfiles
log "Cloning Dotfiles from ${dotfiles}..."
dotfile_path="${HOME}/dotfiles"
run git clone $dotfiles "${dotfile_path}"
log "...Done"
#################################################


#################################################
### {ZSH} install fzf
log "Installing fzf..."
run git clone --depth 1 https://github.com/junegunn/fzf.git ./fzf/.fzf
run ./fzf/.fzf/install
log "...Done"
#################################################


#################################################
### {ZSH} install zsh plugins
log "Installing zsh plugins..."
run ./zsh/resolve_zsh_plugins.sh
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
### {VIM} Install Plug
log "Installing Vim Plug plugin manager..."
curl -fLo ./vim/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim >> $LOG
log "...Done"

log "Installing Vim Plugins..."
run vim -E +PlugInstall +qall || true
log "...Done"
#################################################


#################################################
### {STOW}
echo "Stowing dotfile directories..."
for directory in */; do
  stow $directory
  echo "  ${directory} stowed in ${HOME}"
done
#################################################


#################################################
### {ZSH} make zsh default shell
log "Making zsh default shell..."
chsh -s $(which zsh)
log "...Done"
#################################################

exit 0
