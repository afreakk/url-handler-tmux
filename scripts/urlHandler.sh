#!/usr/bin/env bash

DMENU_CMD=$1
DEFAULT_CMD=$2
IMG_VIEW_CMD=$3
TUBE_VIEW_CMD=$4

# Regex to look for common URL patterns.
urlregex="(((http|https)://|www\\.)[a-zA-Z0-9.]+[:]?[a-zA-Z0-9./@$&%?~\\+\\(\\)!,:#=_-]+)"

# Capture input
capturePaneArgs=( -Jp )
current_pane=$(tmux list-panes -F "#{pane_active}|#{scroll_position}|#{pane_height}" | grep "^1|")
scroll_position=$(echo "$current_pane" | cut -d\| -f2)
if [ -n "$scroll_position" ]; then
  pane_height=$(echo "$current_pane" | cut -d\| -f3)
  capturePaneArgs+=(
      -S "-$scroll_position"
      -E $(( "$pane_height" - "$scroll_position" - 1))
  )
fi
input=$(tmux capture-pane "${capturePaneArgs[@]}")

# Check and clean input from weechat TUI client
if echo -e "$input" | grep -q -E '^.+│.+\|\s.*\s│.*$'; then
  input=$(echo -e "$input" |         # Print the original input
    sed -r 's/^(\s+|.+│.+\|\s)//g' | # Strip the channel bar and user info
    sed -r 's/\s│.*//g' |            # Strip the trailing bar & users
    tr -d '\n')                      # Remove newlines in order to handle wrapped urls
fi

# Extract URLs from the currently visible Tmux buffer
urls=$(echo -e "$input" |	  # Print the modified input
  grep -aEo "$urlregex" |         # Grep only URLs as defined above.
  uniq |                          # Remove neighboring duplicates.
  sed 's|^www\.|http://www\.|g' | # Prefix url starting with 'www.' with http://.
  tac)                            # Reverse the link order.

# If no URLs were found exit.
[ -z "$urls" ] && tmux display 'url-handler-tmux: no URLs found' && {
   exit
}

# Show the 10 newest links in rofi for interactive selection.
selected="$(echo "$urls" | $DMENU_CMD)"

[ -z "$selected" ] && tmux display 'url-handler-tmux: no URLs selected' && {
   exit
}

case "$selected" in
  *mkv|*webm|*mp4|*youtube.com/watch*|*youtube.com/playlist*|*youtu.be*|*hooktube.com*|*bitchute.com*|*videos.lukesmith.xyz*|*yewtu.be*)
    echo "$selected" | $TUBE_VIEW_CMD ;;
  *png|*jpg|*jpe|*jpeg|*gif)
    echo "$selected" | $IMG_VIEW_CMD ;;
  *)
    echo "$selected" | $DEFAULT_CMD
esac
