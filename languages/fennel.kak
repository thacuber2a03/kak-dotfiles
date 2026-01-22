provide-module config-fennel %§
	require-module fennel

	define-command -docstring "
		fennel-repl: opens a new Fennel REPL session that automatically gets closed when it ends
	" fennel-repl -params 0 %{
		# try %{
		# 	new repl-buffer-new -name '*fennel-repl*' -- env TERM=dumb fennel
		# 	hook -once -always buffer BufCloseFifo .* %{ delete-buffer! %val{bufname} }
		# } catch %{
		# 	config-trace-log "unable to open repl-buffer for Fennel: %val{error}"
			repl-new fennel
		# }
	}
	
	define-command -docstring "
		fennel-preview <buffer>: compiles the fennel code at <buffer> in a separate, scratch buffer;
		uses the current buffer if <buffer> is unspecified
	" fennel-preview -params 0..1 %{
		evaluate-commands -save-regs 'a' %{
			set-register a %val{buffile}
			evaluate-commands %sh{ [ -n "$1" ] && printf %s "set-register a '$1'" }
			fifo -name '*fennel-preview*' fennel --globals "*" -c %reg{a}
			set-option buffer filetype lua
		}
	}

	complete-command fennel-preview file 1

	# various patches to the Fennel highlighter
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

	try %{
		remove-hooks window fennel-indent
		hook -group fennel-indent window InsertChar \n fennel-patch-indent-on-new-line
	}

	remove-highlighter shared/fennel/code/keywords
	remove-highlighter shared/fennel/code/builtins

	evaluate-commands %sh{
		# Grammar
		keywords="require-macros eval-compiler doc lua hashfn macro macros import-macros pick-args pick-values macroexpand macrodebug
		          do values if when each for fn lambda λ partial while set global var local let tset set-forcibly! doto match or and
		          not not= collect icollect fcollect accumulate faccumulate rshift lshift bor band bnot bxor with-open"
		re_keywords='\\$ \\$1 \\$2 \\$3 \\$4 \\$5 \\$6 \\$7 \\$8 \\$9 \\$\\.\\.\\.'
		builtins="_G _VERSION arg assert bit32 collectgarbage coroutine debug
		          dofile error getfenv getmetatable io ipairs length load
		          loadfile loadstring math next os package pairs pcall
		          print rawequal rawget rawlen rawset require select setfenv
		          setmetatable string table tonumber tostring type unpack xpcall"

		join() { sep=$2; eval set -- $1; IFS="$sep"; echo "$*"; }

		# Add the language's grammar to the static completion list
		printf %s\\n "set-option global fennel_static_words $(join "${keywords} ${builtins} false nil true" ' ')"

		# Highlight keywords
		printf %s "
			add-highlighter shared/fennel/code/keywords regex \b($(join "${keywords} ${re_keywords}" '|'))\b 0:keyword
			add-highlighter shared/fennel/code/builtins regex \b($(join "${builtins}" '|'))\b 0:builtin
		"
	}
§

config-set-formatter fennel 'fnlfmt -'

config-enable-lsp-support fennel %{
	[fennel-ls]
	root_globs = [".git", ".hg", "flsproject.fnl", "main.fnl"]
}

hook global WinSetOption filetype=fennel %{
	require-module config-fennel
	config-setup-lisp-mode
}

hook global BufCreate .*/home/.+?/.fennelrc %{ set-option buffer filetype fennel }
