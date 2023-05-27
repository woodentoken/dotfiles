#!/usr/bin/bash 
# script to install or update zsh plugins
DOTFILES_HOME=${HOME}/dotfiles

function update_or_install {
  local repo_name="${1}"
  local plugin_name="$(echo "${repo_name}" | cut -d"/" -f2)"
  local plugin_path="${DOTFILES_HOME}/zsh/.zsh/${plugin_name}"

  if cd "${plugin_path}" > /dev/null 2>&1; then
    echo "updating ${plugin_name}"
    echo Status:
    git pull
    echo Done
    echo
    cd - > /dev/null 2>&1
  else
    echo "installing ${plugin_name}"
    git clone "https://github.com/${repo_name}" "${plugin_path}"
    echo
  fi
}

update_or_install "zsh-users/zsh-autosuggestions"
update_or_install "marlonrichert/zsh-autocomplete"
update_or_install "zdharma/fast-syntax-highlighting"
update_or_install "ael-code/zsh-colored-man-pages"
update_or_install "olivierverdier/zsh-git-prompt"
update_or_install "djui/alias-tips"
update_or_install "KulkarniKaustubh/fzf-dir-navigator"
