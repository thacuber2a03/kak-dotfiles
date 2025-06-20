hook global BufCreate .+\.ld$ %{
	set-option buffer filetype ld
	set-option buffer tree_sitter_lang ld
}
