config-enable-lsp-support revo %{
	[revo-lsp]
	command = "revo"
	args = ["--lsp"]
	root_globs = [".git", "exe.json"]
}

hook global WinSetOption filetype=revo %{
	config-set-indentwidth 4
	lsp-inlay-hints-disable window
}
