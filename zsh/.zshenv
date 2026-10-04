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

# Startup timer start; reported once the first prompt is ready (see .zshrc).
if [[ -o interactive ]]; then
  zmodload zsh/datetime
  typeset -g _zsh_startup_t0=$EPOCHREALTIME
fi

# Sourced by every zsh (scripts included): keep to cheap exports, no output or tool init.

# -----------------------------------------------------------------------------
# PATH
# -----------------------------------------------------------------------------
typeset -U path fpath
path=(
  $HOME/.local/bin
  $path
  /usr/local/go/bin
  $HOME/go/bin
  /opt/nvim-linux-x86_64/bin
  $HOME/.cargo/bin
  $HOME/.fly/bin
  $HOME/.fzf/bin
)

# WSL appends the Windows PATH (~45 /mnt/c dirs). Every rebuild of the command
# hash reads them all over 9p (~250ms), on startup and on any later PATH change
# (venv/conda activation). Drop them; explorer.exe is aliased in .zshrc.
path=(${path:#/mnt/[a-z]/*})

# Fedora's /etc/zshrc sources every /etc/profile.d/*.sh for non-login shells
# (~25ms, mostly forks just to set an alias or variable). Skip it here and let
# .zshrc replay it without the slow scripts. $(<file) reads without forking.
if [[ -o interactive && ! -o login && -r /etc/zshrc && $(</etc/zshrc) == *_src_etc_profile_d* ]]; then
  unsetopt GLOBAL_RCS
  typeset -g _zsh_replay_etc_zshrc=1
fi

# -----------------------------------------------------------------------------
# TOOL CONFIG
# -----------------------------------------------------------------------------
export NNN_OPENER="$HOME/.config/nnn/open.sh"
export PYTHONBREAKPOINT="ipdb.set_trace"
export PYTHONSTARTUP="$HOME/.config/python/.pythonrc.py"
export NVM_DIR="$HOME/.nvm"
# Stop nvim blocking startup on an OSC 11 query (up to 100ms when the terminal or
# multiplexer doesn't answer) just to guess light/dark 'background'. The colorscheme
# is dark (the default), and truecolor comes from COLORTERM. See :h 'ttyfast'.
export NVIM_NOTTYFAST=1
