# config-set-formatter uiua 'uiua fmt --io'

hook global BufSetOption filetype=uiua %{
	set-option buffer indentwidth 2
	set-option buffer tabstop 8
}

hook -group lsp-filetype-uiua global BufSetOption filetype=uiua %{
	set-option buffer lsp_servers %{
		[uiua-lsp]
		command = "uiua"
		args = ["lsp"]
		root_globs = [".git", "main.ua"]
	}
}
