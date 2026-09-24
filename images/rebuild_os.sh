#!/usr/bin/env bash
# rebuild_os.sh: rebuild the custom Kinoite image and stage it with bootc.
#
# Usage:
#   ./rebuild_os.sh            build + stage; reboot manually afterwards
#   ./rebuild_os.sh --reboot   build + stage + reboot automatically
set -euo pipefail

IMAGE="localhost/os_image"

# Use the directory this script lives in as the build context, resolved to a
# real absolute path (e.g. /var/home/...), so it works from anywhere and on
# any machine you clone the repo to.
CONTEXT="$(dirname "$(realpath "$0")")"
CONTAINERFILE="$CONTEXT/Containerfile_os"

REBOOT=false
if [[ "${1:-}" == "--reboot" ]]; then
    REBOOT=true
elif [[ -n "${1:-}" ]]; then
    echo "Unknown option: $1" >&2
    echo "Usage: $0 [--reboot]" >&2
    exit 1
fi

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

# echo "==> Removing unused images"
# sudo podman image prune -f

echo
sudo bootc status

if $REBOOT; then
    echo "==> Rebooting"
    systemctl reboot
else
    echo
    echo "Done. Reboot to boot into the new image:  systemctl reboot"
fi
