# urlHandler.tmux

Simple URL handler plugin for Tmux. The plugin will search the currently visible Tmux buffer for URLs.
The 10 newest links discovered will be shown in rofi in descending order. Upon Selection the URL will
be opened using the browser configured in the `$BROWSER` environment variable.

If you want certain URLs to be opened using a custom application you should create a script named `app.sh`
in the [/scripts](./scripts) directory and make it executable. Then add specific application logic here.
For an idea on how this can be done take a look at the [app.sh_example](./scripts/app.sh_example) file which
shows custom logic for opening URLs ending with image extensions and opening them with `feh`.

## Usage

The plugin can be activated by executing `./urlHandler.tmux` After this the functionality can be invoked by
using the `prefix + u` keybinding.

## Dependencies

- [tmux](https://github.com/tmux/tmux)
- [rofi](https://github.com/davatorium/rofi)
- tr
- sed
- uniq
- grep
- tac
