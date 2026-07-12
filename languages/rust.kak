config-enable-default-lsp-support rust

hook global WinSetOption filetype=rust %{
	try %{
		set-option -add window ui_whitespaces_flags -spc ' '
		ui-whitespaces-toggle
		ui-whitespaces-toggle
	}

	set-option buffer indentwidth 4
}
