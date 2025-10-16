provide-module json5 %{
	require-module json

	add-highlighter shared/json5 regions

	add-highlighter shared/json5/ region '//' '$'    fill comment
	add-highlighter shared/json5/ region '/\*' '\*/' fill comment

	add-highlighter shared/json5/string region "'" (?<!\\)(\\\\)*' fill string

	add-highlighter shared/json5/code default-region ref json
}

hook global BufCreate .+\.json5 %{ set-option buffer filetype json5 }

hook -group json5-highlight global WinSetOption filetype=json5 %{
	require-module json5
	add-highlighter window/json5 ref json5
	hook -once -always window WinSetOption filetype=.* %{
		remove-highlighter window/json5
	}
}
