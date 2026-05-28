config-enable-lsp-support gleam %{
	[gleam-lsp]
	root_globs = ["gleam.toml", ".git", ".hg"]
	command = "gleam"
	args = ["lsp"]
}

hook global WinSetOption filetype=gleam %{
	try %{
		set-option -add window ui_whitespaces_flags -spc ' '
		ui-whitespaces-toggle
		ui-whitespaces-toggle
	}

	set-option buffer indentwidth 2
}

