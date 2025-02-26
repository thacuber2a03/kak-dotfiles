hook global WinSetOption filetype=haskell %{
	set-option buffer tabstop 8
	set-option buffer indentwidth 2

    add-highlighter window/no-tabs regex '\t' 0:Error
    hook -once -always window WinSetOption filetype=.* %{
	    remove-highlighter window/no-tabs
    }
}
