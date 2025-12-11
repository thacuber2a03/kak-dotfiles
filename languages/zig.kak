config-enable-lsp-support zig %{
    [zls]
    root_globs = ["build.zig"]
    settings_section = "zls"

    [zls.settings.zls]
    inlay_hints_hide_redundant_param_names = true
}

define-command -docstring "
	zig [<arguments>]: zig wrapping helper
	Available commands:
		build
" zig -params 1.. %{
	fifo -name "*zig-%arg{1}*" -- zig %arg{@} --color on
	try %{ ansi-enable }
}

complete-command -menu zig shell-script-candidates %{
	if [ "$kak_token_to_complete" = 0 ]; then
		printf %s\\n \
			build \
		;
	elif [ "$kak_token_to_complete" = 1 ]; then
		case "$1" in
		build) zig build --list-steps | awk '{print $1}'
		esac
	fi
}
