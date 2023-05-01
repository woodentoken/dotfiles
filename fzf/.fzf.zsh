# Setup fzf
# ---------
if [[ ! "$PATH" == */home/kaleb/dotfiles/fzf/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/kaleb/dotfiles/fzf/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/kaleb/dotfiles/fzf/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/kaleb/dotfiles/fzf/.fzf/shell/key-bindings.zsh"
