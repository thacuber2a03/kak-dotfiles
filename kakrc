try %{
	define-command true nop
	define-command false fail
}

declare-option str config_log_enabled true

define-command -hidden -params .. config-log %{ try %{
	%opt{config_log_enabled}
	echo -debug -- config: %arg{@}
} }

define-command -hidden -params .. config-fail %{ fail config: %arg{@} }

try %{
	evaluate-commands %sh{ case "$kak_session" in ''|*[!0-9]*) printf %s fail;; esac }
	try %{ rename-session main } catch %{ rename-session other } \
	catch %{ config-log "couldn't rename session" }
} catch %{
	config-log 'session name already set, will not default'
}

define-command -hidden -params 1 config-try-source %{
	try %{
		config-log "sourcing %arg{1}"
		source "%val{config}/%arg{1}"
		config-log "finished sourcing %arg{1}"
	} catch %{
		config-log "error sourcing %arg{1}: %val{error}"
	}
}

# system related stuff

declare-option str config_os %sh{uname -o}

declare-option str config_display_server %sh{
	if [ -n "$WAYLAND_DISPLAY" ]; then
		printf %s "Wayland"
	elif [ -n "$DISPLAY" ]; then
		printf %s "X11"
	fi
}

config-log "operating system: %opt{config_os}"
config-log "display server: %opt{config_display_server}"

# TODO(thacuber2a03): funny.
# bugs with the re-implementation of std::function might be causing this.
# uncomment this line and comment the next one when it's fixed
# config-try-source "plugins.kak"
source "%val{config}/plugins.kak"

# lesson learned; do *not* rely on autoload
# for setting up a portable configuration
config-log "sourcing extra scripts..."
evaluate-commands %sh{
	for f in "$kak_config"/scripts/*.kak; do
		echo "config-try-source ${f##*"$kak_config"/}"
	done
}
config-log "finished sourcing extra scripts"

config-try-source "mappings.kak"
config-try-source "options.kak"
config-try-source "commands.kak"
config-try-source "hooks.kak"

config-try-source "languages.kak"
