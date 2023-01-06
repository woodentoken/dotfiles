#!/usr/bin/bash 
# script to install or update zsh plugins

function update_or_install {
  local repo_name="${1}"
  local plugin_name="$(echo "${repo_name}" | cut -d"/" -f2)"
  local plugin_path="./.zsh/${plugin_name}"

  if cd "${plugin_path}" > /dev/null 2>&1; then
    echo "updating ${plugin_name}"
    git pull
    echo
    cd - > /dev/null 2>&1
  else
    echo "installing ${plugin_name}"
    git clone "https://github.com/${repo_name}" "${plugin_path}"
    echo
  fi
}

update_or_install "zdharma/fast-syntax-highlighting"
update_or_install "zsh-users/zsh-autosuggestions"
