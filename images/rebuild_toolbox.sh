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

# Claude lives in the shared home (installed by bootstrap.sh), not the image.
# Login shell so ~/.local/bin is on PATH via .profile.
if ! toolbox run -c "$NAME" bash -lc 'command -v claude' >/dev/null 2>&1; then
    echo "Warning: claude not found in '$NAME'; install it with:" >&2
    echo "  curl -fsSL https://claude.ai/install.sh | bash" >&2
fi

echo "==> Removing dangling images"
podman image prune -f

echo
toolbox list
