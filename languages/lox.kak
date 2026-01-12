provide-module lox %§
	add-highlighter shared/lox regions

	add-highlighter shared/lox/ region '//' '$' fill comment
	add-highlighter shared/lox/ region '"' '"' fill string

	add-highlighter shared/lox/code default-region group

	add-highlighter shared/lox/code/ regex '(?i)([a-z_]\w*)\h*(?=\()' 1:function

	add-highlighter shared/lox/code/ regex '\b(print|fun|var|return|for|if|else|while|class)\b' 0:keyword
	add-highlighter shared/lox/code/ regex '\b(false|true|nil|this)\b' 0:value

	add-highlighter shared/lox/code/ regex '\bvar\h+(?i)([a-z_]\w*)' 1:variable

	add-highlighter shared/lox/code/ regex '\d+(?:\.\d+)?' 0:value

	add-highlighter shared/lox/code/ regex '\b(and|or)\b' 0:operator
	add-highlighter shared/lox/code/ regex '[-\+\*/]|(?:>|<|!|=)=?' 0:operator

	define-command -hidden lox-trim-indent %{
		# remove the line if it's empty when leaving the insert mode
		try %{ execute-keys -draft x 1s^(\h+)$<ret> d }
	}

	define-command -hidden lox-insert-on-newline %[ evaluate-commands -itersel -draft %[
		execute-keys <semicolon>
		try %[
			evaluate-commands -draft -save-regs '/"' %[
				# copy the commenting prefix
				execute-keys -save-regs '' k x1s^\h*(//+\h*)<ret> y
				try %[
					# if the previous comment isn't empty, create a new one
					execute-keys x<a-K>^\h*//+\h*$<ret> jxs^\h*<ret>P
				] catch %[
					# if there is no text in the previous comment, remove it completely
					execute-keys d
				]
			]

			# trim trailing whitespace on the previous line
			try %[ execute-keys -draft k x s\h+$<ret> d ]
		]
	] ]

	define-command -hidden lox-indent-on-newline %< evaluate-commands -draft -itersel %<
		execute-keys <semicolon>
		try %<
			# if previous line is part of a comment, do nothing
			execute-keys -draft <a-?>/\*<ret> <a-K>^\h*[^/*\h]<ret>
		> catch %<
			# else if previous line closed a paren (possibly followed by words and a comment),
			# copy indent of the opening paren line
			execute-keys -draft kx 1s(\))(\h+\w+)*\h*(\;\h*)?(?://[^\n]+)?\n\z<ret> m<a-semicolon>J <a-S> 1<a-&>
		> catch %<
			# else indent new lines with the same level as the previous one
			execute-keys -draft K <a-&>
		>
		# remove previous empty lines resulting from the automatic indent
		try %< execute-keys -draft k x <a-k>^\h+$<ret> Hd >
		# indent after an opening brace or parenthesis at end of line
		try %< execute-keys -draft k x <a-k>[{(]\h*$<ret> j <a-gt> >
		# indent after a statement not followed by an opening brace
		try %< execute-keys -draft k x s\)\h*(?://[^\n]+)?\n\z<ret> \
		                           <a-semicolon>mB <a-k>\A\b(if|for|while)\b<ret> <a-semicolon>j <a-gt> >
		try %< execute-keys -draft k x s \belse\b\h*(?://[^\n]+)?\n\z<ret> \
		                           j <a-gt> >
		# deindent after a single line statement end
		try %< execute-keys -draft K x <a-k>\;\h*(//[^\n]+)?$<ret> \
		                           K x s\)(\h+\w+)*\h*(//[^\n]+)?\n([^\n]*\n){2}\z<ret> \
		                           MB <a-k>\A\b(if|for|while)\b<ret> <a-S>1<a-&> >
		try %< execute-keys -draft K x <a-k>\;\h*(//[^\n]+)?$<ret> \
		                           K x s \belse\b\h*(?://[^\n]+)?\n([^\n]*\n){2}\z<ret> \
		                           <a-S>1<a-&> >
		# deindent closing brace(s) when after cursor
		try %< execute-keys -draft x <a-k> ^\h*[})] <ret> gh / [})] <esc> m <a-S> 1<a-&> >
		# align to the opening parenthesis or opening brace (whichever is first)
		# on a previous line if its followed by text on the same line
		try %< evaluate-commands -draft %<
			# Go to opening parenthesis and opening brace, then select the most nested one
			try %< execute-keys [c [({],[)}] <ret> >
			# Validate selection and get first and last char
			execute-keys <a-k>\A[{(](\h*\S+)+\n<ret> <a-K>"(([^"]*"){2})*<ret> <a-K>'(([^']*'){2})*<ret> <a-:><a-semicolon>L <a-S>
			# Remove possibly incorrect indent from new line which was copied from previous line
			try %< execute-keys -draft , <a-h> s\h+<ret> d >
			# Now indent and align that new line with the opening parenthesis/brace
			execute-keys 1<a-&> &
		 > >
	> >

	define-command -hidden lox-indent-on-opening-curly-brace %[
		# align indent with opening paren when { is entered on a new line after the closing paren
		try %[ execute-keys -draft -itersel h<a-F>)M <a-k> \A\(.*\)\h*\n\h*\{\z <ret> <a-S> 1<a-&> ]
		# align indent with opening paren when { is entered on a new line after the else
		try %[ execute-keys -draft -itersel hK x s \belse\b\h*(?://[^\n]+)?\n\h*\{<ret> <a-S> 1<a-&> ]
	]

	define-command -hidden lox-indent-on-closing-curly-brace %[
		evaluate-commands -draft -itersel -verbatim try %[
			# check if alone on the line and select to opening curly brace
			execute-keys <a-h><a-:><a-k>^\h+\}$<ret>hm
			try %[
				# in case open curly brace follows a closing paren possibly with qualifiers, extend to opening paren
				execute-keys -draft <a-f>) <a-k> \A\)(\h+\w+)*\h*\{\z <ret>
				execute-keys <a-F>)M
			]
			# align to selection start
			execute-keys <a-S>1<a-&>
		]
	]

	define-command -hidden lox-insert-comment-on-new-line %[
		evaluate-commands -no-hooks -draft -itersel %[
			# copy // comments prefix and following white spaces
			try %{ execute-keys -draft <semicolon><c-s>kx s ^\h*\K/{2,}\h* <ret> y<c-o>P<esc> }
		]
	]

§

hook global BufCreate .+\.lox$ %{ set-option buffer filetype lox }

hook -group lox-highlight global WinSetOption filetype=lox %{
	require-module lox
	add-highlighter window/lox ref lox
	hook -once -always window WinSetOption filetype=.* %{
		remove-highlighter window/lox
	}
}

hook global WinSetOption filetype=lox %{
	require-module lox

	hook -group lox-trim-indent window ModeChange pop:insert:.* lox-trim-indent
	hook -group lox-insert window InsertChar \n lox-insert-on-newline
	hook -group lox-indent window InsertChar \n lox-indent-on-newline
	hook -group lox-indent window InsertChar \{ lox-indent-on-opening-curly-brace
	hook -group lox-indent window InsertChar \} lox-indent-on-closing-curly-brace

	hook -once -always window WinSetOption filetype=.* %{
		remove-hooks lox-.+
	}
}
