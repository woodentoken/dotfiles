#!/usr/bin/env bash
# rebuild_os.sh: rebuild the custom Kinoite image on GitHub Actions, then
# stage the published image from ghcr.io with bootc.
#
# Usage:
#   ./rebuild_os.sh                build remotely + stage; reboot manually afterwards
#   ./rebuild_os.sh --reboot       build remotely + stage + reboot automatically
#   ./rebuild_os.sh --no-build     skip the remote build, just stage the latest published image
set -euo pipefail

IMAGE="ghcr.io/woodentoken/os_image:latest"
REPO="woodentoken/dotfiles"
WORKFLOW="build-os.yml"
BRANCH="master"

usage() {
    echo "Usage: $0 [--reboot] [--no-build]" >&2
}

REBOOT=false
BUILD=true
for arg in "$@"; do
    case "$arg" in
        --reboot)   REBOOT=true ;;
        --no-build) BUILD=false ;;
        *)
            echo "Unknown option: $arg" >&2
            usage
            exit 1
            ;;
    esac
done

if $BUILD; then
    if ! command -v gh >/dev/null; then
        echo "gh CLI not found; install it or use --no-build" >&2
        exit 1
    fi

    # The workflow only pushes when it runs on master, so building any other
    # branch would never produce a new image.
    echo "==> Triggering $WORKFLOW on $REPO@$BRANCH"
    before="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    gh workflow run "$WORKFLOW" --repo "$REPO" --ref "$BRANCH"

    # gh workflow run doesn't return the run ID, so poll for the run it created.
    run_id=""
    for _ in {1..30}; do
        run_id="$(gh run list --repo "$REPO" --workflow "$WORKFLOW" \
            --branch "$BRANCH" --event workflow_dispatch --limit 1 \
            --json databaseId,createdAt \
            --jq ".[] | select(.createdAt >= \"$before\") | .databaseId")"
        [[ -n "$run_id" ]] && break
        sleep 2
    done
    if [[ -z "$run_id" ]]; then
        echo "Could not find the triggered workflow run" >&2
        exit 1
    fi

    echo "==> Waiting for run $run_id"
    gh run watch "$run_id" --repo "$REPO" --exit-status
fi

# Ask for the sudo password once, up front.
sudo -v

# switch (rather than upgrade) so the first run moves bootc off any previous
# image ref; on later runs it behaves like an upgrade of the same ref.
echo "==> Staging $IMAGE"
sudo bootc switch "$IMAGE"

echo
sudo bootc status

if $REBOOT; then
    echo "==> Rebooting"
    systemctl reboot
else
    echo
    echo "Done. Reboot to boot into the new image:  systemctl reboot"
fi
