# bit tired already of having to see my debug buffer filled with stuff
declare-option bool config_log_enabled false

define-command -hidden -params .. config-log  %{
	evaluate-commands %sh{
		[ "$kak_opt_config_log_enabled" = "true" ] && \
			printf %s "echo -debug config: $*"
	}
}
define-command -hidden -params .. config-fail %{ fail config: %arg{@} }

try %{
	rename-session main
	rename-client  main
}

define-command -hidden -params 1 config-try-source %{
	try %{
		config-log "sourcing %arg{1}"
		source "%val{config}/%arg{1}"
		config-log "finished sourcing %arg{1}"
	} catch %{
		config-log "couldn't source %arg{1}"
	}
}

config-try-source "plugins.kak"

config-try-source "mappings.kak"
config-try-source "options.kak"
config-try-source "commands.kak"
config-try-source "hooks.kak"

config-try-source "languages.kak"
