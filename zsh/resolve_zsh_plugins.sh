#!/bin/bash
# script to install or update zsh plugins
DOTFILES_HOME=${HOME}/dotfiles

function update_or_install {
  local repo_name="${1}"
  local plugin_name="$(echo "${repo_name}" | cut -d"/" -f2)"
  local plugin_path="${DOTFILES_HOME}/zsh/.zsh/${plugin_name}"

  if cd "${plugin_path}" >/dev/null 2>&1; then
    echo "updating ${plugin_name}"
    echo Status:
    git pull
    echo Done
    echo
    cd - >/dev/null 2>&1
  else
    echo "installing ${plugin_name}"
    git clone "https://github.com/${repo_name}" "${plugin_path}"
    echo
  fi
}

update_or_install "Giammarco-Ferranti/deja"
update_or_install "ael-code/zsh-colored-man-pages"
update_or_install "olivierverdier/zsh-git-prompt"

# deja's plugin only loads the integration; the binary comes from its installer.
# SHELL=/bin/sh stops install.sh from appending activation lines to ~/.zshrc.
if ! command -v deja >/dev/null 2>&1; then
  echo "installing deja binary"
  SHELL=/bin/sh sh "${DOTFILES_HOME}/zsh/.zsh/deja/install.sh"
  "${HOME}/.local/bin/deja" import
fi

# zsh-patina is a single binary (no plugin repo needed); install or upgrade it
# from the latest GitHub release into ~/.local/bin, next to deja.
function update_or_install_patina {
  local bin="${HOME}/.local/bin/zsh-patina" arch target tag current tmp
  case "$(uname -s)-$(uname -m)" in
    Linux-x86_64)  target=x86_64-unknown-linux-gnu ;;
    Linux-aarch64) target=aarch64-unknown-linux-gnu ;;
    Darwin-arm64)  target=aarch64-apple-darwin ;;
    Darwin-x86_64) target=x86_64-apple-darwin ;;
    *) echo "zsh-patina: unsupported platform $(uname -sm)"; return 1 ;;
  esac
  tag=$(curl -fsSL https://api.github.com/repos/michel-kraemer/zsh-patina/releases/latest |
    sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -n1)
  [[ -n "$tag" ]] || { echo "zsh-patina: could not resolve latest release"; return 1; }
  current=$("$bin" --version 2>/dev/null | awk '{print $2}')
  if [[ "$current" == "$tag" ]]; then
    echo "zsh-patina ${tag} is up to date"
    echo
    return
  fi
  echo "installing zsh-patina ${tag}${current:+ (was ${current})}"
  tmp=$(mktemp -d)
  curl -fsSL "https://github.com/michel-kraemer/zsh-patina/releases/download/${tag}/zsh-patina-v${tag}-${target}.tar.gz" |
    tar -xz -C "$tmp" --strip-components 1 &&
    install -Dm755 "$tmp/zsh-patina" "$bin"
  rm -rf "$tmp"
  # a running daemon would keep serving the old version (and protocol)
  "$bin" status >/dev/null 2>&1 && "$bin" restart
  echo
}

update_or_install_patina
