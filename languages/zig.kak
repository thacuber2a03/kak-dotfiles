config-enable-lsp-support zig %{
	[zls]
	root_globs = ["build.zig"]
	settings_section = "zls"

	[zls.settings.zls]
	inlay_hints_hide_redundant_param_names = true
}

hook global WinSetOption filetype=zig %{
	set-option -add window ui_whitespaces_flags -spc ' '
	ui-whitespaces-toggle
	ui-whitespaces-toggle

	set-option buffer indentwidth 4

	lsp-inlay-hints-disable window
}

declare-option -docstring "whether to enable colored output in Zig buffers" \
	bool zig_enable_color true
declare-option -docstring "whether to redirect stderr to Zig buffers" \
	bool zig_display_stderr true

define-command -docstring "
	zig [subcommand] [--] [<arguments>]: zig wrapping helper
	Available commands:
		build
" zig -params 1.. %{
	evaluate-commands %sh{
		stderr=
		if [ "$zig_display_stderr" = true ]; then
			stderr='>&2'
		fi
		sub="$1"
		shift
		if [ "$sub" = "build" ]; then
			color=off
			if [ "$kak_opt_zig_enable_color" = true ]; then
				color=on
			fi

			printf %s\\n "
				fifo -name '*zig-$sub*' -- zig $sub --color $color $* $stderr 
				try %{ ansi-enable } # support for kak-ansi
				hook -group zig-hooks buffer NormalKey <ret> jump
			"
		fi
	}
}

complete-command -menu zig shell-script-candidates %{
	if [ "$kak_token_to_complete" = 0 ]; then
		printf %s\\n \
			build \
		;
	else
		case "$1" in
		build) zig build --list-steps | awk '{print $1}' ;;
		esac
	fi
}
