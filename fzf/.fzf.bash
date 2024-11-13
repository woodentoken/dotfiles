# Setup fzf
# ---------
if [[ ! "$PATH" == */home/kaleb/dotfiles/fzf/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/kaleb/dotfiles/fzf/.fzf/bin"
fi

eval "$(fzf --bash)"
