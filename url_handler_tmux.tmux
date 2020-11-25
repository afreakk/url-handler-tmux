#! /usr/bin/env bash

set -euo pipefail

# $1: option
# $2: default value
tmux_get() {
    local value
    value="$(tmux show -gqv "$1")"
    [ -n "$value" ] && echo "$value" || echo "$2"
}

DEFAULT_CMD="$(tmux_get '@default-cmd' $BROWSER)"
IMG_VIEW_CMD="$(tmux_get '@img-view-cmd' $BROWSER)"
TUBE_VIEW_CMD="$(tmux_get '@tube-view-cmd' $BROWSER)"
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmux bind-key u run-shell "$CURRENT_DIR/scripts/urlHandler.sh '$DEFAULT_CMD' '$IMG_VIEW_CMD' '$TUBE_VIEW_CMD'"
