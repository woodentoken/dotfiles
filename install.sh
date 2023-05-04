#!/usr/bin/bash

# set -e

echo "Do you want to remove potentially conflicting files in your home directory? (y/n)"
select yn in "y" "n"; do
  case $yn in
    y ) 

      # TODO make a cleaner for existing environments
      # get a nested set of files/folders from the current directory
      # pushd ~
      # move anything matching that nested set into a backup directory (timestamped)
      # popd
      log 'moved any potentially conflicting files in ~ into ~/dotfiles_backup_{date}'
      ;;
    n ) log 'did not touch existing files, you *may* encounter issues with installation and symlinking as a result';;
  esac
done

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

echo "Do you wish to install latex packages? (y/n)"
select yn in "y" "n"; do
  case $yn in
    y ) install_latex=1;;
    n ) log 'did not installing latex packages';;
  esac
done

#################################################
### Housekeeping
log "Installing dotfile packages..."
dotfile_packages="
  curl perl
  wslu git yodl fd-find tree xdg-utils stow
  tmux vim zsh
  python3 python3-pip
"
latex_packages="
  texlive-latex-base
  latexmk
  mupdf
"
sudo apt-get update

for package in ${dotfile_packages}; do
  log ''
  sudo apt-get install $package
done

if [ "$install_latex" = "1" ]; then
  for package in ${latex_packages}; do
    log ''
    sudo apt-get install $package
  done
fi

# remove superfluous packages
sudo apt-get autoremove

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
# auto answer prompts with autocompletion y, key-bindings y, update-config n
echo 'y y n' | run ./fzf/.fzf/install --no-bash
log "...Done"
#################################################


#################################################
### {ZSH} install zsh plugins
log "Installing zsh plugins..."
run ./zsh/resolve_zsh_plugins.sh
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
### {WEMUX}
git clone https://github.com/zolrath/wemux.git /usr/local/share/wemux
ln -s /usr/local/share/wemux/wemux /usr/local/bin/wemux
cp /usr/local/share/wemux/wemux.conf.example /usr/local/etc/wemux.conf
echo "host_list=(kbordner $USER)" >> /usr/local/etc/wemux.conf
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
### {NVM and NodeJS}
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install node
#################################################


##################################################
### {Python}
pip install virtualenvwrapper
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
### {ZSH} make zsh default shell
log "Making zsh default shell..."
sudo chsh -s $(which zsh)
chsh -s $(`which zsh`) $USER
log "...Done"
#################################################

log "All Done!"
exit 0
