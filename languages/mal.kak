provide-module mal %{
	require-module lisp

	add-highlighter shared/mal regions
	add-highlighter shared/mal/ region ';' '$' fill comment
	add-highlighter shared/mal/ region '(?<!\\)(?:\\\\)*\K"' '(?<!\\)(?:\\\\)*"' fill string

	add-highlighter shared/mal/code default-region group
	add-highlighter shared/mal/code/ regex '-?\b\d+\b' 0:value
	add-highlighter shared/mal/code/ regex '\b(nil|true|false)\b' 0:value
	add-highlighter shared/mal/code/ regex '\b(quote|unquote|quasiquote|splice-unquote|deref)\b' 0:keyword
	add-highlighter shared/mal/code/ regex '\b(let\*|def!)\B' 0:keyword


	############################################################################################################################################

	declare-option str-list mal_static_words quote unquote quasiquote splice-unquote deref

	define-command -hidden mal-trim-indent lisp-trim-indent

	declare-option \
	    -docstring 'regex matching the head of forms which have options *and* indented bodies' \
	    regex mal_special_indent_forms \
	    '(?:let\*|def!)'

	define-command -hidden mal-indent-on-new-line %{
	    # registers: i = best align point so far; w = start of first word of form
	    evaluate-commands -draft -save-regs '/"|^@iw' -itersel %{
	        execute-keys -draft 'gk"iZ'
	        try %{
	            execute-keys -draft '[bl"i<a-Z><gt>"wZ'

	            try %{
	                # If a special form, indent another (indentwidth - 1) spaces
	                execute-keys -draft '"wze<a-K>[\s()\[\]\{\}]<ret><a-k>\A' %opt{mal_special_indent_forms} '\z<ret>'
	                execute-keys -draft '"wze<a-L>s.{' %sh{printf $(( kak_opt_indentwidth - 1 ))} '}\K.*<ret><a-;>;"i<a-Z><gt>'
	            } catch %{
	                # If not special and parameter appears on line 1, indent to parameter
	                execute-keys -draft '"wz<a-K>[()[\]{}]<ret>e<a-K>[\s()\[\]\{\}]<ret><a-l>s\h\K[^\s].*<ret><a-;>;"i<a-Z><gt>'
	            }
	        }
	        try %{ execute-keys -draft '[rl"i<a-Z><gt>' }
	        try %{ execute-keys -draft '[Bl"i<a-Z><gt>' }
	        execute-keys -draft ';"i<a-z>a&,'
	    }
	}

}

hook global BufCreate .*\.mal %{
	set-option buffer filetype mal
}

hook global -group mal-highlight WinSetOption filetype=mal %{
	require-module mal
	add-highlighter window/mal ref mal
	hook -once -always window WinSetOption filetype=.* %{
		remove-highlighter window/mal
	}
}

hook global WinSetOption filetype=mal %{
	set-option buffer static_words %opt{mal_static_words}

	hook window ModeChange pop:insert:.* -group mal-trim-indent mal-trim-indent
	hook window InsertChar \n -group mal-indent mal-indent-on-new-line

	set-option buffer extra_word_chars '_' . / * ? + - < > ! : "'"
	hook -once -always window WinSetOption filetype=.* %{ remove-hooks window mal-.+ }
}
