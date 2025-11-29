provide-module zenlisp %§
	add-highlighter shared/zenlisp regions
	add-highlighter shared/zenlisp/ region ';' '$' fill comment

	add-highlighter shared/zenlisp/code default-region group

	evaluate-commands %sh{
		keywords='and apply closure-form cond define dump-image eval lambda let letrec load or quote stats trace'

		builtins='atom bottom car cdr cons defined eq explode gc implode quit recursive-bind symbols verify-arrows'

		functions='require fold fold-r reverse append equal assoc assq listp map member memq null id list not neq
		           caaaar caaadr caadar caaddr cadaar cadadr caddar cadddr cdaaar cdaadr cdadar cdaddr cddaar cddadr cdddar cddddr
		           caaar caadr cadar caddr cdaar cdadr cddar cdddr caar cadr cdar cddr'

		values='t :t :f \(\)'

		join() { sep=$2; eval set -- $1; IFS="$sep"; echo "$*"; }

		printf %s\\n "declare-option str-list zenlisp_static_words $(join "${keywords} ${values} ${builtins} ${functions}" ' ')"

		printf %s "
			add-highlighter shared/zenlisp/code/ regex \b($(join "${keywords}" '|'))\b 0:keyword
			add-highlighter shared/zenlisp/code/ regex \b($(join "${values}" '|'))\b 0:value
			add-highlighter shared/zenlisp/code/ regex \b($(join "${builtins}" '|'))\b 0:builtin
			add-highlighter shared/zenlisp/code/ regex \b($(join "${functions}" '|'))\b 0:function
		"
	}

	declare-option str-list zenlisp_extra_word_chars '_' '+' '-' '*' '/' '@' '$' '%' '^' '&' '_' '=' '<' '>' '~'

	define-command -hidden zenlisp-trim-indent %{
		# remove trailing white spaces
		try %{ execute-keys -draft -itersel x s \h+$ <ret> d }
	}

	declare-option \
		-docstring 'regex matching the head of forms which have options *and* indented bodies' \
		regex zenlisp_special_indent_forms \
		'(?:def.*|if|let.*|lambda)'

	define-command -hidden zenlisp-indent-on-new-line %{
		# registers: i = best align point so far; w = start of first word of form
		evaluate-commands -draft -save-regs '/"|^@iw' -itersel %{
			execute-keys -draft 'gk"iZ'
			try %{
				execute-keys -draft '[bl"i<a-Z><gt>"wZ'

				try %{
					# If a special form, indent another (indentwidth - 1) spaces
					execute-keys -draft '"wze<a-k>\A' %opt{zenlisp_special_indent_forms} '\z<ret>'
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
§

hook global BufCreate .+\.zl %{ set-option buffer filetype zenlisp }

hook global WinSetOption filetype=zenlisp %{
	require-module zenlisp

	config-setup-lisp-mode

	hook window ModeChange pop:insert:.* -group zenlisp-trim-indent zenlisp-trim-indent
	hook window InsertChar \n -group zenlisp-indent zenlisp-indent-on-new-line
	set-option buffer extra_word_chars %opt{zenlisp_extra_word_chars}

	# set-option buffer zenlisp_special_indent_forms ''

	hook -once -always window WinSetOption filetype=.* %{ remove-hooks window zenlisp-.+ }
}

hook -group zenlisp-highlight global WinSetOption filetype=zenlisp %{
	require-module zenlisp
	add-highlighter window/zenlisp ref zenlisp
	hook -once -always window WinSetOption filetype=.* %{
		remove-highlighter window/zenlisp
	}
}
