bundle-install-hook kak-tree-sitter %{ cargo install kak-tree-sitter }

eval %sh{ kak-tree-sitter -dks --init $kak_session }
