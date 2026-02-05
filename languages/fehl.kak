provide-module fe %{
	require-module lisp

	add-highlighter shared/fe regions
	add-highlighter shared/fe/ region ';' '$' fill comment

	add-highlighter shared/fe/string region '"' (?<!\\)(\\\\)*" group
	add-highlighter shared/fe/string/ fill string
	add-highlighter shared/fe/string/ regex '\\.' 0:value

	add-highlighter shared/fe/code default-region group

	add-highlighter shared/fe/code/ regex '(?i)\b[-\+]?0x[\da-f]+(?:\.[\da-f]+)?(?:p[-\+]?\d+)?' 0:value
	add-highlighter shared/fe/code/ regex '(?i)\b[-\+]?\d+(?:\.\d+)?(?:e[-\+]?\d+)?' 0:value
	add-highlighter shared/fe/code/ regex '(?i)\b[-\+]?inf(inity)?\b' 0:value
	add-highlighter shared/fe/code/ regex '(?i)\b[-\+]?nan\b' 0:value

	add-highlighter shared/fe/code/ regex '\b(?:nil|t)\b' 0:value

	add-highlighter shared/fe/code/ regex '(?:(?<![^\h()])|^)(<=?|\+|-|\*|/)(?:(?![^\h()])|$)' 0:operator

	add-highlighter shared/fe/code/ regex '(?:(?<![^\h()])|^)(let|if|fn|mac|while|quote|and|or|do|cons|car|cdr|setcar|setcdr|list|not|is|atom|print)(?:(?![^\h()])|$)' 0:keyword
	add-highlighter shared/fe/code/ regex '(?:(?<![^\h()])|^)=(?:(?![^\h()])|$)' 0:keyword

	define-command -hidden fe-trim-indent lisp-trim-indent

	declare-option \
		-docstring 'regex matching the head of forms which have options *and* indented bodies' \
		regex fe_special_indent_forms \
		'(?:let|if|fn|mac|while|quote|and|or|do|cons|car|cdr|setcar|setcdr|list|not|is|atom|print)'

	define-command -hidden fe-indent-on-new-line %{
		# registers: i = best align point so far; w = start of first word of form
		evaluate-commands -draft -save-regs '/"|^@iw' -itersel %{
			execute-keys -draft 'gk"iZ'
			try %{
				execute-keys -draft '[bl"i<a-Z><gt>"wZ'

				try %{
					# If a special form, indent another (indentwidth - 1) spaces
					execute-keys -draft '"wze<a-k>\A' %opt{fe_special_indent_forms} '\z<ret>'
					execute-keys -draft '"wze<a-L>s.{' %sh{printf $(( kak_opt_indentwidth - 1 ))} '}\K.*<ret><a-;>;"i<a-Z><gt>'
				} catch %{
					# If not "special" form and parameter appears on line 1, indent to parameter
					execute-keys -draft '"wz<a-K>[()\[\]{}]<ret>e<a-l>s\h\K[^\s].*<ret><a-;>;"i<a-Z><gt>'
				}
			}
			try %{ execute-keys -draft '[rl"i<a-Z><gt>' }
			try %{ execute-keys -draft '[Bl"i<a-Z><gt>' }
			execute-keys -draft ';"i<a-z>a&,'
		}
	}

	declare-option str-list fe_extra_word_chars \
		'_' '+' '-' '*' '/' '@' '$' '%' '^' '&' '_' '=' '<' '>' '~' '.' ':'
}

hook global BufCreate .+\.(fe|c7) %{ set-option buffer filetype fe }

hook global WinSetOption filetype=fe %{
	require-module fe

	set-option buffer indentwidth 2

	hook window ModeChange pop:insert:.* -group fe-indent fe-trim-indent
	hook window InsertChar \n            -group fe-indent fe-indent-on-new-line

	set-option buffer extra_word_chars %opt{fe_extra_word_chars}

	hook -once -always window WinSetOption filetype=.* %{ remove-hooks window fe-.+ }
}

hook -group fe-highlight global WinSetOption filetype=fe %{
	require-module fe
	add-highlighter window/fe ref fe
	hook -once -always window WinSetOption filetype=.* %{
		remove-highlighter window/fe
	}
}

hook global WinSetOption filetype=fe %{
	set-option buffer indentwidth 0
}
