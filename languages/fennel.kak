hook global BufSetOption filetype=fennel %{
	set-option buffer formatcmd 'fnlfmt -'

	hook -once -always global BufSetOption filetype=.* %{
		unset-option buffer formatcmd
	}
}
