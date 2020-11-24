#! /usr/bin/env bash

set -euo pipefail

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmux bind-key u run-shell "$CURRENT_DIR/scripts/urlHandler.sh"
