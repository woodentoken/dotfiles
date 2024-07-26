
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
export TERM=xterm-256color
export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  tmux new-session -A -s main
fi

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--layout=reverse --color 16 --height 50% --border --info=inline --preview='less {}'"

source $HOME/.profile
source ~/.zshrc.plugins
source ~/.zshrc.extensions
source ~/.zshrc.basics

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/kaleb/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/kaleb/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/kaleb/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/kaleb/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# virtualenvwrapper
# source /home/kaleb/.local/bin/virtualenvwrapper.sh
# virtualenvwrapper

# export WORKON_HOME=$HOME/.virtualenvs
# export PROJECT_HOME=$HOME/Devel
# export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3.12
# source ~/.local/bin/virtualenvwrapper.sh

# only run neofetch if there is only one terminal open
LIVE_COUNTER=$(ps a | awk '{print $2}' | grep -vi "tty*" | uniq | wc -l);
if [ $LIVE_COUNTER -eq 1 ]; then
     neofetch
fi

alias omni_py=~/.local/share/ov/pkg/isaac_sim-2023.1.1/python.sh

# source /opt/ros/galactic/setup.zsh
# source /usr/share/colcon_cd/function/colcon_cd.sh
# export ROS_DOMAIN_ID=13

export ISAACSIM_PATH="${HOME}/.local/share/ov/pkg/isaac_sim-2023.1.1"
export ISAACSIM_PYTHON_EXE="${ISAACSIM_PATH}/python.sh"
