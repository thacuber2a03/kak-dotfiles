config-set-formatter fennel 'fnlfmt -'

hook -group	lsp-filetype-fennel global BufSetOption filetype=fennel %{
	# kakoune-lsp has issues with it and I have no idea why
	# set-option buffer lsp_servers %{
	# 	[fennel-ls]
	# 	root_globs = [".git", ".hg", "flsproject.fnl", "main.fnl"]
	# }
}

define-command -docstring "
	fennel-compile <buffer>: compiles the fennel code at <buffer> in a separate buffer,
	or the current buffer if unspecified
" -params 0..1 fennel-compile %{
	evaluate-commands -save-regs '"' %{
		evaluate-commands %sh{
			printf %s "set-register dquote '$1'"
			[ -z "$1" ] && printf %s "set-register dquote '$kak_buffile'"
		}
		echo -debug "fennel %reg{dquote}"
		fifo -name '*fennel*' "fennel %reg{dquote}"
	}
}
