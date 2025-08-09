bundle-install-hook kakoune-discord %{ cargo install --path . --force }
bundle-cleaner kakoune-discord %{ cargo uninstall kakoune-discord }
discord-presence-enable
