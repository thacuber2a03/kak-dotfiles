try %{
	define-command true nop
	define-command false fail
}

declare-option -hidden bool config_log_enabled false
declare-option -hidden int config_log_indent_depth 0
declare-option -hidden str config_log_indent_string ' -->'
declare-option -hidden str config_log_separator_string '-----------------------------------------'

# copied code :(
define-command -hidden config-log-indent -params 0 %{ set-option global config_log_indent_depth %sh{ printf %d $(($kak_opt_config_log_indent_depth + 1)) } }
define-command -hidden config-log-dedent -params 0 %{ set-option global config_log_indent_depth %sh{ printf %d $(($kak_opt_config_log_indent_depth - 1)) } }

define-command -hidden config-log -params .. %{ try %{ %opt{config_log_enabled}; config-log-public %arg{@} } }

define-command -hidden config-log-public -params .. %{
	echo -debug -- %sh{
		depth="$kak_opt_config_log_indent_depth"
		i=0
		while [ "$i" -lt "$depth" ]; do
			printf -- "$kak_opt_config_log_indent_string"
			i=$((i+1))
		done
	} config: %arg{@}
}
define-command -hidden config-log-separator -params 0 %{ config-log %opt{config_log_separator_string} }

define-command -hidden config-fail -params .. %{ fail config: %arg{@} }

try %{
	evaluate-commands %sh{ case "$kak_session" in ''|*[!0-9]*) printf -- fail;; esac }
	try %{ rename-session main } catch %{ rename-session other } \
	catch %{ config-log "couldn't rename session" }
} catch %{
	config-log 'session name already set, will not default'
}

define-command -hidden config-try-source -params 1 %{
	config-log "sourcing %arg{1}"
	config-log-indent
	try %{
		source "%val{config}/%arg{1}"
		config-log-dedent
		config-log "finished sourcing %arg{1}"
	} catch %{
		config-log-dedent
		config-log "error sourcing %arg{1}: %val{error}"
	}
	config-log-separator
}

define-command -hidden config-try-source-directory -params 1 %{
	config-log "sourcing directory '%arg{1}'"
	config-log-indent
	evaluate-commands %sh{
		for f in "$kak_config"/"$1"/*.kak; do
			printf %s\\n "config-try-source ${f##*"$kak_config"/}" 
		done
	}
	config-log-dedent
	config-log "finished sourcing directory '%arg{1}'"
	config-log %opt{config_log_separator_string}
}

# system related stuff

declare-option str config_os %sh{uname -o}

declare-option str config_display_server %sh{
	if [ -n "$WAYLAND_DISPLAY" ]; then
		printf -- "Wayland"
	elif [ -n "$DISPLAY" ]; then
		printf -- "X11"
	fi
}

config-log-public "operating system: %opt{config_os}"
config-log-public "display server: %opt{config_display_server}"

# TODO(thacuber2a03): funny.
# bugs with the re-implementation of std::function might be causing this.
# uncomment this line and comment everything else after when it's fixed
# config-try-source "plugins.kak"
config-log "sourcing plugins.kak"
config-log-indent
try %{
	source "%val{config}/plugins.kak"
	config-log-dedent
	config-log "finished sourcing plugins.kak"
} catch %{
	config-log-dedent
	config-log "error sourcing plugins.kak: %val{error}"
}

# lesson learned; do *not* rely on autoload
# for setting up a portable configuration
config-try-source-directory 'scripts'

config-try-source "mappings.kak"
config-try-source "options.kak"
config-try-source "commands.kak"
config-try-source "hooks.kak"

config-try-source "languages.kak"
