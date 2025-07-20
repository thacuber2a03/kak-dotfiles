# kak-dotfiles

my Kakoune dotfiles

## installation

clone the repository as `~/.config/kak`. then, open Kakoune, run `bundle-install`, wait for the installation to end, and restart Kakoune.

some other plugins do have extra files:

- `kakoune-lsp` requires [`cargo`](https://www.rust-lang.org/learn/get-started)
- anything Uiua-related requires installing [Uiua](https://uiua.org) itself
- `languages/fennel.kak`'s format command requires installing [fnlfmt](https://git.sr.ht/~technomancy/fnlfmt)
- `Encapsul8` has [`jq`](https://github.com/jqlang/jq) as an optional, but I recommend it
