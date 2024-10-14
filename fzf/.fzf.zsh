# Setup fzf
if [[ ! "$PATH" == "*/home/${USER}/vim/fzf/.fzf/bin*"  ]]; then
  PATH="${PATH:+${PATH}:}/home/${USER}/fzf/bin"
fi

source <(fzf --zsh)

# export FZF_DEFAULT_OPTS="--layout=reverse --info=inline"

# Preview file content using bat (https://github.com/sharkdp/bat)
# export FZF_CTRL_T_OPTS="
#   --preview 'batcat -n --color=always {}'
#   --bind 'ctrl-/:change-preview-window(down|hidden|)'
#   --header 'FILE BROWSER"
