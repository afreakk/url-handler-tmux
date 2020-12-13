# urlHandler.tmux

Url handler will search the currently visible Tmux buffer for URLs.
The 10 most recent links will be shown in dmenu configured app (rofi by default).
Selected element will go through:
```
case "$selected" in
  *mkv|*webm|*mp4|*youtube.com/watch*|*youtube.com/playlist*|*youtu.be*|*hooktube.com*|*bitchute.com*|*videos.lukesmith.xyz*)
    eval $TUBE_VIEW_CMD ;;
  *png|*jpg|*jpe|*jpeg|*gif)
    eval $IMG_VIEW_CMD ;;
  *)
    eval $DEFAULT_CMD
esac
```
So you can specify what you want to do with the URL in one of
`@primary-default-cmd` `@primary-img-view-cmd` `@primary-tube-view-cmd` (all of them is `setsid -f $BROWSER $selected > /dev/null 2>&1` by default)
or
`@alternate-default-cmd` `@alternate-img-view-cmd` `@alternate-tube-view-cmd` (all of them is `echo -n $selected | xclip -i -sel p -f | xclip -i -sel c` by default)

primary is bound to `prefix + u` by default, but can be changed by setting `@primary-url-handler-hotkey`
alternate is bound to `prefix + u` by default, but can be changed by setting `@alternate-url-handler-hotkey`

## Installation

Add to `~/.tmux.conf`:
```
# optional set -g options
set -g @dmenu-cmd 'dmenu -l 10'
set -g @primary-img-view-cmd 'setsid -f feh $selected > /dev/null'
set -g @primary-tube-view-cmd 'setsid -f mpv $selected > /dev/null'
# this line is required
run-shell /path/to/url_handler_tmux.tmux
```

## Dependencies

- [tmux](https://github.com/tmux/tmux)
- [rofi](https://github.com/davatorium/rofi) (not required if you set another @dmenu-cmd)
- xclip (only required if you want to use the default alternate copy cmd)
- tr
- sed
- uniq
- grep
- tac
