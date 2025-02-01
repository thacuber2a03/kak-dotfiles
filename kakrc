try %{ rename-session main }
try %{ rename-client  main }

define-command -hidden -params .. config-log  %{ echo -debug config: %arg{@} }
define-command -hidden -params .. config-fail %{ fail config: %arg{@}        }

define-command -hidden -params 1 config-try-source %{
	try %{
		source "%val{config}/%arg{1}"
		config-log "sourced %arg{1}"
	} catch %{
		config-log "couldn't source %arg{1}"
	}
}

config-try-source "plugins.kak"

config-try-source "mappings.kak"
config-try-source "options.kak"
config-try-source "commands.kak"
config-try-source "hooks.kak"

config-log "sourcing language files..."
evaluate-commands %sh{
	langsdir="languages"
	for f in $(ls "$kak_config/$langsdir"); do
		printf %s\\n "config-try-source $langsdir/$f"
	done
}
config-log "sourcing loading language files"

