# Setup fzf
# ---------
if [[ ! "$PATH" == */home/kbordner/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/kbordner/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/kbordner/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/kbordner/.fzf/shell/key-bindings.bash"
