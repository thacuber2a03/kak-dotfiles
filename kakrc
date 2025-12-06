define-command -override -hidden true  -params 0 nop
define-command -override -hidden false -params 0 fail

define-command -override -hidden -docstring "
	if cond on-true [ on-false ]: yes
" if -params 2..3 %{
	try %{
		%arg{1}
		try "evaluate-commands %arg{2}"
	} catch %{
		try "evaluate-commands %arg{3}"
	}
}

define-command -override -hidden -docstring "
	if-not cond on-false [ on-true ]: no
" if-not -params 2..3 %{
	if %arg{1} %arg{3} %arg{2}
}

declare-option -hidden bool config_trace_log_enabled false

define-command -hidden config-fail -params .. 'fail config: %arg{@}'
define-command -hidden config-log  -params .. 'echo -debug -- config: %arg{@}'

define-command -hidden config-trace-log -params .. %{
	if %opt{config_trace_log_enabled} "echo -debug -- config (trace): %arg{@}"
}

define-command -hidden config-trace-log-separator %{ config-trace-log '--------------------' }

try %{
	evaluate-commands %sh{ case "$kak_session" in ''|*[!0-9]*) printf -- fail;; esac }
	try %{ rename-session main } catch %{ rename-session other } \
	catch %{ config-trace-log "couldn't rename session" }
} catch %{
	config-trace-log 'session name already set, will not default'
}

define-command -hidden config-try-source -params 1 %{
	config-trace-log-separator
	config-trace-log "sourcing %arg{1}.kak"
	# I give all my praises to the sole existence of this expansion type
	try %exp{
		source "%val{config}/%arg{1}.kak"
		config-trace-log "finished sourcing %arg{1}.kak"
	} catch %{
		config-trace-log "error sourcing %arg{1}.kak: %val{error}"
	}
}

define-command -hidden config-try-source-directory -params 1 %{
	config-trace-log "sourcing directory '%arg{1}'"
	evaluate-commands %sh{
		for f in "$kak_config"/"$1"/*.kak; do
			dir=${f##*"$kak_config"/}
			printf %s\\n "config-try-source ${dir%.kak}" 
		done
	}
	config-trace-log "finished sourcing directory '%arg{1}'"
}

### system related stuff

declare-option str config_os
declare-option str config_display_server

# quick shorthand to check for Termux
declare-option bool config_in_termux

evaluate-commands %sh{
	os=$(uname -o)
	[ "$os" = Android ] && printf %s\\n "set-option global config_in_termux true"
	printf %s\\n "set-option global config_os $os"

	if [ -n "$WAYLAND_DISPLAY" ]; then
		printf -- "set-option global config_display_server Wayland"
	elif [ -n "$DISPLAY" ]; then
		printf -- "set-option global config_display_server X11"
	fi
}

config-log "operating system: %opt{config_os}"
if %opt{config_in_termux} %{ config-log '(likely in Termux)' }

config-log "display server: %opt{config_display_server}"

# holy shit it wasn't a "bug" with std::function
# it was a bug with my expansion handling
# and I was blaming the wrong thing sob
config-try-source "plugins"

# lesson learned; do *not* rely on autoload
# for setting up a portable configuration
config-try-source-directory "scripts"

config-try-source "mappings"
config-try-source "options"
config-try-source "commands"
config-try-source "hooks"

config-try-source "languages"
