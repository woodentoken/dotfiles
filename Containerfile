# Host OS image: Fedora Kinoite + tools needed outside any container.
#
# Rule of thumb: if you don't need it before/outside a distrobox, it belongs
# in distrobox.ini instead. Keep your current FROM tag (match `rpm-ostree status`).
FROM quay.io/fedora-ostree-desktops/kinoite:44

# Shell & editors:   zsh neovim vim-enhanced tmux stow gcc (gcc: nvim plugin builds)
# Git & env:         git-lfs direnv distrobox
# CLI utilities:     bat fd-find ripgrep tree nnn tealdeer (tldr) fastfetch (neofetch)
#                    cowsay prename (Debian-style `rename`) chafa (tiv)
# Desktop/system:    wl-clipboard xclip net-tools openssh-server zip unzip
#
# The cache mount keeps dnf metadata between builds (faster rebuilds) without
# putting it in the image.
RUN --mount=type=cache,target=/var/cache/libdnf5 \
    dnf install -y \
        bat \
	cowsay \
	direnv \
	distrobox \
	fastfetch \
	fd-find \
	gcc \
        git-lfs \
	neovim \
	net-tools \
	ripgrep \
	stow \
	tealdeer \
	tmux \
	tree \
	unzip \
        wl-clipboard \
	xclip \
	zip \
        zsh && \
    rm -rf /var/lib/dnf /var/log/dnf5.log /var/cache/ldconfig/aux-cache \
           /run/dnf /tmp/*

RUN bootc container lint

