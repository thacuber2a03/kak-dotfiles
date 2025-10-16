provide-module lox %§
	add-highlighter shared/lox regions

	add-highlighter shared/lox/ region '"' '"' fill string

	add-highlighter shared/lox/code default-region group

	add-highlighter shared/lox/code/ regex '\b(print)\b' 1:keyword

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
	hook -once -always window WinSetOption filetype.* %{
	}
}
