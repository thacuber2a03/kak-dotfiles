evaluate-commands %sh{
	if [ -n "$kak_opt_config_display_server" ] ||
	[ "$kak_opt_config_os" = Android ]; then
		printf %s\\n "
			colorscheme ashen
			# hook global WinCreate .* %{ set-face global LineNumberCursor LineNumbers }
			set-option global ashen_dynamic_cursor true
			set-option global ashen_eol_cursor true
		"
	fi
}
