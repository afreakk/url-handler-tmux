#!/usr/bin/env bash


DMENU_CMD=$1
DEFAULT_CMD=$2
IMG_VIEW_CMD=$3
TUBE_VIEW_CMD=$4

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
[ -z "$urls" ] && exit 0

# Show the 10 newest links in rofi for interactive selection.
selected="$(echo "$urls" | $DMENU_CMD)"

[ -z "$selected" ] && exit

case "$selected" in
  *mkv|*webm|*mp4|*youtube.com/watch*|*youtube.com/playlist*|*youtu.be*|*hooktube.com*|*bitchute.com*|*videos.lukesmith.xyz*)
    eval $TUBE_VIEW_CMD ;;
  *png|*jpg|*jpe|*jpeg|*gif)
    eval $IMG_VIEW_CMD ;;
  *)
    eval $DEFAULT_CMD
esac
