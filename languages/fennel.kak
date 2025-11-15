config-set-formatter fennel 'fnlfmt -'

define-command -docstring "
	fennel-repl: opens a new Fennel REPL session that automatically gets closed when it ends
" fennel-repl -params 0 %{
	try %{
		# if user has kakoune-repl-buffer
		repl-buffer-new -name *fennel-repl* -- env TERM=dumb fennel
		hook -once -always window BufCloseFifo %{ delete-buffer! %val{bufname} }
	} catch %{
		config-log unable to open repl-buffer: %val{error}
		repl-new env TERM=dumb fennel
	} catch %{
		fail "unable to open repl: %val{error}"
	}
}

define-command -docstring "
	fennel-preview <buffer>: compiles the fennel code at <buffer> in a separate, scratch buffer;
	uses the current buffer if <buffer> is unspecified
" fennel-preview -params 0..1 %{
	evaluate-commands -save-regs 'a' %{
		set-register a %val{buffile}
		evaluate-commands %sh{ [ -n "$1" ] && printf %s "set-register a '$1'" }
		fifo -name '*fennel*' fennel -c %reg{a}
		set-option buffer filetype lua
	}
}

complete-command fennel-preview file 1

hook global BufCreate .*/home/.+?/.fennelrc %{ set-option buffer filetype fennel }

hook -group	lsp-filetype-fennel global BufSetOption filetype=fennel %{
	set-option buffer lsp_servers %{
		[fennel-ls]
		root_globs = [".git", ".hg", "flsproject.fnl", "main.fnl"]
	}
}

hook global WinSetOption filetype=fennel %{
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

