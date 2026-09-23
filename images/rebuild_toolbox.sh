#!/usr/bin/env bash
# rebuild_toolbox.sh: rebuild the dev toolbox image and recreate the container.
#
# Usage: ./rebuild_toolbox.sh
# Note: anything installed by hand inside the old container is lost.
set -euo pipefail

IMAGE="localhost/toolbox_image"
NAME="dev"

CONTEXT="$(dirname "$(realpath "$0")")"
CONTAINERFILE="$CONTEXT/Containerfile_toolbox"

if [[ ! -f "$CONTAINERFILE" ]]; then
    echo "No Containerfile found at $CONTAINERFILE" >&2
    exit 1
fi

# No sudo: toolbox uses your user's container storage.
echo "==> Building $IMAGE from $CONTAINERFILE"
podman build --pull=newer -f "$CONTAINERFILE" -t "$IMAGE" "$CONTEXT"

if podman container exists "$NAME"; then
    echo "==> Removing existing toolbox '$NAME'"
    toolbox rm -f "$NAME"
fi

echo "==> Creating toolbox '$NAME'"
toolbox create --image "$IMAGE" "$NAME"

echo "==> Removing dangling images"
podman image prune -f

echo
toolbox list
