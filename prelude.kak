define-command -override -hidden true  -params 0 nop
define-command -override -hidden false -params 0 fail

define-command -override -hidden -docstring "
	if cond on-true [ on-false ]: yes
" if -params 2..3 %{
	try %{
		%exp{%arg{1}}
		evaluate-commands %arg{2}
	} catch %{
		evaluate-commands %arg{3}
	}
}

define-command -override -hidden -docstring "
	if-not cond on-false [ on-true ]: no
" if-not -params 2..3 %{
	if %arg{1} %arg{3} %arg{2}
}

define-command -hidden config-fail -params .. 'fail config: %arg{@}'

### logging

declare-option -hidden str config_default_log %{ echo -debug -- "%arg{@}" }

define-command -hidden config-trace-log -params .. nop
define-command -hidden config-info-log  -params .. nop

# define-command -hidden -override config-trace-log -params .. %opt{config_default_log}
define-command -hidden -override config-info-log  -params .. %opt{config_default_log}

# TODO: figure out how to take the log level out of %arg{@}
define-command -hidden config-log -params 2.. %{ %exp{config-%arg{1}-log} %arg{@} }

declare-option -hidden str config_current_source_directory "%val{config}"

define-command -hidden config-try-source -params 1 %{
	config-log trace '--------------------'
	config-log trace "sourcing %arg{1}.kak"

	# I give all my praises to the sole existence of this expansion type
	try %exp{
		source "%%opt{config_current_source_directory}/%arg{1}.kak"
		config-log trace "finished sourcing %arg{1}.kak"
	} catch %{
		config-log trace "error sourcing %arg{1}.kak: %val{error}"
	}
}

define-command -hidden config-try-source-directory -params 1 %{
	config-log trace "sourcing directory '%arg{1}'"
	set-option local config_current_source_directory "%opt{config_current_source_directory}/%arg{1}"
	evaluate-commands %sh{
		for f in "$kak_opt_config_current_source_directory"/*.kak; do
			dir=${f##*"$kak_opt_config_current_source_directory"/}
			printf %s\\n "config-try-source ${dir%.kak}" 
		done
	}
	config-log trace "finished sourcing directory '%arg{1}'"
}

### system related stuff

declare-option str config_os
declare-option str config_display_server

# flags for quick checks
declare-option bool config_in_wayland
declare-option bool config_in_x11
declare-option bool config_in_niri
declare-option bool config_in_termux

evaluate-commands %sh{
	os=$(uname -o)
	printf %s\\n "set-option global config_os $os"

	if [ -n "$WAYLAND_DISPLAY" ]; then
		printf %s\\n "set-option global config_display_server Wayland"
		printf %s\\n "set-option global config_in_wayland true"
	elif [ -n "$DISPLAY" ]; then
		printf %s\\n "set-option global config_display_server X11"
		printf %s\\n "set-option global config_in_x11 true"
	fi

	[ "$os" = Android ] && printf %s\\n "set-option global config_in_termux true"
	[ -s "$NIRI_SOCKET" ] && printf %s\\n "set-option global config_in_niri true"
}
