bundle-install-hook kak-tree-sitter %{
	cargo install --force kak-tree-sitter
	cargo install --force ktsctl
}

bundle-cleaner kak-tree-sitter %{
	cargo uninstall kak-tree-sitter
	cargo uninstall ktsctl
}

evaluate-commands %sh{ kak-tree-sitter -dks -vvvvv --init $kak_session }
