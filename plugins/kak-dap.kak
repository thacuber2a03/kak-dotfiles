bundle-install-hook kak-dap %{ cargo install --locked --force --path . }
bundle-cleaner      kak-dap %{ cargo uninstall kak-dap }
