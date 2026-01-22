hook global WinSetOption filetype=fe %{
	require-module fe
	config-setup-lisp-mode
}
