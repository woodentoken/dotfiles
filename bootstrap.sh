#!/usr/bin/env bash
# bootstrap.sh: set up a Fedora Kinoite machine from this dotfiles repo.
#
# Prerequisite: the machine is booted into the custom image built from
# images/Containerfile_os (see images/rebuild_os.sh). That image provides zsh,
# stow, neovim and the other host tools; this script only does per-user setup.
#
# Safe to re-run: each step skips or updates work that's already done.
set -euo pipefail

DOTFILES="$(dirname "$(realpath "$0")")"
LOG="${HOME}/.cache/dotfiles-bootstrap.log"
BACKUP="${HOME}/dotfiles_old/$(date +%Y%m%d-%H%M%S)"
BOX="dev"

# Top-level directories in the repo that are NOT stow packages.
STOW_EXCLUDE=(images)

mkdir -p "$(dirname "$LOG")"

log()  { echo "$*" | tee -a "$LOG"; }
step() { echo | tee -a "$LOG"; log "==> $*"; }
run()  { "$@" >>"$LOG" 2>&1; }          # quiet: output to log only
show() { "$@" 2>&1 | tee -a "$LOG"; }   # long steps: output to screen and log

clone_or_update() {
  local url=$1 dest=$2
  if [ -d "$dest/.git" ]; then
    run git -C "$dest" pull --ff-only
  else
    run git clone --depth 1 "$url" "$dest"
  fi
}

# Move aside only the files that would conflict with a stow package,
# preserving their paths under $BACKUP. Files already provided by this repo
# (including through a symlinked parent directory) are left alone.
backup_conflicts() {
  local pkg=$1 rel target
  while IFS= read -r rel; do
    target="$HOME/$rel"
    [[ "$(realpath -m "$target")" == "$DOTFILES/"* ]] && continue
    if [ -e "$target" ] || [ -L "$target" ]; then
      mkdir -p "$BACKUP/$(dirname "$rel")"
      mv "$target" "$BACKUP/$rel"
      log "  backed up ~/$rel"
    fi
  done < <(cd "$DOTFILES/$pkg" && find . -mindepth 1 -not -path '*/.git/*' \
             -not -name .git \( -type f -o -type l \) -printf '%P\n')
}

#################################################
step "Checking host tools"
missing=()
for cmd in zsh stow nvim tmux toolbox podman flatpak git curl; do
  command -v "$cmd" >/dev/null || missing+=("$cmd")
done
if (( ${#missing[@]} )); then
  echo "Missing on host: ${missing[*]}" >&2
  echo "Build and boot the custom image first (see $DOTFILES/images/)." >&2
  exit 1
fi
log "OK"

#################################################
step "Desktop apps (Flatpak)"
read -rp "Install desktop apps from flatpaks.txt? [y/N] " yn
if [[ ${yn:-n} =~ ^[Yy]$ ]]; then
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  { grep -Ev '^\s*(#|$)' "$DOTFILES/images/flatpaks.txt" || true; } |
    xargs -r flatpak install -y --noninteractive flathub
else
  log "Skipping"
fi

#################################################
step "User-level tools on the host (uv, node, fzf, plugin managers)"

# uv: installs to ~/.local/bin; never edits shell rc files
if [ -x "$HOME/.local/bin/uv" ]; then
  run "$HOME/.local/bin/uv" self update || true
else
  curl -LsSf https://astral.sh/uv/install.sh |
    env UV_NO_MODIFY_PATH=1 INSTALLER_NO_MODIFY_PATH=1 sh >>"$LOG" 2>&1
fi
log "  uv"

# Claude Code: installs to ~/.local/bin and updates itself. The home dir is
# shared with toolboxes, so this one install covers the host and every box.
if [ ! -x "$HOME/.local/bin/claude" ]; then
  curl -fsSL https://claude.ai/install.sh | bash >>"$LOG" 2>&1
fi
log "  claude"

# nvm + latest node (PROFILE=/dev/null: don't touch rc files)
if [ ! -s "$HOME/.nvm/nvm.sh" ]; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh |
    PROFILE=/dev/null bash >>"$LOG" 2>&1
fi
run bash -c 'export NVM_DIR="$HOME/.nvm"; . "$NVM_DIR/nvm.sh"; nvm install node'
log "  nvm + node"

# fzf from git (newer than distro packages); writes ~/.fzf.zsh, not ~/.zshrc
clone_or_update https://github.com/junegunn/fzf.git "$HOME/.fzf"
run "$HOME/.fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
log "  fzf"

# vim-plug and tpm live inside their stow packages, as before
if [ -d "$DOTFILES/vim" ]; then
  run curl -fsSLo "$DOTFILES/vim/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  log "  vim-plug"
fi
if [ -d "$DOTFILES/tmux" ]; then
  clone_or_update https://github.com/tmux-plugins/tpm "$DOTFILES/tmux/.tmux/plugins/tpm"
  log "  tpm"
fi

#################################################
step "Dev box '$BOX' (first build takes a while)"
if podman container exists "$BOX" 2>/dev/null; then
  log "Already exists (recreate with images/rebuild_toolbox.sh)"
else
  show "$DOTFILES/images/rebuild_toolbox.sh"
fi

#################################################
step "Rust and cargo tools (built in '$BOX', usable everywhere via ~/.cargo/bin)"
RUST_SETUP=$(cat <<'EOF'
set -e
if [ -x "$HOME/.cargo/bin/rustup" ]; then
  "$HOME/.cargo/bin/rustup" update
else
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi
"$HOME/.cargo/bin/cargo" install --locked csvlens git-absorb
EOF
)
show toolbox run -c "$BOX" bash -c "$RUST_SETUP"

#################################################
step "R packages and radian (in '$BOX')"
R_SETUP=$(cat <<'EOF'
pkgs  <- c("httpgd")
# httpgd is distributed via r-universe; CRAN is the fallback for everything else
repos <- c("https://nx10.r-universe.dev", "https://cloud.r-project.org")
lib <- Sys.getenv("R_LIBS_USER")
dir.create(lib, recursive = TRUE, showWarnings = FALSE)
.libPaths(lib)
missing <- setdiff(pkgs, rownames(installed.packages()))
if (length(missing)) install.packages(missing, lib = lib, repos = repos)
EOF
)
show toolbox run -c "$BOX" Rscript -e "$R_SETUP"
show toolbox run -c "$BOX" bash -c 'pipx install radian || pipx upgrade radian'

################################################## 
step "downloading updated zsh plugins"
for f in "$HOME/resolve_zsh_plugins.sh" "$DOTFILES/zsh/resolve_zsh_plugins.sh"; do
  if [ -x "$f" ]; then
    (cd "$HOME" && run "$f")
    log "  zsh plugins"
    break
  fi
done

#################################################
step "Stowing dotfiles (conflicts backed up to $BACKUP)"
for dir in "$DOTFILES"/*/; do
  pkg=$(basename "$dir")
  [[ " ${STOW_EXCLUDE[*]} " == *" $pkg "* ]] && continue
  backup_conflicts "$pkg"
  stow --dir="$DOTFILES" --target="$HOME" --restow "$pkg"
  log "  $pkg"
done

#################################################
step "Plugins and post-stow setup"

if [ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]; then
  run "$HOME/.tmux/plugins/tpm/bin/install_plugins"
  log "  tmux plugins"
fi


# Only configure git-lfs if your stowed .gitconfig doesn't already
if ! git config --global --get filter.lfs.process >/dev/null; then
  run git lfs install
  log "  git-lfs (commit the resulting .gitconfig change)"
fi

run tldr --update || true
log "  tldr cache"

#################################################
step "Login shell"
ZSH_PATH=$(command -v zsh)
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$ZSH_PATH" ]; then
  sudo usermod -s "$ZSH_PATH" "$USER"
  log "Set to $ZSH_PATH (log out and back in to apply)"
else
  log "Already $ZSH_PATH"
fi

#################################################
step "All done"
log "Log: $LOG"
