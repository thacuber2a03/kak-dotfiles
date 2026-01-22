config-enable-lsp-support zig %{
	[zls]
	root_globs = ["build.zig", "build.zig.zon"]
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

define-command -docstring "
	zig [subcommand] [--] [<arguments>]: zig wrapping helper
	Available commands:
		build
		fetch
		zen
" zig -params 1.. %{
	evaluate-commands %sh{
		ansi='try %{ ansi-enable } # support for kak-ansi'
		jump='hook -group zig-hooks buffer NormalKey <ret> jump'

		sub="$1"
		shift

		color=off
		[ "$kak_opt_zig_enable_color" = true ] && color=on
		fifo="fifo -name *zig-$sub* -- zig $sub --color $color $*"
		printf %s\\n "$fifo" 2>&1

		case "$sub" in
		build)
			printf %s\\n "
				$fifo
				$ansi
				$jump
			"
		;;
		fetch)
			zig fetch "$*"
			printf %s\\n 'echo package fetched'
		;;
		zen)
			printf %s\\n "
				$fifo
				set-option buffer filetype markdown
			"
		;;
		esac
	}
}

complete-command -menu zig shell-script-candidates %{
	if [ "$kak_token_to_complete" = 0 ]; then
		printf %s\\n \
			build    \
			fetch    \
			zen      \
		;
	elif [ "$kak_token_to_complete" = 1 ]; then
		case "$1" in
		build) zig build --list-steps | awk '{print $1}' ;;
		fetch) printf %s\\n \
			--save          \
			--save=         \
			--save-exact    \
			--save-exact=   \
		;;
		esac
	fi
}
