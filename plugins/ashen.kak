try %{
	evaluate-commands %sh{
		[ -z "$kak_opt_config_display_server" ] && \
		[ "$kak_opt_config_os" = Android ] && \
		printf %s\\n "fail"
	}

	colorscheme ashen
	set-face global LineNumberCursor Default
	# set-face global PrimaryCursor Default
	# set-face global PrimaryCursorEol Default
	set-option global ashen_dynamic_cursor true
	set-option global ashen_eol_cursor true
}
