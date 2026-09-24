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

# Entry point. Initializes interactive tools, sources modules in dependency
# order, and handles session startup. Plain exports and PATH live in .zshenv.

source $HOME/.profile        # POSIX aliases and system-level config

# link ghostty correctly when inside a toolbox
if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  for d in "$GHOSTTY_RESOURCES_DIR" "/run/host$GHOSTTY_RESOURCES_DIR"; do
    [[ -r $d/shell-integration/zsh/ghostty-integration ]] && source $d/shell-integration/zsh/ghostty-integration && break
  done
fi

# -----------------------------------------------------------------------------
# TERMINAL
# -----------------------------------------------------------------------------
export COLORTERM=truecolor

# -----------------------------------------------------------------------------
# NVM
# -----------------------------------------------------------------------------
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# -----------------------------------------------------------------------------
# CONDA (anaconda + miniconda)
# -----------------------------------------------------------------------------
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/${USER}/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/${USER}/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/${USER}/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/${USER}/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

__conda_setup="$('/home/${USER}/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/${USER}/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/${USER}/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/${USER}/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# -----------------------------------------------------------------------------
# DIRENV
# -----------------------------------------------------------------------------
eval "$(direnv hook zsh)"

# -----------------------------------------------------------------------------
# MODULE SOURCES
# -----------------------------------------------------------------------------
source ~/.zshrc.plugins      # plugin sources
source ~/.zshrc.completion   # compinit, zstyles, completion keybindings
source ~/.zshrc.basics       # setopts, history, keybindings
source ~/.zshrc.fzf       # setopts, history, keybindings
source ~/.zshrc.prompt       # PS1, git prompt, venv auto-activation

# -----------------------------------------------------------------------------
# GREETING
# -----------------------------------------------------------------------------
# Only run neofetch if this is the only terminal open
LIVE_COUNTER=$(ps a | awk '{print $2}' | grep -vi "tty*" | uniq | wc -l);
if [ $LIVE_COUNTER -eq 1 ]; then
     fastfetch
fi
