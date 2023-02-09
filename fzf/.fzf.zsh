# Setup fzf
# ---------
if [[ ! "$PATH" == */home/kbordner/dotfiles/fzf/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/kbordner/dotfiles/fzf/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/kbordner/dotfiles/fzf/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/kbordner/dotfiles/fzf/.fzf/shell/key-bindings.zsh"
