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

# -----------------------------------------------------------------------------
# SESSION MANAGEMENT
# -----------------------------------------------------------------------------
# Auto-attach or create a zellij session. Runs first so the outer terminal shell
# doesn't load the full config only to host zellij (each pane loads its own).
# Once zellij exits or detaches, this shell carries on loading below.
# Skipped over SSH and in VS Code's integrated terminal.
if [[ -z "$ZELLIJ" && -z "$SSH_TTY" && "$TERM_PROGRAM" != "vscode" ]] && (( $+commands[zellij] )); then
  zellij attach -c
  # restart the startup timer so the report covers only the rest of the load
  _zsh_startup_t0=$EPOCHREALTIME
fi

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
# NVM (Lazy Loaded)
# -----------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"

# This function intercepts the call, loads the real NVM, and deletes itself
lazy_nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

# Create light placeholders that instantly wake up NVM on first use
nvm()  { lazy_nvm; nvm "$@"; }
node() { lazy_nvm; node "$@"; }
npm()  { lazy_nvm; npm "$@"; }
npx()  { lazy_nvm; npx "$@"; }


# -----------------------------------------------------------------------------
# CONDA (anaconda + miniconda)
# -----------------------------------------------------------------------------
# don't auto-activate the base env on shell startup (same as `auto_activate_base:
# false` in ~/.condarc, but kept here so it lives in the dotfiles)
export CONDA_AUTO_ACTIVATE_BASE=false
# locate the conda install root: $CONDA_EXE (set if already initialized), an
# existing conda binary on PATH, then the common install locations
__conda_root=""
if [[ -n $CONDA_EXE && -x $CONDA_EXE ]]; then
  __conda_root="${CONDA_EXE:h:h}"
elif (( $+commands[conda] )); then
  __conda_root="${commands[conda]:A:h:h}"
else
  for d in "$HOME/miniforge3" "$HOME/miniconda3" "$HOME/anaconda3" \
           "/opt/conda" "/opt/miniforge3" "/opt/miniconda3" "/opt/anaconda3"; do
    [[ -x $d/bin/conda ]] && __conda_root="$d" && break
  done
fi

# `conda shell.zsh hook` costs ~300ms, so it is lazy loaded like NVM: the stub
# below runs the real hook on first use. Shells that inherit an active env
# (CONDA_SHLVL > 0) load it eagerly so `conda deactivate` etc. keep working.
lazy_conda() {
  unset -f conda lazy_conda
  local setup
  setup="$("$_CONDA_ROOT/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
  if [[ $? -eq 0 ]]; then
    eval "$setup"
  elif [[ -f $_CONDA_ROOT/etc/profile.d/conda.sh ]]; then
    . "$_CONDA_ROOT/etc/profile.d/conda.sh"
  else
    export PATH="$_CONDA_ROOT/bin:$PATH"
  fi
}

if [[ -n $__conda_root ]]; then
  typeset -g _CONDA_ROOT=$__conda_root
  if (( ${CONDA_SHLVL:-0} > 0 )); then
    lazy_conda
  else
    conda() { lazy_conda; conda "$@"; }
  fi
fi
unset __conda_root

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
source ~/.zshrc.fzf          # setopts, history, keybindings
source ~/.zshrc.prompt       # PS1, git prompt, venv auto-activation

# Auto-attach or create a tmux session named "main"
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   tmux new-session -A -s main
# fi

# -----------------------------------------------------------------------------

# GREETING
# -----------------------------------------------------------------------------
# Only run fastfetch if this is the only terminal open (one pty in use)
() { (( $# == 1 )) && fastfetch } /dev/pts/<->(N)

{
  for f in ~/.zshrc ~/.zshenv; do
    [[ -s $f && ( ! -s $f.zwc || $f -nt $f.zwc ) ]] && zcompile $f
  done
} &!

# -----------------------------------------------------------------------------
# STARTUP TIME
# -----------------------------------------------------------------------------
# Report time from .zshenv to the first drawn prompt (includes precmd hooks and
# PS1 expansion). zle-line-init fires once the prompt is up; the hook removes
# itself after the first run. Set ZSH_STARTUP_REPORT=0 to silence.
if [[ -n $_zsh_startup_t0 && $ZSH_STARTUP_REPORT != 0 ]]; then
  _zsh_startup_report() {
    add-zle-hook-widget -d line-init _zsh_startup_report
    local ms=$(( (EPOCHREALTIME - _zsh_startup_t0) * 1000 ))
    unset _zsh_startup_t0
    zle -M "zsh ready in ${ms%.*}ms"
  }
  autoload -Uz add-zle-hook-widget
  add-zle-hook-widget line-init _zsh_startup_report
fi
