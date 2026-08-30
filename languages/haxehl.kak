provide-module haxe %§
	add-highlighter shared/haxe regions

	add-highlighter shared/haxe/double_string region '"' (?<!\\)(\\\\)*" group
	add-highlighter shared/haxe/double_string/ fill string

	add-highlighter shared/haxe/single_string region "'" (?<!\\)(\\\\)*' group
	add-highlighter shared/haxe/single_string/ fill string

	add-highlighter shared/haxe/regex region ~/ (?<!\\)(\\\\)*/[igmsu]* group
	add-highlighter shared/haxe/regex/ fill value
	add-highlighter shared/haxe/regex/ regex /\K[igmsu]*\z 0:meta

	add-highlighter shared/haxe/comment region /\* \*/ fill comment
	add-highlighter shared/haxe/line_comment region // (?<!\\)(?=\n) fill comment

	add-highlighter shared/haxe/macro region %{^\h*#} %{(?<!\\)(?=\n)|(?=//)} group
	add-highlighter shared/haxe/macro/ fill meta
	add-highlighter shared/haxe/macro/ regex /\*.*?\*/ 0:comment

	add-highlighter shared/haxe/code default-region group

	add-highlighter shared/haxe/code/ regex \b\d+(\.\d*)?([eE]-?\d+)?\b 0:value
	add-highlighter shared/haxe/code/ regex \b0x[\da-fA-F]+\b 0:value

	add-highlighter shared/haxe/code/ regex [-%*/+&\|<>!^]=?|=[=>]|\?[?.]|\?\?=|[?~:@]|<<=?|>>>?=?|\.\.\. 0:operator

	add-highlighter shared/haxe/code/ regex \w+\h*(?=\() 0:function

	add-highlighter shared/haxe/code/ regex \bvar\h+(\w+)\b 1:variable
	add-highlighter shared/haxe/code/ regex \b[A-Z_]\w*\b 0:type

	add-highlighter shared/haxe/code/ regex \babstract\h+.+?\h+(from)\h+.+?\h+(to)\h+.+?\h+ 1:keyword 2:keyword

	add-highlighter shared/haxe/code/ regex \b(abstract|public|private|static|final|inline|override|dynamic)\b 0:attribute
	add-highlighter shared/haxe/code/ regex \b(macro|try|throw|catch|cast|break|continue|do|dynamic|class|interface|implements|extends|super|function|return|var|new|this|enum|switch|case|default|typedef|for|if|else|in|import|package|extern|operator|overload|as)\b 0:keyword
	add-highlighter shared/haxe/code/ regex \b(Void|Bool|Int|Float|Null|Class|Enum|Any|Dynamic|EReg|String|Array|Map|IntIterator)\b 0:+b@type
	add-highlighter shared/haxe/code/ regex \b(true|false|null)\b 0:value
	add-highlighter shared/haxe/code/ regex \b(is)\b 0:operator
	add-highlighter shared/haxe/code/ regex \b(untyped)\b 0:meta
	add-highlighter shared/haxe/code/ regex \b(using)\b 0:module

	add-highlighter shared/haxe/code/ regex @:(isVar|op(?:tional)?|from|to|arrayAccess|enum|forward|generic)\b|\$type\b 0:meta

	add-highlighter shared/haxe/code/ regex \bpackage\h+(\w+)\b 1:module

	declare-option str-list haxe_static_words \
		abstract break case cast catch class continue default do dynamic else enum \
		extends extern false final for function if implements import in inline interface \
		macro new null operator overload override package private public return static \
		switch this throw true try typedef untyped using var while

	define-command -hidden haxe-trim-indent %<
		# remove the line if it's empty when leaving the insert mode
		try %{ execute-keys -draft x 1s^(\h+)$<ret> d }
	>

	define-command -hidden haxe-indent-on-closing-curly-brace %<
		evaluate-commands -draft -itersel -verbatim try %[
			# check if alone on the line and select to opening curly brace
			execute-keys <a-h><a-:><a-k>^\h+\}$<ret>hm
			# align to selection start
			execute-keys <a-S>1<a-&>
		]
	>

	define-command -hidden haxe-indent-on-newline %< evaluate-commands -draft -itersel %<
		execute-keys <semicolon>
		# else indent new lines with the same level as the previous one
		execute-keys -draft K <a-&>
		# remove previous empty lines resulting from the automatic indent
		try %< execute-keys -draft k x <a-k>^\h+$<ret> Hd >
		# indent after an opening brace or parenthesis at end of line
		try %< execute-keys -draft k x <a-k>[{(]\h*$<ret> j <a-gt> >
		# deindent closing brace(s) when after cursor
		try %< execute-keys -draft x <a-k> ^\h*[})] <ret> gh / [})] <esc> m <a-S> 1<a-&> >
	> >
§

hook global BufCreate .+\.hx$ %{ set-option buffer filetype haxe }

hook global WinSetOption filetype=haxe %§
	require-module haxe

	set-option window static_words %opt{haxe_static_words}

	hook -group haxe-trim-indent window ModeChange pop:insert:.* haxe-trim-indent
	# hook -group haxe-insert      window InsertChar \n            haxe-insert-on-newline
	hook -group haxe-indent      window InsertChar \n            haxe-indent-on-newline
	# hook -group haxe-indent      window InsertChar \{            haxe-indent-on-opening-curly-brace
	hook -group haxe-indent      window InsertChar \}            haxe-indent-on-closing-curly-brace
	# hook -group haxe-insert      window InsertChar \}            haxe-insert-on-closing-curly-brace

	hook -once -always window WinSetOption filetype=.* %{ remove-hooks window haxe-.+ }
§

hook -group haxe-highlight global WinSetOption filetype=haxe %§
	require-module haxe
	add-highlighter window/haxe ref haxe
	hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/haxe }
§
