try %{
	define-command -hidden true  -params 0 nop
	define-command -hidden false -params 0 fail

	define-command -hidden -docstring "
		if cond on-true [ on-false ]: yes
	" if -params 2..3 %{
		try %{
			%arg{1}
			evaluate-commands %arg{2}
		} catch %{
			evaluate-commands %arg{3}
		}
	}

	define-command -hidden -docstring "
		if-not cond on-false [ on-true ]: no
	" if-not -params 2..3 %{
		try %{
			%arg{1}
			evaluate-commands %arg{3}
		} catch %{
			evaluate-commands %arg{2}
		}
	}
}

declare-option -hidden bool config_trace_log_enabled false
declare-option -hidden str  config_log_separator_string '-----------------------------------------'

define-command -hidden config-fail -params .. %{ fail "config: %arg{@}" }
define-command -hidden config-log  -params .. %{ echo -debug -- "config: %arg{@}" }

define-command -hidden config-trace-log -params .. %{
	if %opt{config_trace_log_enabled} %{ config-log trace: %arg{@} }
}

define-command -hidden config-trace-log-separator -params 0 %{ config-trace-log %opt{config_log_separator_string} }

try %{
	evaluate-commands %sh{ case "$kak_session" in ''|*[!0-9]*) printf -- fail;; esac }
	try %{ rename-session main } catch %{ rename-session other } \
	catch %{ config-trace-log "couldn't rename session" }
} catch %{
	config-trace-log 'session name already set, will not default'
}

define-command -hidden config-try-source -params 1 %{
	config-trace-log-separator
	config-trace-log "sourcing %arg{1}"
	try %{
		source "%val{config}/%arg{1}"
		config-trace-log "finished sourcing %arg{1}"
	} catch %{
		config-trace-log "error sourcing %arg{1}: %val{error}"
	}
}

define-command -hidden config-try-source-directory -params 1 %{
	config-trace-log "sourcing directory '%arg{1}'"
	config-trace-log-separator
		evaluate-commands %sh{
			for f in "$kak_config"/"$1"/*.kak; do
				printf %s\\n "config-try-source ${f##*"$kak_config"/}" 
			done
		}
	config-trace-log "finished sourcing directory '%arg{1}'"
}

### system related stuff

declare-option str config_os

# quick shorthand to check for Termux
declare-option bool config_in_termux

evaluate-commands %sh{
	os=$(uname -o)
	[ "$os" = Android ] && printf %s\\n "set-option global config_in_termux true"
	printf %s\\n "set-option global config_os $os"
}

declare-option str config_display_server %sh{
	if [ -n "$WAYLAND_DISPLAY" ]; then
		printf -- "Wayland"
	elif [ -n "$DISPLAY" ]; then
		printf -- "X11"
	fi
}

config-log "operating system: %opt{config_os}"
if %opt{config_in_termux} %{ config-log '(likely in Termux)' }

config-log "display server: %opt{config_display_server}"

# TODO(thacuber2a03): funny.
# bugs with the re-implementation of std::function might be causing this.
# uncomment this line and comment everything else after it when it's fixed
# config-try-source "plugins.kak"
config-trace-log "sourcing plugins.kak"
config-trace-log-separator
try %{
	source "%val{config}/plugins.kak"
	config-trace-log "finished sourcing plugins.kak"
} catch %{
	config-trace-log "error sourcing plugins.kak: %val{error}"
}

# lesson learned; do *not* rely on autoload
# for setting up a portable configuration
config-try-source-directory 'scripts'

config-try-source "mappings.kak"
config-try-source "options.kak"
config-try-source "commands.kak"
config-try-source "hooks.kak"

config-try-source "languages.kak"
