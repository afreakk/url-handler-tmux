#! /usr/bin/env bash

set -euo pipefail

# Regex to look for common URL patterns.
urlregex="(((http|https)://|www\\.)[a-zA-Z0-9.]+[:]?[a-zA-Z0-9./@$&%?~\\+!,:#=_-]+)"

# Extract URLs from the currently visible Tmux buffer
urls="$(tmux capture-pane -Jp |               # Capture the currently visible Tmux contents.
	tr -d '\n' | sed -r 's/\s│\s+│\s+\|\s//g' | # Remove newlines and TUI sidebars.
	grep -aEo "$urlregex" |                     # Grep only URLs as defined above.
	uniq |                                      # Remove neighboring duplicates.
	sed 's/^www./http:\/\/www\./g' |
	tac)"                                       # Reverse the link order.

# If no URLs were found exit.
[ -z "$urls" ] && exit

# Show the 10 newest links in rofi for interactive selection.
selected="$(echo "$urls" | rofi -dmenu -i -p 'Open URL' -l 10)"

# If a URL is selected open it.
if [[ $selected != "" ]]; then
  # Find the current directory path.
  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

  # Check if app.sh is present and if it's executable.
  if [[ -x "$CURRENT_DIR/app.sh" ]]; then
    setsid sh -c "$CURRENT_DIR/app.sh $selected"
  else
    setsid $BROWSER "$selected" >/dev/null 2>&1 &
  fi
fi
