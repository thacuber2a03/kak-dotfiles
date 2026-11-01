hook global WinSetOption filetype=fe %{
	require-module fe
	set-option buffer indentwidth 2
	config-setup-lisp-mode
}
