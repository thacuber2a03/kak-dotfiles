provide-module miniscript %§
	add-highlighter shared/miniscript regions
	add-highlighter shared/miniscript/ region // $ fill comment

	# string handling in this highlighter is cursed as hell
	add-highlighter shared/miniscript/string region '(?<!")"(?!")' '(?<!")"(?!")' group
	add-highlighter shared/miniscript/string/ fill string
	add-highlighter shared/miniscript/string/ regex '""' 0:value

	add-highlighter shared/miniscript/code default-region group

	add-highlighter shared/miniscript/code/ regex '""' 0:string

	add-highlighter shared/miniscript/code/ regex '(?:^|(?<=;))\s*(\w+)\s*=' 1:variable

	add-highlighter shared/miniscript/code/ regex '\w+\h*(?=\()' 0:function

	add-highlighter shared/miniscript/code/ regex '@[\w.\[\]]+' 0:function

	add-highlighter shared/miniscript/code/ regex '(-|\+|\*|/|\^|<=?|>=?|!?=|:|%|\.)' 0:operator

	add-highlighter shared/miniscript/code/ regex '\b\d+(\.\d+)?([Ee][-\+]?\d+)?\b' 0:value
	add-highlighter shared/miniscript/code/ regex '\b\.\d+([Ee][-\+]?\d+)?\b' 0:value

	add-highlighter shared/miniscript/code/ regex \
		\b(function|while|if|else|then|for|in|end|outer|new|return|continue|break)\b 0:keyword

	add-highlighter shared/miniscript/code/ regex \b(__isa)\b 0:meta

	add-highlighter shared/miniscript/code/ regex \b(and|or|not)\b 0:operator
	add-highlighter shared/miniscript/code/ regex \b(true|false|null|self)\b 0:value

	add-highlighter shared/miniscript/code/ regex \
		\b(abs|acos|asin|atan|bitAnd|bitOr|bitXor|ceil|char|cos|floor|log|pi|range|round|rnd|sign|sin|sqrt|str|tan|slice|globals|intrinsics|locals|print|refEquals|stackTrace|time|wait|yield)\b 0:builtin

	add-highlighter shared/miniscript/code/ regex \b(string|number|map|list)\b 0:type

	declare-option str-list miniscript_static_words \
		'function' 'while' 'if' 'else' 'then' 'for' 'in' 'end' 'outer' 'new' 'return' 'continue' 'break' \
		'and' 'or' 'not' 'true' 'false' 'null' 'self' 'abs' 'acos' 'asin' 'atan' 'bitAnd' 'bitOr' 'bitXor' \
		'ceil' 'char' 'cos' 'floor' 'log' 'pi' 'range' 'round' 'rnd' 'sign' 'sin' 'sqrt' 'str' 'tan' 'slice' \
		'globals' 'intrinsics' 'locals' 'print' 'refEquals' 'stackTrace' 'time' 'wait' 'yield' 'string' \
		'number' 'map' 'list'

	define-command -hidden miniscript-trim-indent %{
	    evaluate-commands -no-hooks -draft -itersel %{
	        execute-keys x
	        # remove trailing white spaces
	        try %{ execute-keys -draft s \h + $ <ret> d }
	    }
	}

	define-command -hidden miniscript-indent-on-char %[
	    evaluate-commands -no-hooks -draft -itersel %[
	        # unindent middle and end structures
	        try %[ execute-keys -draft \
	            <a-h><a-k>^\h*(\b(end|else)\b|[)}])$<ret> \
	            :miniscript-indent-on-new-line<ret> \
	            <a-lt>
	        ]
	    ]
	]

	define-command -hidden miniscript-insert-on-new-line %[
	    evaluate-commands -no-hooks -itersel %[
	        # copy // comment prefix and following white spaces
	        try %[ execute-keys -draft kxs^\h*\K//\h*<ret> y gh j x<semicolon> P ]
	        # wisely add end structure
	        evaluate-commands -save-regs xk %[
	            # save previous line indent in register x
	            try %[ execute-keys -draft kxs^\h+<ret>"xy ] catch %[ reg x '' ]
	            try %[
	                # check that starts with a block keyword that is not closed on the same line
	                try %[ execute-keys -draft \
	                    kx \
	                    <a-k>^\h*\b(else|for|if|while)\b|\bfunction\b[^(\h]*(?=[(\n])<ret>_"ky \
	                    <a-K>\bend\b<ret>
	                ]
	                # check that the block is empty and is not closed on a different line
	                execute-keys -draft <a-a>i <a-K>^[^\n]+\n[^\n]+\n<ret> jx <a-K>^<c-r>x\b(else|end)\b<ret>
	                # auto insert end
	                try %[ execute-keys -draft o<c-r>xend<space><esc>"kPxs<space>(else)<ret>d ] catch %[
			            info -style modal %val{error}
		            ]
	                # auto insert ) for anonymous function
	                execute-keys -draft kx<a-k>\([^)\n]*function\b<ret>jjA)<esc>
	            ]
	        ]
	    ]
	]

	define-command -hidden miniscript-indent-on-new-line %{
	    evaluate-commands -no-hooks -draft -itersel %{
	        # preserve previous line indent
	        try %{ execute-keys -draft K <a-&> }
	        # filter previous line
	        try %{ execute-keys -draft k : miniscript-trim-indent <ret> }
	        # indent after start structure
	        try %{ execute-keys -draft k x <a-k> ^ \h * (function|else|for|if|while|.+(?=\|)) [^0-9A-Za-z_!?] <ret> j <a-gt> }
	    }
	}

§

hook global BufCreate .+\.ms$ %{ set-option buffer filetype miniscript }

hook -group miniscript-highlight global WinSetOption filetype=miniscript %{
	require-module miniscript
	add-highlighter window/miniscript ref miniscript

	hook -once -always window WinSetOption filetype=.* %{
		remove-highlighter window/miniscript
	}
}

hook global WinSetOption filetype=miniscript %{
	require-module miniscript

	set-option window static_words %opt{miniscript_static_words}

    hook window ModeChange pop:insert:.* -group miniscript-trim-indent miniscript-trim-indent
    hook window InsertChar .* -group miniscript-indent miniscript-indent-on-char
    hook window InsertChar \n -group miniscript-indent miniscript-indent-on-new-line
    hook window InsertChar \n -group miniscript-insert miniscript-insert-on-new-line

	hook -once -always window WinSetOption filetype=.* %{
		remove-hooks window miniscript-.+
	}
}

