hook -group css-highlight global WinSetOption filetype=css %{
	add-highlighter window/hex_color_code ref hex_color_code
	hook -once -always window WinSetOption filetype=.* %{
		remove-highlighter window/hex_color_code
	}
}
