#!/bin/bash

# set -e

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

# find all dotfiles in the home directory and remove them
function find_conflicting_dotfiles {
  incoming_files=()
  while IFS= read -r -d $'\0'; do
    incoming_files+=("$REPLY")
  done < <(find . -maxdepth 2 -type f,d -print0)

  existing_files=()
  while IFS= read -r -d $'\0'; do
    existing_files+=("$REPLY")
  done < <(find ../.* -maxdepth 0 -type f,d -print0)

  # basenameify existing_file dotfiles
  for i in {1..$#existing_files}; do
    existing_files[$i]=$(basename ${existing_files[$i]})
  done

  # basenameify incoming_filesoming dotfiles
  for i in {1..$#incoming_files}; do
    incoming_files[$i]=$(basename ${incoming_files[$i]})
  done

  # compute the intersection of the basenamed files
  common_dotfiles=($(comm -12 <(printf '%s\n' "${incoming_files[@]}" | sort) <(printf '%s\n' "${existing_files[@]}" | sort)))
}

common_dotfiles=$(find_conflicting_dotfiles)

# if conflicting dotfiles exist, ask how we should handle them
if [ ! -z $common_dotfiles ]; then
  echo "conflicts found in home directory: $common_dotfiles."
  echo "How do you want to handle conflicting files/folders that are currently in your home directory? (b/d/n)"
  select bdn in "create backups" "delete them" "do nothing"; do
    case $bdn in
      "create backups")
        # backup existing files
        backup_folder=~/.dotfile_backup_$(date '+%Y_%m_%d_%H_%M_%S')
        mkdir $backup_folder

      # move conflicting files into a backup folder
      pushd ~
      mv ${common_dotfiles[@]} $backup_folder
      popd

      unset IFS

      # locate existing_files dotfiles that may conflict
      log "moved ${common_dotfiles[@]} into $backup_folder"

      break
      ;;
    "delete them")
      log "deleting ${common_dotfiles[@]}"

      pushd ~
      rm -rf ${common_dotfiles[@]}
      popd
      break
      ;;
    "do nothing")
      log 'did not touch existing files, you *may* encounter issues with installation and symlinking as a result'
      break
    esac
  done
fi

#################################################
### Basics
log "Installing dotfile packages..."
dotfile_packages="
  build-essential
  curl
  fd-find
  git
  git-absorb
  libncurses5-dev
  net-tools
  openssh-client
  openssh-server
  perl
  python3-dev
  python3-pip
  python3-setuptools
  r-base
  stow
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
### {VIM} Install the lastest version of vim
log "Installing the latest version of vim and configuring python support etc"
git clone https://github.com/vim/vim.git ~/vim
cd ~/vim
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
make
sudo make install
log "...Done"
#################################################


#################################################
### {Conda} Install Anaconda
log "Installing Anaconda..."
wget https://repo.anaconda.com/archive/Anaconda3-2023.09-Linux-x86_64.sh -P /tmp/
bash Anaconda3-2023.09-Linux-x86_64.sh
rm /tmp/Anaconda3-2023.09-Linux-x86_64.sh
log "...Done"
#################################################


#################################################
### {thefuck} Install thefuck
log "Installing thefuck"
pip3 install thefuck --user
pip3 install thefuck --upgrade
log "...Done"
#################################################


#################################################
### {R} Install r packages
log "Installing R packages..."
Rscript -e 'install.packages("languageserver")'
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

log "Installing Vim Plugins..."
run vim -E -s -u '~/.vimrc.plugins' +PlugInstall +qall || true
run vim -E -s -u '~/.vimrc.plugins' +Copilot setup
log "...Done"
#################################################


#################################################
### {STOW}
echo "Stowing dotfile directories..."
for directory in */; do
	stow --adopt -R $directory
	echo "  ${directory} stowed in ${HOME}"
done

# install some zsh plugins
~/resolve_zsh_plugins.sh
#################################################


#################################################
### {ZSH} make zsh default shell
log "Making zsh default shell..."
sudo chsh -s $(`which zsh`)
chsh -s $(`which zsh`) $USER
log "...Done"
#################################################

# final cleanup
sudo apt-get autoremove

log "All Done!"
exit 0
