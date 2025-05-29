hook -group lsp-filetype-odin global BufSetOption filetype=odin %{
	set-option buffer lsp_servers %{
		[ols]
		command = "ols"
		args = []
		root_globs = [".git", "ols.json", "main.odin"]
	}
}
