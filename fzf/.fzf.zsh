# Setup fzf
# ---------
if [[ ! "$PATH" == */home/kaleb/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/kaleb/.fzf/bin"
fi

source <(fzf --zsh)
