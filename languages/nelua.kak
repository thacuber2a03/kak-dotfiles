provide-module nelua %{
	require-module lua

	add-highlighter shared/nelua regions
	add-highlighter shared/nelua/code default-region group
	add-highlighter shared/nelua/code/ ref lua

	add-highlighter shared/nelua/code/ regex \
	'\b(auto|integer|number|boolean)\b' \
	0:type

	add-highlighter shared/nelua/code/ regex '@record(?=\{)' 0:meta
}

hook global BufCreate .*\.nelua %{
	set-option buffer filetype nelua
}

hook -group nelua-highlight global WinSetOption filetype=nelua %{
	require-module nelua
	add-highlighter window/nelua ref nelua
	hook -once -always window WinSetOption filetype=.* %{
		remove-highlighter window/nelua
	}
}

hook global WinSetOption filetype=nelua %{
	require-module nelua
}
