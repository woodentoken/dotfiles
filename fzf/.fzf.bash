# Setup fzf
# ---------
if [[ ! "$PATH" == */home/kaleb/fzf/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/kaleb/fzf/.fzf/bin"
fi

eval "$(fzf --bash)"
