#      ___           ___           ___           ___           ___
#     /  /\         /  /\         /__/\         /  /\         /  /\
#    /  /::|       /  /:/_        \  \:\       /  /::\       /  /:/
#   /  /:/:|      /  /:/ /\        \__\:\     /  /:/\:\     /  /:/
#  /  /:/|:|__   /  /:/ /::\   ___ /  /::\   /  /:/~/:/    /  /:/  ___
# /__/:/ |:| /\ /__/:/ /:/\:\ /__/\  /:/\:\ /__/:/ /:/___ /__/:/  /  /\
# \__\/  |:|/:/ \  \:\/:/~/:/ \  \:\/:/__\/ \  \:\/:::::/ \  \:\ /  /:/
#     |  |:/:/   \  \::/ /:/   \  \::/       \  \::/~~~~   \  \:\  /:/
#     |  |::/     \__\/ /:/     \  \:\        \  \:\        \  \:\/:/
#     |  |:/        /__/:/       \  \:\        \  \:\        \  \::/
#     |__|/         \__\/         \__\/         \__\/         \__\/
# _____________________________________________________________________

export COLORTERM=truecolor

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source $HOME/.profile
source ~/.zshrc.plugins
source ~/.zshrc.basics
source ~/.zshrc.extensions
