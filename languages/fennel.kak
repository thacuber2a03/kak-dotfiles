config-set-formatter fennel 'fnlfmt -'

hook -group	lsp-filetype-fennel global BufSetOption filetype=fennel %{
	# set-option buffer lsp_servers %{
	# 	[fennel-ls]
	# 	root_globs = [".git", ".hg", "flsproject.fnl", "main.fnl"]
	# }
}

hook global WinSetOption filetype=fennel %{
	define-command -override -docstring "
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

	# patch to indent hook in Fennel, according to its Style Guide
	# TODO(thacuber2a03): not proper, should eventually merge into master

	define-command -hidden fennel-patch-indent-on-new-line %{
# registers: i = best align point so far; w = start of first word of form
		evaluate-commands -draft -save-regs '/"|^@iw' -itersel %{
			execute-keys -draft 'gk"iZ'
			try %{
				execute-keys -draft '[bl"i<a-Z><gt>"wZ'

				# literally the only change was swapping these two branches
				try %{
					# If not special and parameter appears on line 1, indent to parameter
					execute-keys -draft '"wz<a-K>[()[\]{}]<ret>e<a-K>[\s()\[\]\{\}]<ret><a-l>s\h\K[^\s].*<ret><a-;>;"i<a-Z><gt>'
				} catch %{
					# If a special form, indent another (indentwidth - 1) spaces
					execute-keys -draft '"wze<a-K>[\s()\[\]\{\}]<ret><a-k>\A' %opt{fennel_special_indent_forms} '\z<ret>'
					execute-keys -draft '"wze<a-L>s.{' %sh{printf $(( kak_opt_indentwidth - 1 ))} '}\K.*<ret><a-;>;"i<a-Z><gt>'
				}
			}
			try %{ execute-keys -draft '[rl"i<a-Z><gt>' }
			try %{ execute-keys -draft '[Bl"i<a-Z><gt>' }
			execute-keys -draft ';"i<a-z>a&,'
		}
	}

	require-module fennel
	remove-hooks window fennel-indent
    hook window InsertChar \n -group fennel-indent fennel-patch-indent-on-new-line
}

