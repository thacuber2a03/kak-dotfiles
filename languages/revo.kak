config-enable-lsp-support revo %{
	[revo-lsp]
	command = "revo"
	args = ["--lsp"]
	root_globs = [".git", "exe.json"]
}

hook global WinSetOption filetype=revo %{
	set-option buffer indentwidth 2
	autowrap-enable
	set-option window autowrap_column 80
	lsp-inlay-hints-disable window
}
