hook global BufCreate .*\.ua %{
	set-option buffer filetype uiua
}

# config-set-formatter uiua 'uiua fmt --io'

hook -group lsp-filetype-uiua global BufSetOption filetype=uiua %{
	set-option buffer lsp_servers %{
		[uiua-lsp]
		command = "uiua"
		args = ["lsp"]
		root_globs = [".git", ".hg"]
	}
}
