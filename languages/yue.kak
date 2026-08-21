provide-module yue %§
	require-module moon

	add-highlighter shared/yue regions

	add-highlighter shared/yue/single_string region "'"  (?<!\\)(\\\\)*' fill string
	add-highlighter shared/yue/raw_comment   region -match-capture '--\[(=*)\[' '\](=*)\]' fill comment
	add-highlighter shared/yue/comment       region '--' '$'             fill comment

	add-highlighter shared/yue/double_string region '"'  (?<!\\)(\\\\)*" regions
	add-highlighter shared/yue/double_string/base default-region fill string
	add-highlighter shared/yue/double_string/interpolation region -recurse \{ \Q#{ \} fill meta

	add-highlighter shared/yue/code default-region group

	add-highlighter shared/yue/code/ ref moon/code
	add-highlighter shared/yue/code/ regex \b(global|as|close|const|default|macro|try|catch)\b 0:keyword
	add-highlighter shared/yue/code/ regex ^\h*global\h+[\*^]\h*$ 0:meta
	add-highlighter shared/yue/code/ regex ^\h*export\h+(default)\h+ 1:meta
	# TODO: make more robust
	add-highlighter shared/yue/code/ regex (?i)\b([0-9_]+(:?\.[0-9_])?(:?e-?[0-9_]+)?|0x[0-9a-f_]+|0b[01]+)\b 0:value
	add-highlighter shared/yue/code/ regex ::\w+ 0:function
	add-highlighter shared/yue/code/ regex \w+(\[(?:#(?:-?\d+)?)?\]) 1:operator
	add-highlighter shared/yue/code/ regex <\w*> 0:meta
	add-highlighter shared/yue/code/ regex \?|\|> 0:operator
	add-highlighter shared/yue/code/ regex \$\w+ 0:meta

	define-command -hidden yue-trim-indent moon-trim-indent
	define-command -hidden yue-indent-on-char moon-indent-on-char
	define-command -hidden yue-insert-on-new-line moon-insert-on-new-line

	define-command -hidden yue-indent-on-new-line %{
		evaluate-commands -draft -itersel %{
			# preserve previous line indent
			try %{ execute-keys -draft <semicolon> K <a-&> }
			# filter previous line
			try %{ execute-keys -draft k : yue-trim-indent <ret> }
			# indent after start structure
			try %{ execute-keys -draft k x <a-k> ^ \h * (class|else(if)?|for|if|switch|unless|when|while|with) \b | ([:=]|[-=]>) $ <ret> j <a-gt> }
		}
	}
§

provide-module config-yue %§
	require-module yue

	define-command -docstring "
		yue-preview <buffer>: compiles the yue code at <buffer> in a separate, scratch buffer;
		uses the current buffer if <buffer> is unspecified
	" yue-preview -params 0..1 %{
		evaluate-commands -save-regs 'a' %{
			set-register a %val{buffile}
			evaluate-commands %sh{ [ -n "$1" ] && printf %s "set-register a '$1'" }
			fifo -name '*yue-preview*' yue -p %reg{a}
			set-option buffer filetype lua
			try ui-line-numbers-enable
		}
	}
§

hook global WinSetOption filetype=yue %{
	require-module yue

	hook window ModeChange pop:insert:.* -group yue-trim-indent yue-trim-indent
	hook window InsertChar .* -group yue-indent yue-indent-on-char
	hook window InsertChar \n -group yue-insert yue-insert-on-new-line
	hook window InsertChar \n -group yue-indent yue-indent-on-new-line

	# alias window alt yue-alternative-file

	hook -once -always window WinSetOption filetype=.* %{
		remove-hooks window yue-.+
		# unalias window alt yue-alternative-file
	}
}

hook global WinSetOption filetype=yue %{ require-module config-yue }

hook -group yue-highlight global WinSetOption filetype=yue %{
	add-highlighter window/yue ref yue
	hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/yue }
}

hook global BufCreate .+\.yue %{
	set-option buffer filetype yue
}

