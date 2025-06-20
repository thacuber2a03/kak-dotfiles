hook global BufCreate .+\.hx$ %{
	set-option buffer filetype haxe
	set-option buffer tree_sitter_lang haxe
}
