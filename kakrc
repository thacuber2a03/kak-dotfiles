source "%val{config}/prelude.kak"

config-log info welcome!

config-log info "operating system: %opt{config_os}"
if %opt{config_in_termux} %{ config-log info '(likely in Termux)' }

config-log info "display server: %opt{config_display_server}"

# try to rename session to either "main" or "other"
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
config-log info "loading plugins..."; config-try-source "plugins"

# lesson learned; do *not* rely on autoload
# for setting up a portable configuration
config-log info "loading misc scripts..."; config-try-source-directory "scripts"

config-log info "loading mappings..."; config-try-source "mappings"
config-log info "loading options...";  config-try-source "options"
config-log info "loading commands..."; config-try-source "commands"
config-log info "loading hooks...";    config-try-source "hooks"

config-log info "loading language support scripts..."; config-try-source "languages"

config-log info "all done!"
