#!/usr/bin/env bash
# rebuild_toolbox.sh: rebuild the custom Kinoite image and stage it with bootc.
#
# Usage:
#   ./rebuild_toolbox.sh            build + stage; reboot manually afterwards
#   ./rebuild_toolbox.sh --reboot   build + stage + reboot automatically
set -euo pipefail

IMAGE="localhost/toolbox_image"

# Use the directory this script lives in as the build context, resolved to a
# real absolute path (e.g. /var/home/...), so it works from anywhere and on
# any machine you clone the repo to.
CONTEXT="$(dirname "$(realpath "$0")")"
CONTAINERFILE="$CONTEXT/Containerfile_toolbox"

if [[ ! -f "$CONTAINERFILE" ]]; then
    echo "No Containerfile found at $CONTAINERFILE" >&2
    exit 1
fi

# Ask for the sudo password once, up front.
sudo -v

echo "==> Building $IMAGE from $CONTAINERFILE"
sudo podman build \
    --pull=newer \
    -f "$CONTAINERFILE" \
    -t "$IMAGE" \
    "$CONTEXT"

echo "==> Staging new deployment"
sudo bootc upgrade

echo "==> Removing unused images"
sudo podman image prune -f

echo
sudo bootc status
