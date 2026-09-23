      # ___           ___           ___           ___           ___                  
     # /  /\         /  /\         /__/\         /  /\         /__/\          ___    
    # /  /::|       /  /:/_        \  \:\       /  /:/_        \  \:\        /__/\   
   # /  /:/:|      /  /:/ /\        \__\:\     /  /:/ /\        \  \:\       \  \:\  
  # /  /:/|:|__   /  /:/ /::\   ___ /  /::\   /  /:/ /:/_   _____\__\:\       \  \:\ 
 # /__/:/ |:| /\ /__/:/ /:/\:\ /__/\  /:/\:\ /__/:/ /:/ /\ /__/::::::::\  ___  \__\:\
 # \__\/  |:|/:/ \  \:\/:/~/:/ \  \:\/:/__\/ \  \:\/:/ /:/ \  \:\~~\~~\/ /__/\ |  |:|
     # |  |:/:/   \  \::/ /:/   \  \::/       \  \::/ /:/   \  \:\  ~~~  \  \:\|  |:|
     # |  |::/     \__\/ /:/     \  \:\        \  \:\/:/     \  \:\       \  \:\__|:|
     # |  |:/        /__/:/       \  \:\        \  \::/       \  \:\       \__\::::/ 
     # |__|/         \__\/         \__\/         \__\/         \__\/           ~~~~
skip_global_compinit=1

# Sourced by every zsh (scripts included): keep to cheap exports, no output or tool init.

# -----------------------------------------------------------------------------
# PATH
# -----------------------------------------------------------------------------
typeset -U path  # dedupe; nested shells re-run this file
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/go/bin
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$PATH:${HOME}/.cargo/bin"
export PATH="$PATH:${HOME}/.fly/bin"
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# -----------------------------------------------------------------------------
# TOOL CONFIG
# -----------------------------------------------------------------------------
export NNN_OPENER="$HOME/.config/nnn/open.sh"
export PYTHONBREAKPOINT="ipdb.set_trace"
export PYTHONSTARTUP="$HOME/.config/python/.pythonrc.py"
export NVM_DIR="$HOME/.nvm"
