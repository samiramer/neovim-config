# My Neovim config

Git clone this repo to `$HOME/.config/nvim` folder and then launch `nvim`.

```bash
> git clone git@github.com:samiramer/neovim-config.git $HOME/.config/nvim
> nvim
```

On first load, you will get a message telling you plugins are about to be installed.  Press `ENTER` and let it run.

Then close `nvim` and re-open.  You should start to see some treesitter parsers and language servers get installed.  Give them a chance to finish.

Then close `nvim` again and re-open.  There might some more parsers that will get installed, let it finish.

Then close `nvim` AGAIN and re-open.  You should be good to go from there.

## TODO
- Make the first load experience smoother
- Lazy load plugins, for faster startup time.
