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
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$HOME/anaconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/anaconda3/bin:$PATH"
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
source ~/.zshrc.fzf          # setopts, history, keybindings
source ~/.zshrc.prompt       # PS1, git prompt, venv auto-activation

# -----------------------------------------------------------------------------
# SESSION MANAGEMENT
# -----------------------------------------------------------------------------
# Auto-attach or create a zellij session; exit this shell when zellij exits.
# Runs after module sources so panes and the outer shell see the full config.
# Skipped over SSH and in VS Code's integrated terminal.
if [[ -z "$SSH_TTY" && "$TERM_PROGRAM" != "vscode" ]] && command -v zellij >/dev/null; then
    export ZELLIJ_AUTO_ATTACH=true
    export ZELLIJ_AUTO_EXIT=false
    eval "$(zellij setup --generate-auto-start zsh)"
fi

# Auto-attach or create a tmux session named "main"
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   tmux new-session -A -s main
# fi

# -----------------------------------------------------------------------------

# GREETING
# -----------------------------------------------------------------------------
# Only run neofetch if this is the only terminal open
LIVE_COUNTER=$(ps a | awk '{print $2}' | grep -vi "tty*" | uniq | wc -l);
if [ $LIVE_COUNTER -eq 1 ]; then
     fastfetch
fi

{
  for f in ~/.zshrc ~/.zshenv; do
    [[ -s $f && ( ! -s $f.zwc || $f -nt $f.zwc ) ]] && zcompile $f
  done
} &!

