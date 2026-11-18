bundle-install-hook kak-dap %{ cargo install --locked --path . }
bundle-cleaner kak-dap %{ cargo uninstall --locked kak-dap }

map global user x -docstring 'dap' ': enter-user-mode dap<ret>'
