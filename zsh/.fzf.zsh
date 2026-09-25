# Setup fzf
# ---------
if [[ ! "$PATH" == */home/vsdb/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/vsdb/.fzf/bin"
fi

# Auto-completion
# ---------------
source "/home/vsdb/.fzf/shell/completion.zsh"

# Key bindings
# ------------
# source "/home/vsdb/.fzf/shell/key-bindings.zsh"
