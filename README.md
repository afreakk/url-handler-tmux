# urlHandler.tmux

Simple URL handler plugin for Tmux. The plugin will search the currently visible Tmux buffer for URLs.
The 10 newest links discovered will be shown in rofi in descending order. Upon Selection the URL will
be opened using the browser configured in the `$BROWSER` environment variable.

## Usage

The plugin can be activated by executing `./url_handler_tmux.tmux` After this the functionality can be invoked by
using the `prefix + u` keybinding.

## Options

To specify what app to use for opening urls like
`*mkv|*webm|*mp4|*youtube.com/watch*|*youtube.com/playlist*|*youtu.be*|*hooktube.com*|*bitchute.com*|*videos.lukesmith.xyz`
```
set -g @tube-view-cmd 'mpv'
```
To specify what app to use for opening urls like
`*png|*jpg|*jpe|*jpeg|*gif`
```
set -g @img-view-cmd 'feh'
```
To specify what app to use for opening the rest of urls
```
set -g @default-cmd 'chromium'
```

Everyone of them defaults to $BROWSER if unspecified

## Dependencies

- [tmux](https://github.com/tmux/tmux)
- [rofi](https://github.com/davatorium/rofi)
- tr
- sed
- uniq
- grep
- tac
