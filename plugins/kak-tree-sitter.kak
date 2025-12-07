bundle-install-hook kak-tree-sitter %{
	cargo install --force kak-tree-sitter
	cargo install --force ktsctl
}

bundle-cleaner kak-tree-sitter %{
	cargo uninstall kak-tree-sitter
	cargo uninstall ktsctl
}

map global user t ':enter-user-mode tree-sitter<ret>' -docstring 'tree-sitter mode'
