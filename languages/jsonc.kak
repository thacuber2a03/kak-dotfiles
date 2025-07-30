# there's basically nothing much to this file other than "json with comments"

provide-module jsonc %{
	require-module json

	add-highlighter shared/jsonc regions
	add-highlighter shared/jsonc/ region -recurse '/\*' '/\*' '\*/' fill comment
	add-highlighter shared/jsonc/ region '//' '$' fill comment
	add-highlighter shared/jsonc/json default-region ref json

	define-command -hidden jsonc-insert-comment-on-new-line %[
	    evaluate-commands -no-hooks -draft -itersel %[
	        # copy // comments prefix and following white spaces
	        try %{ execute-keys -draft <semicolon><c-s>kx s ^\h*\K/{2,}\h* <ret> y<c-o>P<esc> }
	    ]
	]
}

hook global BufCreate .+\.jsonc %{ set-option buffer filetype jsonc }

hook -group jsonc-highlight global WinSetOption filetype=jsonc %{
	require-module jsonc
	add-highlighter window/jsonc ref jsonc
	hook -once -always window WinSetOption filetype=.* %{
		remove-highlighter window/jsonc
	}
}

hook global WinSetOption filetype=jsonc %{
	require-module jsonc

    hook window ModeChange pop:insert:.* -group jsonc-trim-indent json-trim-indent
    hook window InsertChar .* -group jsonc-indent json-indent-on-char
    hook window InsertChar \n -group jsonc-indent json-indent-on-new-line
    hook window InsertChar \n -group jsonc-comment-insert jsonc-insert-comment-on-new-line

	hook -once -always window WinSetOption filetype=.* %{
		remove-highlighter window/jsonc
	}
}
