config-set-formatter fennel 'fnlfmt -'

hook -group	lsp-filetype-fennel global BufSetOption filetype=fennel %{
	set-option buffer lsp_servers %{
		[fennel-ls]
		root_globs = [".git", ".hg", "flsproject.fnl", "main.fnl"]
	}
}
