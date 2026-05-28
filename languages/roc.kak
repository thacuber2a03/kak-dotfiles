provide-module roc %§
	add-highlighter shared/roc regions

	add-highlighter shared/roc/string region '"' '"' group
	add-highlighter shared/roc/string/ fill string
	add-highlighter shared/roc/string/interp regions
	add-highlighter shared/roc/string/interp/ region -recurse '\$\{' '\$\{' '\}' ref roc

	add-highlighter shared/roc/ region '##' '$' fill documentation
	add-highlighter shared/roc/ region '(?<!#)#' '$' fill comment

	add-highlighter shared/roc/code default-region group

	add-highlighter shared/roc/code/ regex '\b\d+(_\d+)*(?:(?:u|i)(?:8|16|32|64|128)|f(?:32|64)|dec)?\b' 0:value
	add-highlighter shared/roc/code/ regex '\b0b[01]+(_[01]+)*(?:(?:u|i)(?:8|16|32|64|128)|f(?:32|64)|dec)?\b' 0:value
	add-highlighter shared/roc/code/ regex '\b0x(?I)[\da-f]+(_[\da-f]+)*(?i)(?:(?:u|i)(?:8|16|32|64|128)|f(?:32|64)|dec)?\b' 0:value

	add-highlighter shared/roc/code/ regex '(->|[-+*^%!]|//?|[!=]=|\|\||&&|\|>|\?\??)' 0:operator

	add-highlighter shared/roc/code/ regex '([a-z_][\w_]*)\h*!?\h*=\h*(?=\|)' 1:function
	add-highlighter shared/roc/code/ regex '([a-z_][\w_]*)\h*!?\h*(?=\()' 1:function

	add-highlighter shared/roc/code/ regex '\b(as|crash|dbg|else|expect|expect-fx|if|import|is|return|then|try|when)\b' 1:keyword
	add-highlighter shared/roc/code/ regex '\b(app|exposes|exposing|generates|implements|module|package|packages|platform|requires|where|with)\b' 1:meta

	add-highlighter shared/roc/code/ regex '\b(Num|Bool|Str|Frac|Int|List)\b' 1:module
	add-highlighter shared/roc/code/ regex '\b(?:U|I)(?:8|16|32|64|128)\b' 0:type
	add-highlighter shared/roc/code/ regex '\bF(?:32|64)\b' 0:type
	add-highlighter shared/roc/code/ regex '\b(Ok|Err)\b' 0:type

	add-highlighter shared/roc/code/ regex '\t' 0:DiagnosticError

	declare-option str-list roc_static_words \
		'as' 'crash' 'dbg' 'else' 'expect' 'expect-fx' 'if' 'import' 'is' 'return' \
		'then' 'try' 'when' 'app' 'exposes' 'exposing' 'generates' 'implements' \
		'module' 'package' 'packages' 'platform' 'requires' 'where' 'with' \
		'Num' 'Bool' 'Str' 'Frac' 'Int' 'List'
§

hook global BufCreate .+\.roc %{
	set-option buffer filetype roc
}

hook -group roc-highlighting global WinSetOption filetype=roc %{
	require-module roc

	add-highlighter window/roc ref roc

	hook -once -always window WinSetOption filetype=.* %{
		remove-highlighter window/roc
	}
}

hook global WinSetOption filetype=roc %{
	require-module roc

	set-option buffer indentwidth 4
	set-option buffer static_words %opt{roc_static_words}
	set-option buffer extra_word_chars '_'

	hook window ModeChange pop:insert:.* -group roc-trim-indent roc-trim-indent
	hook window InsertChar \n -group roc-insert roc-insert-on-new-line
	hook window InsertChar \n -group roc-indent roc-indent-on-new-line

	hook -once -always window WinSetOption filetype=.* %{
	}
}

define-command -hidden roc-trim-indent %{
	# remove trailing white spaces
	try %{ execute-keys -draft -itersel x s \h+$ <ret> d }
}

define-command -hidden roc-insert-on-new-line %{
	evaluate-commands -draft -itersel %{
		# copy # comments prefix and following white spaces
		try %{ execute-keys -draft k x s ^\h*\K##?\h* <ret> y gh j P }
	}
}

define-command -hidden roc-indent-on-new-line %{
	evaluate-commands -draft -itersel %{
		# copy white spaces at the beginnig of the previous line
		try %{ execute-keys -draft k x s ^\h+ <ret> y jgh P x s \h+$ <a-d> }
		# increase indentation if the previous line ended with either '|' sign or then/else keyword
		try %{ execute-keys -draft k x s (\||\b(then|else))\h*$ <ret> j <a-gt> }
	}
}

