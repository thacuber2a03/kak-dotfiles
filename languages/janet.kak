config-set-formatter janet 'janet-format'
# config-set-linter    janet 'janet -w strict' # I'm not sure how Janet's linter works

config-enable-lsp-and-ts janet %{
	[janet-lsp]
	root_globs = [".git", ".hg", "main.janet"]
}

hook global WinSetOption filetype=janet %{
	set-option buffer parinfer_extra_flags \
		--comment-char '#' --janet-long-strings

	config-setup-lisp-mode
}

define-command -docstring "
	janet-repl: opens a new Janet REPL session that automatically gets closed when it ends
" janet-repl -params 0 %{
	# try %{
	# 	new repl-buffer-new -name '*janet-repl*' -- janet -s -r
	# 	hook -once -always buffer BufCloseFifo .* %{ delete-buffer! %val{bufname} }
	# } catch %{
	# 	config-trace-log "unable to open repl-buffer for Janet: %val{error}"
		repl-new janet
	# }
}
