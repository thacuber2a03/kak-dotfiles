provide-module brainfuck %{
	add-highlighter shared/brainfuck regions
	add-highlighter shared/brainfuck/code default-region group
	add-highlighter shared/brainfuck/code/ regex '[^\[\]]+' 0:comment
	add-highlighter shared/brainfuck/code/ regex '[+-]'     0:operator
	add-highlighter shared/brainfuck/code/ regex '[><]'     0:value
	add-highlighter shared/brainfuck/code/ regex '[\.,]'    0:meta
}

hook global BufCreate .*\.bf %{
	set-option buffer filetype brainfuck
}

hook -group brainfuck-highlight global WinSetOption filetype=brainfuck %{
	require-module brainfuck
	add-highlighter window/brainfuck ref brainfuck
	hook window WinSetOption filetype=.* %{
		remove-highlighter window/brainfuck
	}
}
