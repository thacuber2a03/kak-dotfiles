hook global BufCreate .*tmux.conf(\..+)? %{
	set-option buffer filetype conf
}
