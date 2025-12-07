source "%val{config}/prelude.kak"

config-log info welcome!

config-log info "operating system: %opt{config_os}"
if %opt{config_in_termux} %{ config-log info '(likely in Termux)' }

config-log info "display server: %opt{config_display_server}"

try %{
	evaluate-commands %sh{ case "$kak_session" in ''|*[!0-9]*) printf -- fail;; esac }
	try %{ rename-session main } catch %{ rename-session other } \
	catch %{ config-log trace "couldn't rename session" }
} catch %{
	config-log trace 'session name already set, will not default'
}

# holy shit it wasn't a "bug" with
# the std::function re-impl, it was a bug
# with my expansion handling and I was
# blaming the wrong thing :sob:
config-try-source "plugins"

# lesson learned; do *not* rely on autoload
# for setting up a portable configuration
config-try-source-directory "scripts"

config-try-source "mappings"
config-try-source "options"
config-try-source "commands"
config-try-source "hooks"

config-try-source "languages"
