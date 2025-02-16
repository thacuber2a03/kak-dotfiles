provide-module whitespace %§
	face global WhitespaceSpace red+r
	face global WhitespaceTab blue+r

	add-highlighter shared/whitespace regions
	add-highlighter shared/whitespace/code default-region group
	add-highlighter shared/whitespace/code/ regex '.+'  0:comment
	add-highlighter shared/whitespace/code/ regex ' +'  0:WhitespaceSpace
	add-highlighter shared/whitespace/code/ regex '\t+' 0:WhitespaceTab
§

hook global BufCreate .*\.ws %{
	set-option buffer filetype whitespace
}

hook global -group whitespace-highlight WinSetOption filetype=whitespace %{
	# try %{ ui-trailing-spaces-disable }
	require-module whitespace
	add-highlighter window/whitespace ref whitespace
	hook window WinSetOption filetype=.* %{
		# try %{ ui-trailing-spaces-enable }
		remove-highlighter window/whitespace
	}
}
