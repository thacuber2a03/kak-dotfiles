config-set-formatter fennel 'fnlfmt -'

hook -group	lsp-filetype-fennel global BufSetOption filetype=fennel %{
	# set-option buffer lsp_servers %{
	# 	[fennel-ls]
	# 	root_globs = [".git", ".hg", "flsproject.fnl", "main.fnl"]
	# }
}

define-command -docstring "
	fennel-preview <buffer>: compiles the fennel code at <buffer> in a separate, scratch buffer;
	uses the current buffer if <buffer> is unspecified
" -params 0..1 fennel-preview %{
	evaluate-commands -save-regs 'a' %{
		set-register a %val{buffile}
		evaluate-commands %sh{ [ -n "$1" ] && printf %s "set-register a '$1'" }
		fifo -name '*fennel*' fennel -c %reg{a}
		set-option buffer filetype lua
	}
}
