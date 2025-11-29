bundle-install-hook kak-dap         %{ cargo install --locked --force --path . }
bundle-cleaner      kak-tree-sitter %{ cargo uninstall kak-dap }

# evaluate-commands %sh{ kak-dap --kakoune -s $kak_session }
