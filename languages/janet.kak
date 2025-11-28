config-set-formatter janet 'janet-format'
# config-set-linter    janet 'janet -w strict' # I'm not sure how Janet's linter works

hook -group lsp-filetype-janet global BufSetOption filetype=janet %{
	set-option buffer lsp_servers %{
		[janet-lsp]
		root_globs = [".git", ".hg", "main.janet"]
	}
}

hook global WinSetOption filetype=janet %{
	set-option buffer parinfer_extra_flags \
		--comment-char '#' --janet-long-strings

	config-setup-lisp-mode
}
