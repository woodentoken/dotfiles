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
echo "Do you want to remove potentially conflicting files in your home directory? (y/n)"
select yn in "create backups" "do nothing"; do
	case $yn in
		"create backups")
			incoming_files=()
			while IFS= read -r -d $'\0'; do
				incoming_files+=("$REPLY")
			done < <(find . -maxdepth 2 -type f,d -print0)

			existing_files=()
			while IFS= read -r -d $'\0'; do
				existing_files+=("$REPLY")
			done < <(find ../.* -maxdepth 0 -type f,d -print0)

			# TODO make "basenameify" a utility function
			# basenameify existing_filessting dotfiles
			for i in "${!existing_files[@]}"; do
				existing_files[$i]=$(basename ${existing_files[$i]})
			done

			# basenameify incoming_filesoming dotfiles
			for i in "${!incoming_files[@]}"; do
				incoming_files[$i]=$(basename ${incoming_files[$i]})
			done

			# compute the intersection of the basenamed files
			common_dotfiles=($(comm -12 <(printf '%s\n' "${incoming_files[@]}" | sort) <(printf '%s\n' "${existing_files[@]}" | sort)))

			# backup existing_filessting files
			backup_folder=~/.dotfile_backup_$(date '+%Y_%m_%d_%H_%M_%S')
			mkdir $backup_folder

			# move conflicting files into a backup folder
			pushd ..
			mv ${common_dotfiles[@]} $backup_folder
			popd

			unset IFS

			# locate existing_filessting dotfiles that may conflict
			log "moved ${common_dotfiles[@]} into $backup_folder"

			break
			;;
		"do nothing")
			log 'did not touch existing_filessting files, you *may* encounter issues with installation and symlinking as a result'
			break
	esac
done

echo "Do you wish to install latex packages? (y/n)"
select yn in "install latex packages" "do not install latex packages"; do
	case $yn in
		"install latex packages")
			install_latex=1; break;;
		"do not install latex packages")
			log 'did not installing latex packages'; break
	esac
done

#################################################
### Housekeeping
log "Installing dotfile packages..."
dotfile_packages="
  build-essential
  curl
  fd-find
  git
  net-tools
  openssh-server
  openssh-client
  perl
  python3
  python3-pip
  stow
  tmux
  tree
  vim
  wslu
  xdg-utils
  yodl
  zsh
"
latex_packages="
  latexmk
  mupdf
  texlive-latex-base
  texlive-latex-extra
"

# add latest vim version to repositories
sudo add-apt-repository ppa:jonathonf/vim

# get everything up to date
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

# optionally install rust
curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh

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
### {NVM and NodeJS}
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install node
#################################################


##################################################
### {Python}
# install with some default answers
# ./miniconda_install.sh <<< $'yes\nyes\n./conda/miniconda3\nno'
# remove installer
#rm -rf ./miniconda_install.sh
#conda list

#################################################


#################################################
### {VIM} Install Plug
log "Installing Vim Plug plugin manager..."
curl -fLo ./vim/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim >> $LOG
log "...Done"

log "Installing Vim Plugins..."
run vim -E -s -u '~/.vimrc.plugins' +PlugInstall +qall || true
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
