# vimbox

vimbox is a plugin of miscellaneous commands and mappings that are too small
to be separate plugins. It's not intended for public use and therefore it has
hardly any documentation. But if you find any interesting ideas in vimbox
then feel free to copy those bits and pieces into your own vimrc.

# Install

Copy the project into bundle/ directory provided by your plugin manager
(Vundle, Pathogen) and make a symlink from vimrc to ~/.vimrc.

```
    cd ~/.vim/bundle
    git clone https://github.com/jasu0/vimbox
    ln -s vimbox/vimrc ~/.vimrc
```

## Notes

- When using `<Plug>` for mappings, you have to use `nmap` and not `nnoremap` commands
- Vundle needs `filetype off` defined before loading plugins. Otherwise it will
  not read sources from ftdetect.
