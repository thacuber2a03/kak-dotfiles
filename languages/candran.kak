provide-module candran %§
	require-module lua

	add-highlighter shared/candran regions

	# currently copied from rc/filetype/lua.kak
	add-highlighter shared/candran/ region -match-capture   '\[(=*)\[' '\](=*)\]'        fill string
	add-highlighter shared/candran/ region -match-capture '--\[(=*)\[' '\](=*)\]'        fill comment
	add-highlighter shared/candran/ region                '"'          (?<!\\)(?:\\\\)*" fill string
	add-highlighter shared/candran/ region                "'"          (?<!\\)(?:\\\\)*' fill string
	add-highlighter shared/candran/ region                '--'         $                 fill comment

	add-highlighter shared/candran/macro region %{^\h*\K#} %{(?=\n)|(?=--)} fill meta # group
	# add-highlighter shared/candran/macro/ regex ^\h*(#\h*\S*) 1:meta

	add-highlighter shared/candran/table_comp  region -recurse '\[' '(?<==)\s*\[' '\]' group
	add-highlighter shared/candran/table_comp/ regex '[\[\]]' 0:operator
	add-highlighter shared/candran/table_comp/ ref candran/code

	add-highlighter shared/candran/code default-region group

	add-highlighter shared/candran/code/ ref lua/code
	add-highlighter shared/candran/code/ regex '@' 0:value
	add-highlighter shared/candran/code/ regex '[&\|]?=[&\|]?|\?[.:]|(?:\?(?=[\[\(]))' 0:operator
	add-highlighter shared/candran/code/ regex '(?<==)\s*(:)(?=\()' 1:function

	add-highlighter shared/candran/code/ regex '\b(let|const|close|continue|push)\h+?(?![\(\{"])' 1:keyword
	add-highlighter shared/candran/code/ regex '\b([a-zA-Z_]\w*)\h*(?=[\(\{"])' 1:function
	add-highlighter shared/candran/code/ regex '\b(let)\h*(?![\("])' 1:keyword
	add-highlighter shared/candran/code/ ref lua/code/keyword
	add-highlighter shared/candran/code/ regex ':([a-zA-Z_]\w*)' 1:function

	define-command -hidden candran-indent-on-new-line %<
		evaluate-commands -no-hooks -draft -itersel %<
			# remove trailing white spaces from previous line
			try %[ execute-keys -draft k : candran-trim-indent <ret> ]
			# preserve previous non-empty line indent
			try %[ execute-keys -draft ,gh<a-?>^[^\n]+$<ret>s\A|.\z<ret>)<a-&> ]
			# add one indentation level if the previous line is not a comment and:
			#     - starts with a block keyword that is not closed on the same line,
			#     - or contains an unclosed function expression,
			#     - or ends with an enclosed '(' or '{'
			try %< execute-keys -draft \
				, Kx \
				<a-K>\A\h*--<ret> \
				<a-K>\A[^\n]*\b(end|until)\b<ret> \
				<a-k>\A(\h*\b(do|else|elseif|for|(local\h+)?function|if|repeat|while)\b|[^\n]*[({\[]$|[^\n]*\bfunction\b\h*[(])<ret> \
				<a-:><semicolon><a-gt>
			>
		>
	>

	define-command -hidden candran-trim-indent        lua-trim-indent
	define-command -hidden candran-indent-on-char     lua-indent-on-char
	define-command -hidden candran-insert-on-new-line lua-insert-on-new-line
§

hook global BufCreate .+\.can %{ set-option buffer filetype candran }

hook -group candran-highlight global WinSetOption filetype=candran %{
	require-module candran
	add-highlighter window/candran ref candran
	hook -once -always window WinSetOption filetype=.* %{
		remove-highlighter window/candran
	}
}

hook global WinSetOption filetype=candran %{
	require-module candran

	hook window ModeChange pop:insert:.* -group candran-trim-indent candran-trim-indent
	hook window InsertChar .* -group candran-indent candran-indent-on-char
	hook window InsertChar \n -group candran-indent candran-indent-on-new-line
	hook window InsertChar \n -group candran-insert candran-insert-on-new-line

	hook -once -always window WinSetOption filetype=.* %{ remove-hooks window candran-.+ }
}
