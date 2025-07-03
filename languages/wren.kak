hook -group	lsp-filetype-wren global BufSetOption filetype=wren %{
	set-option buffer lsp_servers %{
		[wren-lsp]
		root_globs = [".git", ".hg", "main.wren"]
	}
}
