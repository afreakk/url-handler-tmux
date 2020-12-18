#!/usr/bin/env bash

set -euo pipefail

# $1: option
# $2: default value
tmux_get() {
    local value
    value="$(tmux show -gqv "$1")"
    [ -n "$value" ] && echo "$value" || echo "$2"
}

DMENU_CMD="$(tmux_get '@dmenu-cmd' 'rofi -dmenu -i -p \"Open URL\" -l 10')"

PRIMARY_DEFAULT_CMD="$(tmux_get '@primary-default-cmd' 'setsid -f $BROWSER $selected > /dev/null 2>&1')"
PRIMARY_IMG_VIEW_CMD="$(tmux_get '@primary-img-view-cmd' "$PRIMARY_DEFAULT_CMD")"
PRIMARY_TUBE_VIEW_CMD="$(tmux_get '@primary-tube-view-cmd' "$PRIMARY_DEFAULT_CMD")"
PRIMARY_HOTKEY="$(tmux_get '@primary-url-handler-hotkey' 'u')"

ALTERNATE_DEFAULT_CMD="$(tmux_get '@alternate-default-cmd' 'echo -n $selected | xclip -in -selection primary -f | xclip -in -selection clipboard &>/dev/null')"
ALTERNATE_IMG_VIEW_CMD="$(tmux_get '@alternate-tube-view-cmd' "$ALTERNATE_DEFAULT_CMD")"
ALTERNATE_TUBE_VIEW_CMD="$(tmux_get '@alternate-tube-view-cmd' "$ALTERNATE_DEFAULT_CMD")"
ALTERNATE_HOTKEY="$(tmux_get '@alternate-url-handler-hotkey' 'U')"


CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmux bind-key   "$PRIMARY_HOTKEY" run-shell -b "$CURRENT_DIR/scripts/urlHandler.sh '$DMENU_CMD'   '$PRIMARY_DEFAULT_CMD'   '$PRIMARY_IMG_VIEW_CMD'   '$PRIMARY_TUBE_VIEW_CMD'"
tmux bind-key "$ALTERNATE_HOTKEY" run-shell -b "$CURRENT_DIR/scripts/urlHandler.sh '$DMENU_CMD' '$ALTERNATE_DEFAULT_CMD' '$ALTERNATE_IMG_VIEW_CMD' '$ALTERNATE_TUBE_VIEW_CMD'"
