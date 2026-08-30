provide-module revo %§
	add-highlighter shared/revo regions

	add-highlighter shared/revo/ region '#' $ fill comment

	add-highlighter shared/revo/double_string region '"' (?<!\\)(\\\\)*" group
	add-highlighter shared/revo/double_string/ fill string
	add-highlighter shared/revo/double_string/ regex \\n 0:value
	add-highlighter shared/revo/double_string/ regex '#\{\w+\}' 0:value

	add-highlighter shared/revo/single_string region "'" (?<!\\)(\\\\)*' fill string

	add-highlighter shared/revo/backtick_string region "`" (?<!\\)(\\\\)*` fill string

	add-highlighter shared/revo/code default-region group

	add-highlighter shared/revo/code/ regex [<>]=?|!?=|->|\|>|\||//|\?|[+*/~^-]= 0:operator
	add-highlighter shared/revo/code/ regex \b-?\d+(?:\.\d+)?\b 0:value

	add-highlighter shared/revo/code/ regex (\w+[?!]?)\h*(?=\() 1:function

	add-highlighter shared/revo/code/ regex \b(b?and|(bx?)?or|not|orelse|shl|shr)\b 0:+a@operator
	add-highlighter shared/revo/code/ regex (?<!:)\b(break|comp|const|continue|do|else|end|fn|for|global|if|import|in|join|let|loop|macro|match|proc|pub|return|skip|spawn|struct|suite|test|when|while|yield)\b 0:keyword

	add-highlighter shared/revo/code/ regex (?<=:)(\w+[?!]?)\h*(?=\() 1:function
	add-highlighter shared/revo/code/ regex \bfn\h+(\w+[?!]?)\h*(?=\() 1:function
	add-highlighter shared/revo/code/ regex \B:\w+\b(?!\() 0:value

	add-highlighter shared/revo/code/ regex (type)\h+(?i)([a-z_]\w*) 1:keyword 2:type

	add-highlighter shared/revo/code/ regex \|>\N+\b(_)\b 1:meta

	add-highlighter shared/revo/code/ regex (?:do|break)\h*/(\w+) 1:meta

	declare-option str-list revo_static_words \
		and band bor break bxor comp const continue do else end fn for global \
		if import in join let loop macro match not or orelse proc pub return \
		shl shr skip spawn struct suite test type when while yield

	define-command -hidden revo-trim-indent %[
		# remove trailing whitespaces
		try %[ execute-keys -draft -itersel x s \h+$ <ret> d ]
	]

	define-command -hidden revo-indent-on-char %[
		evaluate-commands -no-hooks -draft -itersel %[
			# unindent middle and end structures
			try %[ execute-keys -draft \
				<a-h><a-k>^\h*(\b(end|else)\b)$<ret> \
				:revo-indent-on-new-line<ret> \
				<a-lt>
			]
		]
	]

	define-command -hidden revo-indent-on-new-line %<
		evaluate-commands -no-hooks -draft -itersel %<
			# preserve previous line indent
			try %< execute-keys -draft <semicolon> K <a-&> >
			# cleanup trailing whitespaces from previous line
			try %< execute-keys -draft k x s \h+$ <ret> d >
			# indent after certain keywords
			try %< execute-keys -draft kx <a-k> '\b(else|if|fn|while|for|loop|proc|suite|test)\b.*$' <ret> j <a-gt> >
			# dedent back if a `do` or a `type` is found alongside the other keyword
			try %<
				execute-keys -draft \
					kx \
					<a-k> '\b(else|if|fn|while|for|loop|proc|suite|test)\b' <ret> \
					<a-k> '\b(do|type)\b' <ret> \
					j <a-lt>
			>
			# *always* indent after `do`
			try %< execute-keys -draft kx <a-k> '\bdo\b.*$' <ret> j <a-gt> >
			# indent after an opening brace or parenthesis at end of line
			try %< execute-keys -draft kx <a-k> '[{(]\h*$' <ret> j <a-gt> >
			# align to opening curly brace or paren when newline is inserted before a single closing
			try %< execute-keys -draft <a-h> <a-k> ^\h*[)}] <ret> h m <a-S> 1<a-&> >
		>
	>

	define-command -hidden revo-indent-on-closing-curly-brace %[
		evaluate-commands -draft -itersel -verbatim try %[
			# check if alone on the line and select to opening curly brace
			# then, align to selection start
			execute-keys <a-h><a-:><a-k>^\h+\}$<ret>hm<a-S>1<a-&>
		]
	]

	define-command -hidden revo-indent-on-closing-right-paren %[
		evaluate-commands -draft -itersel -verbatim try %[
			# check if alone on the line and select to opening curly brace
			# then, align to selection start
			execute-keys <a-h><a-:><a-k>^\h+\)$<ret>hm<a-S>1<a-&>
		]
	]
§

hook global BufCreate .+\.rv %{ set-option buffer filetype revo }

hook global WinSetOption filetype=revo %§
	require-module revo

	set-option window static_words %opt{revo_static_words}

	hook window -group revo-trim-indent ModeChange pop:insert:.* revo-trim-indent
	hook window -group revo-indent      InsertChar .*            revo-indent-on-char
	hook window -group revo-indent      InsertChar \n            revo-indent-on-new-line
	hook window -group revo-indent      InsertChar \}          revo-indent-on-closing-curly-brace
	hook window -group revo-indent      InsertChar \)          revo-indent-on-closing-right-paren

	hook -once -always window WinSetOption filetype=.* %{ remove-hooks window revo-.+ }
§

hook -group revo-highlight global WinSetOption filetype=revo %{
	require-module revo
	add-highlighter window/revo ref revo
	hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/revo }
}
