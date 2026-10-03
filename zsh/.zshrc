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

# -----------------------------------------------------------------------------
# SYSTEM ZSHRC (Fedora /etc/zshrc, skipped in .zshenv)
# -----------------------------------------------------------------------------
# Same as /etc/zshrc minus scripts that fork for something set natively here:
# which2.sh (zsh's builtin `which` is better anyway), gnupg2.sh ($(tty)),
# color*grep.sh (grep aliases live in .profile.aliases), lang.sh (when LANG is
# already inherited), toolbox.sh (two subshells to set a PS1 that .zshrc.prompt
# overwrites; its one-time welcome banners have already been shown).
if (( ${+_zsh_replay_etc_zshrc} )); then
  unset _zsh_replay_etc_zshrc
  bindkey ' ' magic-space
  export GPG_TTY=$TTY
  () {
    emulate -L ksh
    local f
    for f in /etc/profile.d/*.sh; do
      case ${f##*/} in
        which2.sh|gnupg2.sh|color*grep.sh|toolbox.sh) ;;
        lang.sh) [[ -n $LANG ]] || . $f ;;
        *) [[ -r $f ]] && . $f ;;
      esac
    done
  }
fi

source $HOME/.profile        # POSIX aliases and system-level config

# Source the output of an init command (`fzf --zsh`, `direnv hook zsh`) from a
# cache that is regenerated whenever the tool's binary is newer than it.
_cached_source() {
  local name=$1 bin=${commands[$2]}
  shift
  [[ -n $bin ]] || return 1
  local cache=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/$name.zsh
  if [[ ! -s $cache || $bin -nt $cache ]]; then
    mkdir -p ${cache:h} && "$@" >| $cache || return 1
  fi
  source $cache
}

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
# NVM_DIR is exported in .zshenv
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
  # condabin holds only the `conda` entry point; exporting it keeps conda
  # reachable from child processes (direnv's bash, scripts) that can't see the
  # zsh stub function, without paying for the hook
  [[ -d $_CONDA_ROOT/condabin ]] && path=("$_CONDA_ROOT/condabin" $path)
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
_cached_source direnv-hook direnv hook zsh

# The hook forks `direnv export zsh` on every prompt and cd (~5ms here). It can
# only do anything when an env is loaded (to unload/reload it) or an .envrc/.env
# exists in this directory or a parent, so check for that natively first.
_direnv_hook_maybe() {
  if [[ -z $DIRENV_DIR ]]; then
    local d=$PWD
    while [[ ! -e $d/.envrc && ! -e $d/.env ]]; do
      [[ $d == / ]] && return
      d=${d:h}
    done
  fi
  _direnv_hook
}
precmd_functions=(${precmd_functions/#%_direnv_hook/_direnv_hook_maybe})
chpwd_functions=(${chpwd_functions/#%_direnv_hook/_direnv_hook_maybe})

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

# Recompile changed startup files in the background; zsh loads foo.zwc in place
# of foo whenever it is newer.
{
  for f in ~/.zshrc ~/.zshenv ~/.zshrc.{plugins,completion,basics,fzf,prompt} \
           ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/*.zsh(N) ${ZDOTDIR:-$HOME}/.zcompdump; do
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
