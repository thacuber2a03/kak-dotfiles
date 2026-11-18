bundle-install-hook kakoune-discord %{ cargo install --path . }
bundle-cleaner kakoune-discord %{ cargo uninstall kakoune-discord }
discord-presence-enable
